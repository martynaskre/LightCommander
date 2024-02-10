//
//  QueriedDeviceState.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 07/02/2024.
//

import AppIntents

enum QueriedDeviceState: String, AppEnum {
    typealias RawValue = String
    
    case online
    case offline
    case notAvailable
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(stringLiteral: "State")

    static var caseDisplayRepresentations: [QueriedDeviceState : DisplayRepresentation] = [
        .online: .init(stringLiteral: "Online"),
        .offline: .init(stringLiteral: "Offline"),
        .notAvailable: .init(stringLiteral: "Not Available")
    ]
    
    var title: String {
        switch self {
        case .online: return "Online"
        case .offline: return "Offline"
        case .notAvailable: return "Not Available"
        }
    }
}
