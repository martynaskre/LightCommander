//
//  UserSettings.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 26/01/2024.
//

import SwiftUI

@Observable
class UserSettings {
    static let shared = UserSettings()
    
    var colorPickerMode: ColorPickerMode {
        get {
            access(keyPath: \.colorPickerMode)
            return ColorPickerMode(rawValue: UserDefaults.standard.value(forKey: "colorPickerMode") as? String ?? "") ?? .hex
        }
        set {
            withMutation(keyPath: \.colorPickerMode) {
                UserDefaults.standard.set(newValue.rawValue, forKey: "colorPickerMode")
            }
        }
    }
    
    var developerMode: Bool {
        get {
            access(keyPath: \.colorPickerMode)
            return UserDefaults.standard.value(forKey: "developerMode") as? Bool ?? false
        }
        set {
            withMutation(keyPath: \.colorPickerMode) {
                UserDefaults.standard.set(newValue, forKey: "developerMode")
            }
        }
    }
}
