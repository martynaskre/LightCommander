//
//  LightCommanderApp.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 30/12/2023.
//

import SwiftUI
import SwiftData
import AppIntents

@main
struct LightCommanderApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @State private var uiState = UIState()
    
    init() {
        AppDependencyManager.shared.add(dependency: DeviceManager.shared)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $uiState.navigationPath) {
                DevicesView()
                    .navigationDestination(for: Device.self) { device in
                        DeviceView(device: device)
                    }
            }
            .frame(width: 506, height: 405)
        }
        .environment(uiState)
        .windowResizability(.contentSize)
        
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let _ = NSApplication.shared.windows.map { $0.tabbingMode = .disallowed }
    }
}
