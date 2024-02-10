//
//  DeviceState.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 11/01/2024.
//

import SwiftData
import AppKit

@Model
class DeviceState {
    var on: Bool
    private var red: CGFloat
    private var green: CGFloat
    private var blue: CGFloat
    
    var color: NSColor {
        get {
            return NSColor(colorSpace: .genericRGB, components: [red, green, blue, 1], count: 4)
        }
        set {
            let rgb = newValue.toRGB()
            
            red = rgb.red
            green = rgb.green
            blue = rgb.blue
        }
    }
        
    init(on: Bool, color: NSColor) {
        self.on = on
        
        let rgb = color.toRGB()
        
        self.red = rgb.red
        self.green = rgb.green
        self.blue = rgb.blue
    }
}
