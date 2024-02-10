//
//  DeviceManager.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 05/02/2024.
//

import Foundation
import SwiftData
import OSLog

class DeviceManager: @unchecked Sendable {
    static let shared = DeviceManager()
    
    private var container: ModelContainer {
        return DataController.shared.container
    }
    
    @MainActor
    func get() -> [Device] {
        do {
            let descriptor = FetchDescriptor<Device>(sortBy: [SortDescriptor(\.name)])
                        
            return try container.mainContext.fetch(descriptor)
        } catch {
            Logger.dataManagerLogging.error("[DeviceManager] An error occurred while fetching devices: \(error)")
            
            return []
        }
    }
    
    @MainActor
    func get(_ identifier: String) -> Device? {
        do {
            var descriptor = FetchDescriptor<Device>(predicate: #Predicate { device in
                return device.id == identifier
            })
            descriptor.fetchLimit = 1
            
            let devices = try container.mainContext.fetch(descriptor)
            
            return devices.first
        } catch {
            Logger.dataManagerLogging.error("[DeviceManager] An error occurred while fetching device by identifier \(identifier): \(error)")
            
            return nil
        }
    }
    
    @MainActor
    func get(for identifiers: [String]) -> [Device] {
        do {
            let descriptor = FetchDescriptor<Device>(predicate: #Predicate { device in
                return identifiers.contains(device.id)
            })
            
            return try container.mainContext.fetch(descriptor)
        } catch {
            Logger.dataManagerLogging.error("[DeviceManager] An error occurred while fetching devices by identifiers \(identifiers.joined(separator: ", ")): \(error)")
            
            return []
        }
    }
    
    @MainActor
    func get(matching string: String) -> [Device] {
        do {
            let descriptor = FetchDescriptor<Device>(predicate: #Predicate { device in
                if string.isEmpty {
                    return true
                } else {
                    return device.name.localizedStandardContains(string)
                }
            })
            
            return try container.mainContext.fetch(descriptor)
        } catch {
            Logger.dataManagerLogging.error("[DeviceManager] An error occurred while searching devices by \(string): \(error)")
            
            return []
        }
    }
    
    @MainActor
    func create(_ device: Device) {
        container.mainContext.insert(device)
    }
    
    @MainActor
    func delete(for identifiers: [String]) {
        do {
            try container.mainContext.delete(model: Device.self, where: #Predicate { device in
                return identifiers.contains(device.id)
            })
        } catch {
            Logger.dataManagerLogging.error("[DeviceManager] An error occurred while deleting devices by ID \(identifiers.joined(separator: ",")): \(error)")
        }
    }
}
