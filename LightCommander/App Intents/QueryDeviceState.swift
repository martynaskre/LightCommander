//
//  QueryDeviceState.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 06/02/2024.
//

import AppIntents
import OSLog

struct QueryDeviceState: AppIntent {
    static var title: LocalizedStringResource = "Query Device State"
    static let description = IntentDescription("Queries the state of the selected device.", categoryName: "Utilities")

    static let openAppWhenRun: Bool = false
    
    static var parameterSummary: some ParameterSummary {
        Summary("Query state of \(\.$device)")
    }
    
    init() { }
    
    init(device: DeviceEntity) {
        self.device = device
    }
    
    @Parameter(title: "Device", description: "The device which state to query.")
    var device: DeviceEntity
    
    @Dependency
    var deviceManager: DeviceManager
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<QueriedDeviceState> {
        Logger.intentLogging.debug("[QueryDeviceState] Querying device state")
        
        guard let device = deviceManager.get(device.id) else {
            Logger.intentLogging.debug("[QueryDeviceState] Device with ID \(device.id) not found")
            
            return .result(value: .notAvailable)
        }
        
        let controller = MagicHome(address: device.address)
        
        let state = await withCheckedContinuation { continuation in
            controller.queryState { data, error in
                if let state = data {
                    continuation.resume(returning: state.on ? QueriedDeviceState.online : QueriedDeviceState.offline)
                } else {
                    continuation.resume(returning: QueriedDeviceState.notAvailable)
                }
            }
        }
        
        return .result(value: state)
    }
}
