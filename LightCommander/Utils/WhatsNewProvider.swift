//
//  WhatsNewProvider.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 11/02/2024.
//

import WhatsNewKit
import Foundation

struct WhatsNewProvider: WhatsNewCollectionProvider {
    static let environment = WhatsNewEnvironment(
        versionStore: UserDefaultsWhatsNewVersionStore(),
        defaultLayout: WhatsNew.Layout(
            scrollViewBottomContentInset: 105,
            contentSpacing: 25,
            contentPadding: .init(
                top: 30,
                leading: 0,
                bottom: 0,
                trailing: 0
            ),
            featureListSpacing: 15,
            footerPrimaryActionButtonCornerRadius: 5
        ),
        whatsNewCollection: WhatsNewProvider()
    )
    
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "1.0.0",
            title: "LightCommander",
            features: [
                .init(
                    image: .init(
                        systemName: "magnifyingglass",
                        foregroundColor: .red
                    ),
                    title: "Discover",
                    subtitle: "Find any Magic Home devices \ncurrently connected to your network."
                ),
                .init(
                    image: .init(
                        systemName: "gearshape.fill",
                        foregroundColor: .green
                    ),
                    title: "Control",
                    subtitle: "Turn on a device, adjust the color, add \na preset, and change the device name."
                ),
                .init(
                    image: .init(
                        systemName: "repeat",
                        foregroundColor: .blue
                    ),
                    title: "Automate",
                    subtitle: "Seamlessly integrate devices into \nautomations using Shortcuts."
                ),
            ],
            primaryAction: WhatsNew.PrimaryAction(
                title: "Get Started",
                onDismiss: {
                    NotificationCenter.default.post(name: .discoverDevices, object: nil)
                }
            ),
            secondaryAction: WhatsNew.SecondaryAction(
                title: "Learn More",
                action: .openURL(
                    .init(string: "https://github.com/martynaskre/LightCommander")
                )
            )
        )
    }
}
