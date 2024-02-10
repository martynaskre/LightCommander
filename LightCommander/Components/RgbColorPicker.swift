//
//  RgbColorPicker.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 25/01/2024.
//

import SwiftUI

struct RgbColorPicker: View {
    @Binding var color: Color
    
    @DebouncedState private var red: String
    @DebouncedState private var green: String
    @DebouncedState private var blue: String
    
    @State private var willUpdateColor = true
    @State private var willUpdateRed = true
    @State private var willUpdateGreen = true
    @State private var willUpdateBlue = true
    
    init(_ color: Binding<Color>) {
        _color = color
        
        let rgb = color.wrappedValue.toRGB()
        
        _red = DebouncedState(initialValue: String(Int(round(255 * rgb.red))), delay: 0.5)
        _green = DebouncedState(initialValue: String(Int(round(255 * rgb.green))), delay: 0.5)
        _blue = DebouncedState(initialValue: String(Int(round(255 * rgb.blue))), delay: 0.5)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("R")
                TextField("R", text: $red)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("G")
                TextField("G", text: $green)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("B")
                TextField("B", text: $blue)
            }
        }
        .onChange(of: color) { oldColor, newColor in
            guard willUpdateColor else {
                willUpdateColor = true
                
                return
            }
            
            resetComponents()
        }
        .onChange(of: red) {
            guard willUpdateRed else {
                willUpdateRed = true
                
                return
            }
            
            updateColor()
        }
        .onChange(of: green) {
            guard willUpdateGreen else {
                willUpdateGreen = true
                
                return
            }
            
            updateColor()
        }
        .onChange(of: blue) {
            guard willUpdateBlue else {
                willUpdateBlue = true
                
                return
            }
            
            updateColor()
        }
    }
    
    private func resetComponents() {
        let rgb = color.toRGB()
        
        willUpdateRed = false
        willUpdateGreen = false
        willUpdateBlue = false
        
        red = String(Int(round(255 * rgb.red)))
        green = String(Int(round(255 * rgb.green)))
        blue = String(Int(round(255 * rgb.blue)))
    }
    
    private func updateColor() {
        willUpdateColor = false
        
        guard let red = Int(red), let green = Int(green), let blue = Int(blue) else {
            resetComponents()
            
            return
        }
        
        guard (red >= 0 && red <= 255) && (green >= 0 && green <= 255) && (blue >= 0 && blue <= 255) else {
            resetComponents()
            
            return
        }
        
        color = Color(red: Double(red / 255), green: Double(green / 255), blue: Double(blue / 255))
    }
}

#Preview {
    RgbColorPicker(.constant(.red))
}
