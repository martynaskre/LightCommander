//
//  Color.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 02/01/2024.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString
        
        let scanner = Scanner(string: hexString)
        var hexValue: UInt64 = 0
        
        if scanner.scanHexInt64(&hexValue) {
            let r = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(hexValue & 0x0000FF) / 255.0
            
            self.init(red: r, green: g, blue: b)
            
            return
        }
        
        self.init(red: 0, green: 0, blue: 0)
    }
    
    func toHEX() -> String {
        if let components = self.cgColor?.components {
            let rgb: [Double] = [components[0], components[1], components[2]]
            
            return rgb.reduce("#") { res, value in
                let intval = Int(round(value * 255))
                return res + (NSString(format: "%02X", intval) as String)
            }
        } else {
            return "#000000"
        }
    }
    
    func toHSB(_ colorspace: NSColorSpace = .genericRGB) -> (hue: Double, saturation: Double, brightness: Double) {
        let nsColor = NSColor(self)
        
        guard let convertedColor = nsColor.usingColorSpace(colorspace) else {
            return (hue: 0, saturation: 0, brightness: 0)
        }
        
        var newHue: CGFloat = 0.0
        var newSaturation: CGFloat = 0.0
        var newBrightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        convertedColor.getHue(&newHue, saturation: &newSaturation, brightness: &newBrightness, alpha: &alpha)
        
        return (hue: newHue, saturation: newSaturation, brightness: newBrightness)
    }
    
    func toRGB(_ colorspace: NSColorSpace = .genericRGB) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let nsColor = NSColor(self)
        
        guard let convertedColor = nsColor.usingColorSpace(colorspace) else {
            return (red: 0, green: 0, blue: 0)
        }
        
        return convertedColor.toRGB()
    }
}
