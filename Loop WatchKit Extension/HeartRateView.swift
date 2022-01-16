//
//  HeartRateView.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/14/22.
//

import SwiftUI
import HealthKit

struct HeartRateView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var scrollAmount = 1.0
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack(alignment: .center) {
                Text(workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))))
                    .font(.system(size: 75, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .foregroundColor(workoutManager.running ? .red : .white)

                HStack {
                    Image(systemName: "heart.fill")
                        .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    Text("bpm")
                }.font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .scenePadding()
        }
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)
    }
}


struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView()
    }
}

