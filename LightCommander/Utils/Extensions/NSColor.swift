//
//  NSColor.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 11/01/2024.
//

import AppKit

extension NSColor {
    func toRGB(_ colorspace: NSColorSpace = .genericRGB) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        guard let convertedColor = self.usingColorSpace(colorspace) else {
            return (red: 0, green: 0, blue: 0)
        }
        
        if let components = convertedColor.cgColor.components {
            return (red: components[0], green: components[1], blue: components[2])
        }
        
        return (red: 0, green: 0, blue: 0)
    }
}
