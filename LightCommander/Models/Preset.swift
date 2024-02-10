//
//  Preset.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 26/01/2024.
//

import Foundation
import AppKit
import SwiftData

@Model
class Preset {
    @Attribute(.unique) var id: UUID
    private var red: CGFloat
    private var green: CGFloat
    private var blue: CGFloat
    var createdAt: Date
    
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
    
    init(color: NSColor) {
        self.id = UUID()
        
        let rgb = color.toRGB()
        
        self.red = rgb.red
        self.green = rgb.green
        self.blue = rgb.blue
        
        self.createdAt = .now
    }
}
