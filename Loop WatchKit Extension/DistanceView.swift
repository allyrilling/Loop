//
//  DistanceView.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/14/22.
//

import SwiftUI

struct DistanceView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
            VStack() {
                
                Text("\(Measurement(value: workoutManager.distance, unit: UnitLength.meters).converted(to: UnitLength.miles).value.formatted(.number.precision(.fractionLength(2))))")
//                  Text("13.99")
                    .font(.system(size: 66, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                    .foregroundColor(workoutManager.running ? .blue : .white)
                    .fixedSize(horizontal: true, vertical: true)
                Text("mi")
                    .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                
            }
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(edges: .bottom)
//            .scenePadding()
        }
    }
}

struct DistanceView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceView()
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

