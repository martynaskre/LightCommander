//
//  DeviceEntity.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 12/01/2024.
//

import AppIntents

struct DeviceEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Device")
    }
    
    static var defaultQuery = DeviceEntityQuery()
        
    var id: String
    
    @Property(title: "Device Name")
    var name: String
    
    @Property(title: "Device Address")
    var address: String
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(title: "\(name)", subtitle: "\(address)")
    }
    
    init(device: Device) {
        self.id = device.id
        self.name = device.name
        self.address = device.address.debugDescription
    }
}
