//
//  PassthroughView.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 03/01/2024.
//

import SwiftUI

class PassthroughView: NSView {
    let mouseDownHandler: (NSEvent) -> Void
    
    init(mouseDownHandler: @escaping (NSEvent) -> Void) {
        self.mouseDownHandler = mouseDownHandler
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        mouseDownHandler(event)
    }
}

struct MouseDown: NSViewRepresentable {
    let count: Int
    let action: () -> Void
    
    func makeNSView(context: Context) -> some NSView {
        PassthroughView(mouseDownHandler: { event in
            guard event.clickCount == count else { return }
            
            action()
        })
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {}
}

struct OnMouseDown: ViewModifier {
    let count: Int
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content.overlay {
            MouseDown(count: count, action: action)
        }
    }
}

extension View {
    func onMouseDown(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        modifier(OnMouseDown(count: count, action: action))
    }
}
