//
//  ToggleDeviceStateIntent.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 09/01/2024.
//

import AppIntents
import OSLog

struct ToggleDeviceState: AppIntent {
    static var title: LocalizedStringResource = "Toggle Device State"
    static let description = IntentDescription("Switches the state of the selected device.", categoryName: "Utilities")

    static let openAppWhenRun: Bool = false
    
    static var parameterSummary: some ParameterSummary {
        Summary("Toggle state on \(\.$device)")
    }
    
    @Parameter(title: "Device", description: "The device which state to toggle.")
    var device: DeviceEntity
    
    @Dependency
    var deviceManager: DeviceManager
    
    @MainActor
    func perform() async throws -> some IntentResult {
        Logger.intentLogging.debug("[ToggleDeviceState] Toggling device state")
        
        do {
            let state = try await QueryDeviceState(device: device).perform()
            
            if state.value != .notAvailable {
                let _ = try await SetDeviceState(device: device, state: state.value != .online).perform()
            }
        } catch {
            Logger.intentLogging.debug("[ToggleDeviceState] An error occurred: \(error.localizedDescription)")
        }
        
        return .result()
    }
}
