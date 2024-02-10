//
//  MagicHomeState.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 05/01/2024.
//

import Foundation
import AppKit

struct MagicHomeState {
    let on: Bool
    let color: NSColor
    
    init(on: Bool, red: UInt8, green: UInt8, blue: UInt8) {
        self.on = on
        self.color = NSColor(colorSpace: .genericRGB, components: [CGFloat(red) / 255, CGFloat(green) / 255, CGFloat(blue) / 255], count: 4)
    }
}
