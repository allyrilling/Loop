//
//  StartView.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/14/22.
//

import SwiftUI
import HealthKit

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .walking]

    var body: some View {
        VStack {
            NavigationLink("Start\nRun", destination: SessionPagingView(),
                           tag: .running, selection: $workoutManager.selectedWorkout)
                .tint(.green)
                .font(.title)
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }//.foregroundColor(.green)
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView().environmentObject(WorkoutManager())
    }
}

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .running:
            return "Run"
        case .cycling:
            return "Bike"
        case .walking:
            return "Walk"
        default:
            return ""
        }
    }
}
