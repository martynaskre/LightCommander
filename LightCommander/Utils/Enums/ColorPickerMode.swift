//
//  ColorPickerMode.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 26/01/2024.
//

enum ColorPickerMode: CaseIterable, Identifiable, CustomStringConvertible, RawRepresentable {
    var id: Self { self }
    
    case hex
    case rgb
    
    var description: String {
        switch self {
        case .hex:
            return "HEX"
        case .rgb:
            return "RGB"
        }
    }
    
    var rawValue: String {
        switch self {
        case .hex:
            return "hex"
        case .rgb:
            return "rgb"
        }
    }
    
    init?(rawValue: String) {
        switch rawValue {
        case "hex":
            self = .hex
        case "rgb":
            self = .rgb
        default:
            return nil
        }
    }
}
