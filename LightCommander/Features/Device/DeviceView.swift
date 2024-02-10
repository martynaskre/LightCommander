//
//  Device.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 30/12/2023.
//

import SwiftUI
import SwiftData
import Network

struct DeviceView: View {
    @State private var settings = UserSettings.shared
    @State private var viewModel: ViewModel
    
    init(device: Device) {
        _viewModel = State(initialValue: ViewModel(device: device))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 55) {
                VStack(spacing: 8) {
                    EditableText("Device", text: $viewModel.device.name, maxLength: Device.NAME_LENGTH)
                        .font(.largeTitle.bold())
                        .frame(maxWidth: 350)
                    Text(viewModel.device.available ? "Available on network" : "Not available on network")
                        .font(.subheadline)
                }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        Card(icon: "pencil.tip.crop.circle", title: "Color", showDivider: false) {
                            ColorPicker($viewModel.color)
                                .disabled(!viewModel.device.available)
                            switch settings.colorPickerMode {
                            case .hex:
                                HexColorPicker($viewModel.color)
                                    .disabled(!viewModel.device.available)
                            case .rgb:
                                RgbColorPicker($viewModel.color)
                                    .disabled(!viewModel.device.available)
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Card(icon: "slider.horizontal.3", title: "Presets") {
                            HStack {
                                ForEach(viewModel.presets) { preset in
                                    Button {
                                        viewModel.color = Color(preset.color)
                                    } label: {
                                        Rectangle()
                                            .frame(width: 24, height: 24)
                                            .background(Color(preset.color))
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                    }
                                    .disabled(!viewModel.device.available)
                                    .foregroundStyle(.clear)
                                    .buttonStyle(PlainButtonStyle())
                                    .contextMenu {
                                        Button("Delete", role: .destructive) {
                                            viewModel.removePreset(preset.id)
                                        }
                                    }
                                }
                                if viewModel.presets.count < 6 {
                                    Button {
                                        viewModel.addPreset()
                                    } label: {
                                        Image(systemName: "plus.circle")
                                    }
                                    .disabled(!viewModel.device.available)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .frame(minHeight: 24)
                            .animation(.snappy, value: viewModel.presets)
                        }
                        Card(icon: "repeat", title: "Automation") {
                            Text("LightCommander seamlessly integrates with Shortcuts, allowing the creation of powerful automations.")
                                .font(.subheadline)
                        }
                        if settings.developerMode {
                            Card(icon: "info.circle", title: "Device information") {
                                Text("IP address: \(viewModel.device.address.debugDescription)")
                                    .font(.subheadline)
                                Text("Device ID: \(viewModel.device.id)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .padding(.top, 55)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                EditableText("Device", text: $viewModel.device.name, maxLength: Device.NAME_LENGTH)
                    .font(.title3.bold())
                    .frame(maxWidth: 150)
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.toggleState()
                } label: {
                    Image(systemName: "power.circle.fill")
                }
                .disabled(!viewModel.device.available)
            }
        }
    }
}

#Preview {
    let context = DataController.previewContainer.mainContext
    
    let state = DeviceState(on: false, color: .green)
    let device = Device(id: "123456", name: "Device", address: NWEndpoint.Host("127.0.0.1"), available: true, state: state)
    
    context.insert(device)
    
    return DeviceView(device: device)
        .frame(width: 506, height: 405)
}
