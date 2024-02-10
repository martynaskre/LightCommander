//
//  GlobalGeometryGetter.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 31/01/2024.
//

import SwiftUI

struct GlobalGeometryGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = geometry.frame(in: .global)
        }
        
        return Rectangle().fill(Color.clear)
    }
}

#Preview {
    GlobalGeometryGetter(rect: .constant(.null))
}
