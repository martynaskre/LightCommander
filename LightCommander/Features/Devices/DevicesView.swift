//
//  Devices.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 30/12/2023.
//

import SwiftUI
import SwiftData

struct DevicesView: View {
    @Environment(UIState.self) private var uiState
    @State private var viewModel = ViewModel()
    @FocusState var focusedDevice: Focusable?
    
    var body: some View {
        VStack {
            if !viewModel.devices.isEmpty {
                List(selection: $viewModel.selection) {
                    ForEach(viewModel.devices) { device in
                        DevicePreviewView(device: device, editing: Binding(
                            get: {
                                return viewModel.renaming == device.id
                            },
                            set: { newValue in
                                if !newValue {
                                    viewModel.renaming = ""
                                }
                            }
                        ), isFocused: $focusedDevice)
                    }
                }
                .scrollContentBackground(.hidden)
                .contextMenu(forSelectionType: String.self) { items in
                    if !items.isEmpty {
                        Button("Rename") {
                            viewModel.renaming = items.first!
                        }
                        .disabled(items.count > 1)
                        Button("Delete", role: .destructive, action: viewModel.deleteDevices)
                    }
                } primaryAction: { devices in
                    guard devices.count == 1 else { return }
                    
                    if let device = viewModel.devices.first(where: {$0.id == devices.first}) {
                        uiState.navigationPath.append(device)
                    }
                }

            } else {
                VStack(spacing: 10) {
                    if viewModel.searchText.isEmpty {
                        Image(systemName: "lightbulb.circle.fill")
                            .resizable()
                            .foregroundColor(.secondary)
                            .frame(width: 55, height: 55)
                        Text("No Devices")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.primary)
                        Text("To add a compatible device, click the find devices icon in the toolbar.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .frame(width: 300)
                    } else {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .foregroundColor(.secondary)
                            .frame(width: 55, height: 55)
                        Text("No Results for “\(viewModel.searchText)”")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .frame(width: 350, alignment: .center)
                        Text("Check the spelling or try a new search.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .frame(width: 300)
                    }
                }
            }
        }
        .onAppear {
            viewModel.queryState()
        }
        .onChange(of: viewModel.devices) {
            viewModel.queryState()
        }
        .onChange(of: viewModel.renaming) {
            guard !viewModel.renaming.isEmpty else {
                focusedDevice = Focusable.none
                
                return
            }
            
            focusedDevice = .row(id: viewModel.renaming)
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.discoverDevices)) { _ in
            viewModel.findDevices()
        }
        .animation(.easeInOut, value: viewModel.devices)
        .navigationTitle("Devices")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.findDevices()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .disabled(viewModel.searchingForDevices)
            }
            
        }
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    DevicesView()
        .environment(UIState())
        .frame(width: 506, height: 405)
}
