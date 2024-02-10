//
//  Card.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 30/12/2023.
//

import SwiftUI

struct Card<Content: View>: View {
    var icon: String
    var title: String
    var showDivider = true
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: icon)
                        .font(.subheadline.bold())
                    Text(title)
                        .font(.subheadline.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if showDivider {
                    Divider()
                        .padding(.bottom, 5)
                }
                content()
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.black.opacity(0.2))
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    Card(icon: "pencil.circle", title: "Test") {
        Text("sw")
    }
    .padding()
}
