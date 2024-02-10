//
//  ColorPicker.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 31/12/2023.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var color: Color
    
    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
    
    @State private var willUpdateColor = true
    
    init(_ color: Binding<Color>) {
        _color = color
        
        let hsb = color.wrappedValue.toHSB()
        
        _hue = State(initialValue: hsb.hue)
        _saturation = State(initialValue: hsb.saturation)
        _brightness = State(initialValue: hsb.brightness)
    }
    
    var body: some View {
        VStack(spacing: 10) {
            colorSlider
            hueSlider
        }
        .onChange(of: color) { oldColor, newColor in
            guard willUpdateColor else {
                willUpdateColor = true
                
                return
            }
            
            guard oldColor.toHEX() != newColor.toHEX() else { return }
            
            let hsb = color.toHSB()
            
            hue = hsb.hue
            saturation = hsb.saturation
            brightness = hsb.brightness
        }
    }
    
    private func updateColor() {
        willUpdateColor = false
        
        color = Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    private func generateSBHandle(proxy: GeometryProxy) -> some View {
        let longPressDrag = LongPressGesture(minimumDuration: 0.05)
            .sequenced(before: DragGesture())
            .onChanged { value in
                guard case .second(true, let drag?) = value else { return }
                
                withAnimation(.interactiveSpring()) {
                    self.saturation = max(0, min(drag.location.x, proxy.size.width)) / proxy.size.width
                    self.brightness = 1 - (max(0, min(drag.location.y, proxy.size.height)) / proxy.size.height)
                }
            }
            .onEnded { _ in
                updateColor()
            }
        
        return Circle()
            .overlay(Circle().stroke(Color.white, lineWidth: 5))
            .foregroundColor(Color(hue: self.hue, saturation: self.saturation, brightness: self.brightness))
            .frame(width: 16, height: 16, alignment: .center)
            .position(x: self.saturation * proxy.size.width, y: (1 - self.brightness) * proxy.size.height)
            .gesture(longPressDrag)
    }
    
    private var colorSlider: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hue: hue, saturation: 1, brightness: 1),
                        Color(hue: hue, saturation: 0, brightness: 1)
                    ]),
                    startPoint: .trailing,
                    endPoint: .leading
                )
                .clipShape(Rectangle())
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hue: hue, saturation: 0, brightness: 0, opacity: 0),
                        Color(hue: hue, saturation: 0, brightness: 0, opacity: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .clipShape(Rectangle())
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(self.generateSBHandle(proxy: proxy))
        }
        .frame(height: 126)
    }
    
    private func hueOverlay(proxy: GeometryProxy) -> some View {
        let longPressDrag = LongPressGesture(minimumDuration: 0.05)
            .sequenced(before: DragGesture())
            .onChanged { value in
                guard case .second(true, let drag?) = value else { return }
                
                withAnimation(.interactiveSpring()) {
                    self.hue = max(0, min(drag.location.x / proxy.size.width, 1))
                }
            }
            .onEnded { _ in
                updateColor()
            }
        
        return Circle()
            .overlay(Circle().stroke(Color.white, lineWidth: 5))
            .foregroundColor(Color(hue: self.hue, saturation: 1, brightness: 1))
            .frame(width: 16, height: 16, alignment: .center)
            .position(x: self.hue * proxy.size.width, y: 6)
            .gesture(longPressDrag)
    }
    
    private var hueSlider: some View {
        GeometryReader { (proxy: GeometryProxy) in
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1, green: 0, blue: 0),
                    Color(red: 1, green: 1, blue: 0),
                    Color(red: 0, green: 1, blue: 0),
                    Color(red: 0, green: 1, blue: 1),
                    Color(red: 0, green: 0, blue: 1),
                    Color(red: 1, green: 0, blue: 1),
                    Color(red: 1, green: 0, blue: 0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .mask(Capsule())
            .overlay(self.hueOverlay(proxy: proxy))
        }
        .frame(height: 12)
    }
}

#Preview {
    ColorPicker(.constant(Color(hex: "#f1f1f1")))
        .padding()
}
