//
//  Logic.swift
//  Loop
//
//  Created by Ally Rilling on 8/8/22.
//

import Foundation
import HealthKit
import CoreLocation

class Logic: ObservableObject {
    
    let healthStore = HKHealthStore()
    @Published var steps = -1
    
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
        
    }
    
    func testSampleQuery() -> Int {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        var dist = 0
        
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
            
        guard let endDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
         
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: endDate) else {
            fatalError("*** Unable to create the end date ***")
        }

        let lastSeven = HKQuery.predicateForSamples(withStart: startDate, end: now, options: [])
        
        let query = HKSampleQuery.init(sampleType: sampleType!,
                                       predicate: lastSeven,
                                       limit: HKObjectQueryNoLimit,
                                       sortDescriptors: nil) { (query, results, error) in
            print(results!)
        }
        
        
        healthStore.execute(query)
        return dist
    }
    
    func readWorkouts() async -> [HKWorkout]? {
        let calendar = NSCalendar.current
        let now = Date()
        let running = HKQuery.predicateForWorkouts(with: .running)
        // DateInterval(start: calendar.date(byAdding: .day, value: -7, to: now), end: now)
        let lastSeven = HKQuery.predicateForSamples(withStart: calendar.date(byAdding: .day, value: -7, to: now), end: now, options: [])

        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKSampleQuery(sampleType: .workoutType(), predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [running, lastSeven] ), limit: HKObjectQueryNoLimit,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }

        return workouts
    }
    
    func getLastRun() async -> HKWorkout? {
        let calendar = NSCalendar.current
        let now = Date()
        let running = HKQuery.predicateForWorkouts(with: .running)
        // DateInterval(start: calendar.date(byAdding: .day, value: -7, to: now), end: now)

        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKSampleQuery(sampleType: .workoutType(), predicate: running, limit: HKObjectQueryNoLimit,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }
        
//        if #available(iOS 16.0, *) {
//            print("\(workouts[0].statistics(for: HKQuantityType(.distanceWalkingRunning))!.sumQuantity())")
//            print("\(workouts[0].statistics(for: HKQuantityType(.stepCount)))")
//        } else {
//            // Fallback on earlier versions
//        }

        return workouts[0]
    }
    
    func queryLastRunStats() async -> HKWorkout? {
        let running = HKQuery.predicateForWorkouts(with: .running)

        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKSampleQuery(sampleType: .workoutType(), predicate: running, limit: 1, sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkout] else {
            return nil
        }
        
//        if #available(iOS 16.0, *) {
//            print("\(workouts[0].statistics(for: HKQuantityType(.distanceWalkingRunning))!.sumQuantity())")
//            print("\(workouts[0].statistics(for: HKQuantityType(.stepCount)))")
//        } else {
//            // Fallback on earlier versions
//        }
//        workouts[0].
        return workouts[0]
    }
    
    func getWorkoutRoute(workout: HKWorkout) async -> [HKWorkoutRoute]? {
        let byWorkout = HKQuery.predicateForObjects(from: workout)

        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            healthStore.execute(HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: byWorkout, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: { (query, samples, deletedObjects, anchor, error) in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    return
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkoutRoute] else {
            return nil
        }

        return workouts
    }

    func getLocationDataForRoute(givenRoute: HKWorkoutRoute) async -> [CLLocation] {
        let locations = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CLLocation], Error>) in
            var allLocations: [CLLocation] = []

            // Create the route query.
            let query = HKWorkoutRouteQuery(route: givenRoute) { (query, locationsOrNil, done, errorOrNil) in

                if let error = errorOrNil {
                    continuation.resume(throwing: error)
                    return
                }

                guard let currentLocationBatch = locationsOrNil else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                allLocations.append(contentsOf: currentLocationBatch)

                if done {
                    continuation.resume(returning: allLocations)
                }
            }

            healthStore.execute(query)
        }

        return locations
    }

    
}

