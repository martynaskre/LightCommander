//
//  Device.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 04/01/2024.
//

import Foundation
import SwiftData
import Network
import AppKit

@Model
class Device {
    static let NAME_LENGTH = 20
    
    @Attribute(.unique) var id: String
    var name: String
    private var addressString: String
    var available: Bool
    @Relationship(deleteRule: .cascade) var state: DeviceState
    
    var address: NWEndpoint.Host {
        get {
            return NWEndpoint.Host(addressString)
        }
        set {
            addressString = newValue.debugDescription
        }
    }
    
    init(id: String, name: String, address: NWEndpoint.Host, available: Bool, state: DeviceState) {
        self.id = id
        self.name = name
        self.addressString = address.debugDescription
        self.available = available
        self.state = state
    }
}
