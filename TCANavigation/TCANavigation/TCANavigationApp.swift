//
//  TCANavigationApp.swift
//  TCANavigation
//
//  Created by Bakr mohamed on 29/05/2023.
//

import SwiftUI

@main
struct TCANavigationApp: App {
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView(store: .init(initialState: ContentFeature.State(), reducer: ContentFeature()._printChanges()))
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                debugPrint("background")
            case .inactive:
                debugPrint("inactive")
            case .active:
                debugPrint("active")
            default:
                debugPrint("")

            }
        }
    }
}
