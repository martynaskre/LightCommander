//
//  DataController.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 04/01/2024.
//

import Foundation
import SwiftData
import Network

@MainActor
class DataController {
#if DEBUG
    static let shared = DataController(inMemory: true, initPreviewData: ProcessInfo.processInfo.isSwiftUIPreview)
#else
    static let shared = DataController()
#endif
    
    private static let schema = Schema([
        Device.self,
        DeviceState.self,
        Preset.self
    ])
    
    let container: ModelContainer
    
    init(inMemory: Bool = false, initPreviewData: Bool = false) {
        let modelConfiguration = ModelConfiguration(schema: DataController.schema, isStoredInMemoryOnly: inMemory)

        do {
            container = try ModelContainer(for: DataController.schema, configurations: [modelConfiguration])
            
            if initPreviewData {
                initializePreviewData()
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func initializePreviewData() {
        for i in 1...9 {
            let state = DeviceState(on: false, color: .orange)
            let device = Device(id: "\(i)", name: "Device \(i)", address: NWEndpoint.Host("127.0.0.1"), available: true, state: state)
            
            container.mainContext.insert(device)
        }
        
        container.mainContext.insert(Preset(color: .orange))
    }
}
