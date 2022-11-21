//
//  HomeTab.swift
//  Loop
//
//  Created by Ally Rilling on 6/3/22.
//

import SwiftUI
import HealthKit
import MapKit

struct HomeTab: View {
    @State var userMaxBpm: String = "0"
    @ObservedObject var logic: Logic
    @State var lastRunDistance = -1.0
    @State var lastSevenDays = -1.0
    
    @State var refresh: Bool = false
    func update() {
       refresh.toggle()
        print(refresh)
    }
    
    @StateObject private var locationManager = LocationManager()
        
    @State private var region = MKCoordinateRegion(
       center: CLLocationCoordinate2D(latitude: 43.22328, longitude: -87.96555),
//       span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01),
       latitudinalMeters: 3000,
       longitudinalMeters: 3000
     )
    
    @State var routeCoordinates:[CLLocationCoordinate2D] = []
    
    
    var body: some View {
        
        List {
            
            Section {
                HStack {
                    VStack {
                        Text("\(lastRunDistance.formatted(.number.precision(.fractionLength(2)))) mi")
                            .font(.title)
                    }
                    Divider()
                    MapView(region: region, lineCoordinates: routeCoordinates)
                }.frame(height: 160)
            }
            
            Section {
                Text("Last Run: \(lastRunDistance) mi")
                Text("Last 7 Days: \(lastSevenDays) mi")
            }
            Button(action: {
                Task.init(operation: {
                    var lastRun = await logic.getLastRun()
                    lastRunDistance = (lastRun?.totalDistance)!.doubleValue(for: HKUnit.mile())
                    var lastSeven = await logic.readWorkouts()
                    var ttl = 0.0
                    for i in lastSeven! {
                        ttl += (i.totalDistance)!.doubleValue(for: HKUnit.mile())
                    }
                    lastSevenDays = ttl
                })
            }, label: {
                Text("get last run distance / last 7 day ttl")
            })
            
            Section {
                MapView(region: region, lineCoordinates: routeCoordinates)
                    .frame(height: 300)
                    .ignoresSafeArea()
            }
            
            Button(action: {
                Task.init(operation: {
                    var lastRun = await logic.getLastRun()
                    var lastRoute = await logic.getWorkoutRoute(workout: lastRun!)
                    var lastLocations = await logic.getLocationDataForRoute(givenRoute: lastRoute![0])
                    for i in lastLocations {
                        routeCoordinates.append(i.coordinate)
                    }
                })
            }, label: {
                Text("update route")
            })
        }.onAppear {
            logic.requestAuthorization()
        }
        
    }
}

//struct HomeTab_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeTab()
//    }
//}

extension MKCoordinateRegion {
    
    static func goldenGateRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.819527098978355, longitude:  -122.47854602016669), latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
    
    func getBinding() -> Binding<MKCoordinateRegion>? {
        return Binding<MKCoordinateRegion>(.constant(self))
    }
}

