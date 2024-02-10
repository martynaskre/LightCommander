//
//  SetDeviceState.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 06/02/2024.
//

import AppIntents
import OSLog

struct SetDeviceState: AppIntent {
    static var title: LocalizedStringResource = "Set Device State"
    static let description = IntentDescription("Sets the state for the selected device.", categoryName: "Utilities")

    static let openAppWhenRun: Bool = false
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set \(\.$state) on \(\.$device)")
    }
    
    init() {}
    
    init(device: DeviceEntity, state: Bool) {
        self.device = device
        self.state = state
    }
    
    @Parameter(title: "Device", description: "The device which state to set.")
    var device: DeviceEntity
    
    @Parameter(title: "State", description: "State to set for the device.")
    var state: Bool
    
    @Dependency
    var deviceManager: DeviceManager
    
    @MainActor
    func perform() async throws -> some IntentResult {
        Logger.intentLogging.debug("[SetDeviceState] Toggling device state")
        
        guard let device = deviceManager.get(device.id) else {
            Logger.intentLogging.debug("[SetDeviceState] Device with ID \(device.id) not found")
            
            return .result()
        }
        
        let controller = MagicHome(address: device.address)
        
        controller.setPower(state) { _,_ in }
        
        return .result()
    }
}
