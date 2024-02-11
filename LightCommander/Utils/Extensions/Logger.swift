//
//  Logging.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 02/02/2024.
//

import Foundation
import OSLog

extension Logger {
    static let intentLogging = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "App Intent")
    static let entityQueryLogging = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Entity Query")
    static let dataManagerLogging = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Data Manager")
}
