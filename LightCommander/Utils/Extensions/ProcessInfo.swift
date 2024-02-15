//
//  ProcessInfo.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 15/02/2024.
//

import Foundation

extension ProcessInfo {
    var isSwiftUIPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
