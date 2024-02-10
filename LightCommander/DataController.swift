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
    static let shared = DataController()
    
    static let previewContainer: ModelContainer = {
        let container = DataController().container
        
        for i in 1...9 {
            let state = DeviceState(on: false, color: .orange)
            let device = Device(id: "\(i)", name: "Device \(i)", address: NWEndpoint.Host("127.0.0.1"), available: true, state: state)
            
            container.mainContext.insert(device)
        }
        
        container.mainContext.insert(Preset(color: .orange))

        return container
    }()
    
    let container: ModelContainer
    
    init(inMemory: Bool = true) {
        let schema = Schema([
            Device.self,
            DeviceState.self,
            Preset.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)

        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
