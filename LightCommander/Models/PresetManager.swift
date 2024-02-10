//
//  PresetManager.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 09/02/2024.
//

import Foundation
import SwiftData
import OSLog

class PresetManager: @unchecked Sendable {
    static let shared = PresetManager()
    
    private var container: ModelContainer {
        return DataController.shared.container
    }
    
    @MainActor
    func get() -> [Preset] {
        do {
            let descriptor = FetchDescriptor<Preset>(sortBy: [SortDescriptor(\.createdAt, order: .forward)])
            
            return try container.mainContext.fetch(descriptor)
        } catch {
            Logger.dataManagerLogging.error("[PresetManager] An error occurred while fetching presets: \(error)")
            
            return []
        }
    }
    
    @MainActor
    func create(_ preset: Preset) {
        container.mainContext.insert(preset)
    }
    
    @MainActor
    func delete(_ identifier: UUID) {
        do {
            try container.mainContext.delete(model: Preset.self, where: #Predicate { preset in
                return preset.id == identifier
            })
        } catch {
            Logger.dataManagerLogging.error("[PresetManager] An error occurred while deleting device by ID \(identifier): \(error)")
        }
    }
}
