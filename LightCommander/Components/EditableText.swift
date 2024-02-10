//
//  EditableText.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 04/01/2024.
//

import SwiftUI

struct EditableText: View {
    private let title: String
    @Binding var text: String
    private let maxLength: Int?
    
    @State private var newValue: String = ""
    @State private var newValueRect = CGRect()
    
    @State private var editProcessGoing: Bool = false {
        didSet {
            isFocused = editProcessGoing
            newValue = text
        }
    }
    
    @FocusState private var isFocused
    
    init(_ text: Binding<String>) {
        title = ""
        _text = text
        maxLength = nil
    }
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        _text = text
        maxLength = nil
    }
    
    init(_ title: String, text: Binding<String>, maxLength: Int) {
        self.title = title
        _text = text
        self.maxLength = maxLength
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(newValue.count < title.count ? title : newValue)
                .layoutPriority(editProcessGoing ? 1 : 0)
                .background(GlobalGeometryGetter(rect: $newValueRect))
                .opacity(0)
            Text(text)
                .layoutPriority(editProcessGoing ? 0 : 1)
                .opacity(editProcessGoing ? 0 : 1)
            TextField(title, text: $newValue, onCommit: {
                if newValue.count > 0 {
                    text = newValue
                }
                
                editProcessGoing = false
            })
            .onChange(of: newValue) {
                guard let maxLength = maxLength else { return }
                
                if newValue.count > maxLength {
                    self.newValue = String(newValue.prefix(maxLength))
                }
            }
            .frame(width: newValueRect.width)
            .focused($isFocused)
            .opacity(editProcessGoing ? 1 : 0)
        }
        .onMouseDown(count: 2) {
            if !editProcessGoing {
                editProcessGoing = true
            }
        }
        .onExitCommand {
            editProcessGoing = false
        }
    }
}

#Preview {
    EditableText(.constant("test"))
        .padding(10)
}
