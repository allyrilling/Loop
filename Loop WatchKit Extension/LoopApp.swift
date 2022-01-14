//
//  LoopApp.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/13/22.
//

import SwiftUI

@main
struct LoopApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
