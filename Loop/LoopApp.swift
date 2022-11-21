//
//  LoopApp.swift
//  Loop
//
//  Created by Ally Rilling on 1/13/22.
//

import SwiftUI

@main
struct LoopApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeTab(logic: Logic())
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
             
                RunLogTab(logic: Logic())
                    .tabItem {
                        Image(systemName: "bookmark.circle.fill")
                        Text("Run Log")
                    }
                ExportTab()
                    .tabItem {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                        Text("Export")
                    }
             
                WatchConfigTab()
                    .tabItem {
                        Image(systemName: "applewatch")
                        Text("Watch")
                    }
            }
            
        }
    }
}
