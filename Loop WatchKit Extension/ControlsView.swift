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
        
        VStack {
            HStack {
                Button {
                    WKInterfaceDevice.current().enableWaterLock()
                } label: {
                    VStack {
                        Spacer()
                        Image(systemName: "drop.fill")
                        Spacer()
                    }
                }
                .tint(.blue)
                .font(.title)
                
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
                .font(.title)
//                Text(workoutManager.running ? "Pause" : "Resume")
            }
            
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
            .font(.title)
//                Text("End")
            
        }
        
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView().environmentObject(WorkoutManager())
    }
}
