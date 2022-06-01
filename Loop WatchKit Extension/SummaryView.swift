//
//  SummaryView.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/14/22.
//

import Foundation
import HealthKit
import SwiftUI
import WatchKit

struct SummaryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        if workoutManager.workout == nil {
            ProgressView("Saving Workout")
                .navigationBarHidden(true)
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    SummaryMetricView(title: "Total Distance",
                                      value: Measurement(value: workoutManager.distance, unit: UnitLength.meters).converted(to: UnitLength.miles).value.formatted(.number.precision(.fractionLength(2))) + " mi")
                    
                    
                    
                        .foregroundStyle(.blue)
                    SummaryMetricView(title: "Avg. Heart Rate",
                                      value: workoutManager.averageHeartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
                        .foregroundStyle(.red)
                    Button(workoutManager.workoutIsSaved ? "Done" : "WAIT") {
                        if(workoutManager.workoutIsSaved) {
                            dismiss()
                        }
                    }
//                    Button("Done") {
//                        dismiss()
//                    }
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

struct SummaryMetricView: View {
    var title: String
    var value: String

    var body: some View {
        Text(title)
            .foregroundStyle(.foreground)
        Text(value)
            .font(.system(.title2, design: .rounded).lowercaseSmallCaps())
        Divider()
    }
}
