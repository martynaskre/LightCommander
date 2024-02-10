//
//  DeviceViewModel.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 05/01/2024.
//

import Foundation
import SwiftUI
import SwiftData

extension DeviceView {
    @Observable
    class ViewModel {
        private var presetManager = PresetManager.shared
        
        var device: Device
        private(set) var presets = [Preset]()
        
        var color: Color {
            didSet {
                setColor(color)
            }
        }
        
        private var controller: MagicHome {
            get {
                return MagicHome(address: device.address)
            }
        }
        
        init(device: Device) {
            self.device = device
            self.color = Color(device.state.color)
            
            fetchPresets()
        }
        
        func toggleState() {
            let toggledState = !device.state.on
            
            controller.setPower(toggledState) { data, _ in
                DispatchQueue.main.async { [weak self] in
                    if data != nil {
                        self?.device.state.on = toggledState
                    }
                }
            }
        }
        
        func setColor(_ color: Color) {
            let rgb = color.toRGB()
            
            controller.setColor(red: Int(round(255 * rgb.red)), green: Int(round(255 * rgb.green)), blue: Int(round(255 * rgb.blue)), brightness: 100) { _, error in
                DispatchQueue.main.async { [weak self] in
                    guard error == nil else { return }
                    
                    self?.device.state.color = NSColor(color)
                }
            }
        }
        
        func fetchPresets() {
            DispatchQueue.main.async { [self] in
                presets = presetManager.get()
            }
        }
        
        func addPreset() {
            DispatchQueue.main.async { [self] in
                let preset = Preset(color: NSColor(color))
                
                presetManager.create(preset)
                
                fetchPresets()
            }
        }
        
        func removePreset(_ presetId: UUID) {
            DispatchQueue.main.async { [self] in
                presetManager.delete(presetId)
                
                fetchPresets()
            }
        }
    }
}
