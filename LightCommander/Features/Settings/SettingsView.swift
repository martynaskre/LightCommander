//
//  SettingsView.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 26/01/2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var settings = UserSettings.shared
    
    var body: some View {
        Form {
            Picker("Color picker mode", selection: $settings.colorPickerMode) {
                ForEach(ColorPickerMode.allCases) { option in
                    Text(String(describing: option))
                }
            }
            .pickerStyle(.segmented)
            Toggle("Developer mode", isOn: $settings.developerMode)
                .toggleStyle(.switch)
            Text("By enabling developer mode, you will be able to see additional device related information.")
                .font(.footnote)
                .padding(.trailing)
        }
        .padding()
        .frame(width: 450)
    }
}

#Preview {
    SettingsView()
}
