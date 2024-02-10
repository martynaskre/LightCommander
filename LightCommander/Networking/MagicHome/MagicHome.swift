//
//  MagicHomeDevice.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 05/01/2024.
//

import Foundation
import Network

class MagicHome {
    typealias CompletionHandler<T> = (_ data: T?, _ error: Error?) -> Void
    
    static private let DISCOVERY_MESSAGE = "HF-A11ASSISTHREAD"
    static private let PORT: NWEndpoint.Port = 5577
    static private let COMMAND_TIMEOUT: TimeInterval = 1
    static private let RECEIVE_TIMEOUT: TimeInterval = 0.5
    
    private var commands = [(Data, (Error?, Data?) -> Void)]()
    private var receivedBuffer: Data!
    
    private var receiveTimeout: DispatchWorkItem!
    private var commandTimeout: DispatchWorkItem!
    
    private var connection: NWConnection!
    private var address: NWEndpoint.Host
    
    init(address: NWEndpoint.Host) {
        self.address = address
    }
    
    static func scan(_ timeout: TimeInterval = 5, completion: @escaping CompletionHandler<[MagicHomeClient]>) {
        var clients = [MagicHomeClient]()
        let endpoint = NWEndpoint.hostPort(host: "224.0.0.1", port: 48899)
        
        let multicast: NWMulticastGroup
        
        do {
            multicast = try NWMulticastGroup(for: [endpoint])
        } catch let error {
            completion(clients, error)
            
            return
        }
        
        let group = NWConnectionGroup(with: multicast, using: .udp)
        
        group.setReceiveHandler(maximumMessageSize: 16384, rejectOversizedMessages: true) { (originalMessage, content, isComplete) in
            if
                let content = content,
                let message = String(data: content, encoding: .utf8),
                message != self.DISCOVERY_MESSAGE {
                let tmpInfos = message.split(separator: ",").map(String.init)
                
                if tmpInfos.count == 3 {
                    clients.append(MagicHomeClient(id: tmpInfos[1], address: tmpInfos[0], model: tmpInfos[2]))
                }
            }
        }
        
        group.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .ready:
                group.send(content: self.DISCOVERY_MESSAGE.data(using: .utf8)) { error in
                    if let error = error {
                        completion(clients, error)
                        
                        group.cancel()
                    }
                }
            case .failed:
                group.cancel()
            default:
                break
            }
        }
        
        group.start(queue: .global())
        
        DispatchQueue.global().asyncAfter(deadline: .now() + timeout) {
            group.cancel()
            
            completion(clients, nil)
        }
    }
    
    func setPower(_ state: Bool, completion: @escaping CompletionHandler<Data>) {
        let command: [UInt8] = [0x71, (state) ? 0x23 : 0x24, 0x0f];
        
        self.sendCommand(buffer: command) { error, data in
            if let error = error {
                completion(nil, error)
                
                return
            }
            
            completion(data, nil)
        }
    }
    
    func queryState(_ completion: @escaping CompletionHandler<MagicHomeState>) {
        let command: [UInt8] = [0x81, 0x8a, 0x8b]
        
        self.sendCommand(buffer: command) { error, data in
            if let error = error {
                completion(nil, error)
                
                return
            }
            
            if let data = data {
                if data.count < 14 {
                    completion(nil, ControllerError.badResponse)
                    
                    return
                }
                
                let state = MagicHomeState(on: (data[2] == 0x23), red: data[6], green: data[7], blue: data[8])
                
                completion(state, nil)
            }
        }
    }
    
    func setColor(red: Int, green: Int, blue: Int, brightness: Int, completion: @escaping CompletionHandler<Data>) {
        let command: [UInt8] = [0x31, UInt8(red), UInt8(green), UInt8(blue), UInt8(0), UInt8(0), 0x0f]
        
        self.sendCommand(buffer: command) { error, data in
            completion(data, error)
        }
    }
        
    private func sendCommand(buffer: [UInt8], completion: @escaping (Error?, Data?) -> Void) {
        let command = self.prepareCommand(buffer: buffer)
        
        self.commands.append((command, completion))
        
        if self.connection == nil {
            self.setupConnection() {
                self.handleNextCommand()
            }
        }
    }
    
    private func prepareCommand(buffer: [UInt8]) -> Data {
        var checksum: UInt8 = 0
        
        for byte in buffer {
            checksum = checksum &+ byte
        }
        
        checksum = checksum & 0xFF
        
        var command = Data(buffer)
        
        command.append(Data([checksum]))
        
        return command
    }
    
    private func setupConnection(completion: @escaping () -> Void) {
        self.connection = NWConnection(host: self.address, port: MagicHome.PORT, using: .tcp)
        
        self.connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                completion()
            case .failed:
                self.connection.cancel()
            default:
                break
            }
        }
        
        self.connection.start(queue: .main)
    }
    
    private func handleNextCommand() {
        if self.commands.count == 0 {
            self.connection.cancel()
            self.connection = nil
        } else {
            let command = self.commands[0]
            
            self.send(command: command.0) { error in
                if let error = error {
                    command.1(error, nil)
                    
                    return
                }
                
                self.commandTimeout = DispatchWorkItem { [weak self] in
                    if let instance = self {
                        instance.handleCommandTimeout()
                    }
                }
                
                DispatchQueue.global().asyncAfter(deadline: .now() + MagicHome.COMMAND_TIMEOUT, execute: self.commandTimeout)
            }
            
            self.receiveData(completion: command.1)
        }
    }
    
    private func handleCommandTimeout() {
        if let commandTimeout = self.commandTimeout {
            commandTimeout.cancel()
        }
        
        let command = self.commands[0]
        
        command.1(nil, nil)
        
        self.receivedBuffer = nil
        
        self.commands.removeFirst()
        
        self.handleNextCommand()
    }
    
    private func send(command: Data, completion: @escaping (Error?) -> Void) {
        self.connection.send(content: command, completion: .contentProcessed { error in
            completion(error)
        })
    }
    
    private func receiveData(completion: @escaping (Error?, Data?) -> Void) {
        self.connection?.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, context, isComplete, error) in
            if let data = data {
                if self.receivedBuffer == nil {
                    self.receivedBuffer = data
                } else {
                    self.receivedBuffer.append(data)
                }
            }
            
            if let receiveTimeout = self.receiveTimeout {
                receiveTimeout.cancel()
            }
            
            self.receiveTimeout = DispatchWorkItem { [weak self] in
                if let instance = self {
                    completion(nil, instance.receivedBuffer)
                    
                    instance.receivedBuffer = nil
                }
            }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + MagicHome.RECEIVE_TIMEOUT, execute: self.receiveTimeout)
            
            self.receiveData(completion: completion)
        }
    }
}
