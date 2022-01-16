//
//  SessionPagingView.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/14/22.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @State private var selection: Tab = .hr
//    @State private var crownValue = 0.0

    enum Tab {
        case controls, hr, distance, nowPlaying
    }

    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            HeartRateView().tag(Tab.hr)
            DistanceView().tag(Tab.distance)
            NowPlayingView().tag(Tab.nowPlaying)
        }
//        .navigationTitle(workoutManager.selectedWorkout?.name ?? "")
        .navigationTitle(workoutManager.running ? "" : "PAUSED")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying)
        .onChange(of: workoutManager.running) { _ in
            displayMetricsView()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic))
        .onChange(of: isLuminanceReduced) { _ in
            displayMetricsView()
        }
//        .digitalCrownRotation($crownValue)
        
    }

    private func displayMetricsView() {
        withAnimation {
            selection = .hr
        }
    }
}

struct PagingView_Previews: PreviewProvider {
    static var previews: some View {
        SessionPagingView().environmentObject(WorkoutManager())
    }
}
