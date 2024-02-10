//
//  DevicesViewModel.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 04/01/2024.
//

import Foundation
import Network
import SwiftData

extension DevicesView {
    @Observable
    class ViewModel {
        private var deviceManager = DeviceManager.shared
        
        private(set) var devices = [Device]()
        private(set) var searchingForDevices = false
        
        var searchText = "" {
            didSet {
                fetchDevices()
            }
        }
        
        var selection = Set<String>()
        var renaming = ""
        
        init() {
            fetchDevices()
        }
        
        func fetchDevices() {
            DispatchQueue.main.async {
                self.devices = self.deviceManager.get(matching: self.searchText)
            }
        }
        
        func findDevices() {
            self.searchingForDevices = true
            
            MagicHome.scan { clients, error in
                DispatchQueue.main.async { [weak self] in
                    if error != nil {
                        self?.searchingForDevices = false
                        
                        return
                    }
                    
                    clients?.forEach { client in
                        guard let device = self?.deviceManager.get(client.id) else {
                            let state = DeviceState(on: false, color: .clear)
                            let device = Device(id: client.id, name: client.model, address: NWEndpoint.Host(client.address), available: false, state: state)
                            
                            self?.deviceManager.create(device)
                                                        
                            return
                        }
                        
                        device.address = NWEndpoint.Host(client.address)
                    }
                    
                    self?.searchingForDevices = false
                    self?.fetchDevices()
                }
            }
        }
        
        func deleteDevices() {
            DispatchQueue.main.async {
                self.deviceManager.delete(for: Array(self.selection))
                
                self.selection.removeAll()
                self.fetchDevices()
            }
        }
        
        func queryState() {
            devices.forEach { device in
                let controller = MagicHome(address: device.address)
                
                controller.queryState { data, error in
                    DispatchQueue.main.async { [weak self] in
                        if error != nil {
                            device.available = false
                        }
                        
                        if let state = data {
                            device.available = true
                            device.state.on = state.on
                            device.state.color = state.color
                        }
                        
                        self?.fetchDevices()
                    }
                }
            }
        }
    }
}
