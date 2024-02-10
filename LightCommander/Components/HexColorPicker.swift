//
//  HexColorPicker.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 25/01/2024.
//

import SwiftUI

struct HexColorPicker: View {
    @Binding var color: Color
    
    @State private var colorFocused: Bool = true
    @DebouncedState private var colorString: String
    
    @State private var willUpdateColor = true
    @State private var willUpdateColorString = true
    
    init(_ color: Binding<Color>) {
        _color = color
        _colorString = DebouncedState(initialValue: color.wrappedValue.toHEX(), delay: 1)
    }
    
    var body: some View {
        VStack {
            TextField("Color", text: $colorString)
                .disabled(colorFocused)
                .onAppear {
                    DispatchQueue.main.async { colorFocused = false }
                }
        }
        .onChange(of: color) { oldColor, newColor in
            guard willUpdateColor else {
                willUpdateColor = true
                
                return
            }
            
            colorString = color.toHEX()
        }
        .onChange(of: colorString) {
            guard willUpdateColorString else {
                willUpdateColorString = true
                
                return
            }
            
            willUpdateColor = false
            
            color = Color(hex: colorString)
            colorString = color.toHEX()
        }
    }
}

#Preview {
    HexColorPicker(.constant(.red))
}
