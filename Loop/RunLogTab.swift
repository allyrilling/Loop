//
//  RunLogTab.swift
//  Loop
//
//  Created by Ally Rilling on 6/3/22.
//

import SwiftUI
import HealthKit
import MapKit

struct RunLogTab: View {
    @ObservedObject var logic: Logic
    @State var lastRunDistance = -1.0
    
    @State private var region = MKCoordinateRegion(
       center: CLLocationCoordinate2D(latitude: 43.22328, longitude: -87.96555),
//       span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01),
       latitudinalMeters: 3000,
       longitudinalMeters: 3000
     )
    
    @State var routeCoordinates:[CLLocationCoordinate2D] = []
    
    var body: some View {
        Section {
            HStack {
                VStack {
                    Text("\(lastRunDistance.formatted(.number.precision(.fractionLength(2)))) mi")
                        .font(.title)
                }
                Divider()
                MapView(region: region, lineCoordinates: routeCoordinates)
            }.frame(height: 160)
        }.onAppear {
            Task.init(operation: {
                var lastRun = await logic.getLastRun()!
                lastRunDistance = (lastRun.totalDistance)!.doubleValue(for: HKUnit.mile())
                await logic.queryLastRunStats()
            })
        }
    }
}

//struct RunLogTab_Previews: PreviewProvider {
//    static var previews: some View {
//        RunLogTab()
//    }
//}
