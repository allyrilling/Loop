//
//  LoopApp.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/13/22.
//

import SwiftUI

@main
struct LoopApp: App {
    @StateObject private var workoutManager = WorkoutManager()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView()
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .sheet(isPresented: $workoutManager.showingConfirmationView) {
                EndConfirmationView()
            }
            .environmentObject(workoutManager)
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
        
    }
    
}
