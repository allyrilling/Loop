//
//  ControlsView.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/14/22.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        
        HStack {
            VStack {
                Button {
                    // should show confirmation here instead
                    workoutManager.confirmEnd()
                    workoutManager.togglePause() // pause while we go to confirm screen
                } label: {
                    VStack {
                        Spacer()
                        Image(systemName: "xmark")
                        Spacer()
                    }
                }
                .tint(.red)
                .font(.title2)
//                Text("End")
            }
            VStack {
                Button {
                    workoutManager.togglePause()
                } label: {
                    VStack {
                        Spacer()
                        Image(systemName: workoutManager.running ? "pause" : "play")
                        Spacer()
                    }
                }
                .tint(.yellow)
                .font(.title2)
//                Text(workoutManager.running ? "Pause" : "Resume")
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}
