//
//  EndConfirmationView.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/14/22.
//

import SwiftUI

struct EndConfirmationView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Button(action: {
                if(!workoutManager.workoutIsEnded) {
                    workoutManager.workoutIsEnded = true
                    workoutManager.endWorkout()
                }
            }, label: {
                Text("Confirm End")
//                Text("WAIT 3 SEC")
                .font(.title2)
                .frame(height: 80)
            }).tint(.red)
            .padding(.bottom)
            
            Button(action: {
                dismiss() // go back to sesson paging view
                workoutManager.togglePause() // restart workout after we reject end confirmation
            }, label: {
                Text("Resume")
            }).tint(.green)
        }
    }
}

struct EndConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        EndConfirmationView()
    }
}
