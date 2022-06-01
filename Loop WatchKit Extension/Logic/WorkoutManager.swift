//
//  WorkoutManager.swift
//  Loop WatchKit Extension
//
//  Created by Ally Rilling on 1/14/22.
//

import Foundation
import HealthKit
import CoreLocation
import WatchKit

@MainActor
class WorkoutManager: NSObject, ObservableObject {
    
    // MARK: - VARS AND PROPERTIES
    @Published var locationViewModel: LocationViewModel? = LocationViewModel()
    @Published var workoutIsSaved = false
    @Published var workoutIsEnded = false
    
    var selectedWorkout: HKWorkoutActivityType? {
        didSet {
            guard let selectedWorkout = selectedWorkout else { return }
            startWorkout(workoutType: selectedWorkout)
        }
    }

    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
//                print("reset workout here")
                resetWorkout()
            }
        }
    }
    
    @Published var showingConfirmationView: Bool = false {
        didSet {
            if showingConfirmationView == false {
//                print("showingConfirmationView")
            }
        }
    }

    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    
    @Published var running = false // The app's workout state.
    
    // MARK: - FUNCTIONS
    
    // MARK: REQUEST AUTH
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
            HKSeriesType.workoutRoute(),
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .vo2Max)!,
            HKSeriesType.workoutType(),
            HKSeriesType.workoutRoute(),
            HKObjectType.activitySummaryType()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
        
        locationViewModel?.requestPermission()
        
    }

    // MARK: START WORKOUT
    func startWorkout(workoutType: HKWorkoutActivityType) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor
        

        // Create the session and obtain the workout builder.
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
            return
        }

        // Setup session and builder.
        session?.delegate = self
        builder?.delegate = self

        // Set the workout builder's data source.
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)
        
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
            // The workout has started.
        }
        
        locationViewModel = LocationViewModel()
        
        // Create the route builder.
        locationViewModel?.routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
        
        // to enable steps collection
        builder?.dataSource?.enableCollection(for: HKQuantityType.quantityType(forIdentifier: .stepCount)!, predicate: nil)
        builder?.dataSource?.enableCollection(for: HKQuantityType.quantityType(forIdentifier: .vo2Max)!, predicate: nil)
        
        // TODO: was here idk if this works in tempo
//        self.builder?.addMetadata(["Elevation Ascended" : "432"], completion: {saved,_ in
//            print(saved)
//        })
        
    }


    func togglePause() {
        if running == true {
            WKInterfaceDevice.current().play(.failure)
            self.pause()
        } else {
            WKInterfaceDevice.current().play(.success)
            resume()
        }
    }

    func pause() {
        session?.pause()
    }

    func resume() {
        session?.resume()
    }

    func confirmEnd() {
        showingConfirmationView = true
    }
    
    func endWorkout() {
        self.session?.end()
        showingConfirmationView = false
        showingSummaryView = true
        
        let seconds = 3.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            print(self.workout?.metadata?.keys)
            
//            if let workoutMetadata = self.workout?.metadata {
//                 if let workoutElevation = workoutMetadata["HKElevationAscended"] as? HKQuantity {
//                     print("Elevation = \(workoutElevation.doubleValue(for: HKUnit.meter()))m")
//                 }
//             }

            // Put your code which should be executed with a delay here
            self.locationViewModel?.routeBuilder?.finishRoute(with: self.workout!, metadata: nil, completion: { (newRoute, error)  in
                guard newRoute != nil else {
                    print(error)
                    return
                }
                print("ROUTE SAVED!!")
                self.workoutIsSaved = true
            })

            self.builder?.endCollection(withEnd: Date()) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async() {
                        // Update the user interface.
                    }
                }
            }

        }
        
    }
    

    // MARK: - Workout Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var workout: HKWorkout?

    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }

    func resetWorkout() {
        selectedWorkout = nil
        builder = nil
        workout = nil
        session = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
        locationViewModel = nil
        workoutIsSaved = false
        workoutIsEnded = false
        // end routebuilder thing here so that it doesnt keep "adding data"
    }
    
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        if(event.type == HKWorkoutEventType.pauseOrResumeRequest) {
           togglePause()
       }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        DispatchQueue.main.async {
            self.running = toState == .running
        }
        
        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.workout = workout
                    }
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {

    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return // Nothing to do.
            }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
    
}


