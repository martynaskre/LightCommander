//
//  DevicePreview.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 30/12/2023.
//

import SwiftUI
import Network

struct DevicePreviewView: View {
    @State var device: Device
    @Binding var editing: Bool
    var isFocused: FocusState<Focusable?>.Binding
    
    var online: Binding<Bool> {
        Binding<Bool>(get: {
            return device.state.on
        }, set: { state in
            let controller = MagicHome(address: device.address)
            
            controllerBusy = true
            
            controller.setPower(state) { data, _ in
                DispatchQueue.main.async {
                    if data != nil {
                        device.state.on = state
                    }
                    
                    controllerBusy = false
                }
            }
        })
    }
    @State private var controllerBusy = false
    
    var body: some View {
        HStack {
            Toggle(isOn: online) {
                Image(systemName: "power")
                    .font(.headline)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 8)
            }
            .disabled(!device.available || controllerBusy)
            .toggleStyle(.button)
            .background(.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(device.available ? 1 : 0.5)
            HStack {
                if editing {
                    TextField("Device", text: $device.name, onEditingChanged: { focus in
                        if !focus {
                            editing = false
                        }
                    })
                    .focused(isFocused, equals: .row(id: device.id))
                    .onChange(of: device.name) {
                        if device.name.count > Device.NAME_LENGTH {
                            device.name = String(device.name.prefix(Device.NAME_LENGTH))
                        }
                    }
                } else {
                    Text(device.name)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if device.available {
                Circle()
                    .fill(Color(device.state.color))
                    .frame(width: 8, height: 8)
            } else {
                Image(systemName: "wifi.exclamationmark")
                    .font(.headline)
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 5)
    }
}

#Preview {
    let context = DataController.shared.container.mainContext
    
    let state = DeviceState(on: false, color: .green)
    let device = Device(id: "123456", name: "Device", address: NWEndpoint.Host("127.0.0.1"), available: true, state: state)
    
    context.insert(device)
        
    return DevicePreviewView(device: device, editing: .constant(false), isFocused: FocusState<Focusable?>().projectedValue)
        .frame(width: 506)
}
