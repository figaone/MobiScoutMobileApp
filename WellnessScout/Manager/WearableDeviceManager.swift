//
//  WearableDeviceManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//

import Foundation
import UIKit
import HealthKit
import WatchConnectivity

@available(iOS 14.0, *)
public class WearableDeviceManager {
    let healthStore: HKHealthStore = HKHealthStore()
    
    // MARK: - Data Types
    
    var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    var shareDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    var allHealthDataTypes: [HKSampleType] {
        let typeIdentifiers: [String] = [
            HKQuantityTypeIdentifier.headphoneAudioExposure.rawValue,
            HKQuantityTypeIdentifier.heartRate.rawValue,
            HKQuantityTypeIdentifier.stepCount.rawValue,
            HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue
        ]
        
        return typeIdentifiers.map { getSampleType(for: $0)! }
        
    }
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
            if let error = error{
                print("\(error)")
            }
        }
    }
    
        func requestHealthDataAccessIfNeeded(dataTypes: [String]? = nil, completion: @escaping (_ success: Bool) -> Void) {
            var readDataTypes = Set(allHealthDataTypes)
            var shareDataTypes = Set(allHealthDataTypes)
    
            if let dataTypeIdentifiers = dataTypes {
                readDataTypes = Set(dataTypeIdentifiers.compactMap { getSampleType(for: $0) })
                shareDataTypes = readDataTypes
            }
    
            requestHealthDataAccessIfNeeded(toShare: shareDataTypes, read: readDataTypes, completion: completion)
        }
    
        /// Request health data from HealthKit if needed.
        func requestHealthDataAccessIfNeeded(toShare shareTypes: Set<HKSampleType>?,
                                                   read readTypes: Set<HKObjectType>?,
                                                   completion: @escaping (_ success: Bool) -> Void) {
            if !HKHealthStore.isHealthDataAvailable() {
                fatalError("Health data is not available!")
            }
    
            print("Requesting HealthKit authorization...")
            healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) in
                if let error = error {
                    print("requestAuthorization error:", error.localizedDescription)
                }
    
                if success {
                    print("HealthKit authorization request was successful!")
                } else {
                    print("HealthKit authorization was not successful.")
                }
    
                completion(success)
            }
        }
        
    
    func fetchStatistics(with identifier: HKQuantityTypeIdentifier,
                               predicate: NSPredicate? = nil,
                               options: HKStatisticsOptions,
                               startDate: Date,
                               endDate: Date = Date(),
                               interval: DateComponents,
                               completion: @escaping (HKStatisticsCollection) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            fatalError("*** Unable to create a step count type ***")
        }
        
        let anchorDate = createAnchorDate()
        
        // Create the query
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: predicate,
                                                options: options,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = { query, results, error in
            if let statsCollection = results {
                completion(statsCollection)
                                
            }
        }
         
        healthStore.execute(query)
    }
    
    
    // MARK: - Authorization
    /// Request health data from HealthKit if needed, using the data types within `HealthData.allHealthDataTypes`
//    class func requestHealthDataAccessIfNeeded(dataTypes: [String]? = nil, completion: @escaping (_ success: Bool) -> Void) {
//        var readDataTypes = Set(allHealthDataTypes)
//        var shareDataTypes = Set(allHealthDataTypes)
//
//        if let dataTypeIdentifiers = dataTypes {
//            readDataTypes = Set(dataTypeIdentifiers.compactMap { getSampleType(for: $0) })
//            shareDataTypes = readDataTypes
//        }
//
//        requestHealthDataAccessIfNeeded(toShare: shareDataTypes, read: readDataTypes, completion: completion)
//    }
//
//    /// Request health data from HealthKit if needed.
//    class func requestHealthDataAccessIfNeeded(toShare shareTypes: Set<HKSampleType>?,
//                                               read readTypes: Set<HKObjectType>?,
//                                               completion: @escaping (_ success: Bool) -> Void) {
//        if !HKHealthStore.isHealthDataAvailable() {
//            fatalError("Health data is not available!")
//        }
//
//        print("Requesting HealthKit authorization...")
//        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) in
//            if let error = error {
//                print("requestAuthorization error:", error.localizedDescription)
//            }
//
//            if success {
//                print("HealthKit authorization request was successful!")
//            } else {
//                print("HealthKit authorization was not successful.")
//            }
//
//            completion(success)
//        }
//    }
    
    
    // MARK: - HKHealthStore
    
//    class func saveHealthData(_ data: [HKObject], completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
//        healthStore.save(data, withCompletion: completion)
//    }
    
    // MARK: - HKStatisticsCollectionQuery
    
//    class func fetchStatistics(with identifier: HKQuantityTypeIdentifier,
//                               predicate: NSPredicate? = nil,
//                               options: HKStatisticsOptions,
//                               startDate: Date,
//                               endDate: Date = Date(),
//                               interval: DateComponents,
//                               completion: @escaping (HKStatisticsCollection) -> Void) {
//        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
//            fatalError("*** Unable to create a step count type ***")
//        }
//
//        let anchorDate = createAnchorDate()
//
//        // Create the query
//        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
//                                                quantitySamplePredicate: predicate,
//                                                options: options,
//                                                anchorDate: anchorDate,
//                                                intervalComponents: interval)
//
//        // Set the results handler
//        query.initialResultsHandler = { query, results, error in
//            if let statsCollection = results {
//                completion(statsCollection)
//
//            }
//        }
//
//        healthStore.execute(query)
//    }
//
    
    
    
    
}

//public class RealtimeHeart{
//    static let healthStore: HKHealthStore = HKHealthStore()
//
//    let allTypes: Set<HKSampleType> = Set([
//                    HKObjectType.workoutType(),
//                    HKSeriesType.heartbeat(),
//                    HKObjectType.quantityType(forIdentifier: .heartRate)!,
//                    HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
//                ])
//
//
//    func requestAuthorization(completion: @escaping (Bool) -> Void){
//        //making our store is initialized
//
//        RealtimeHeart.healthStore.requestAuthorization(toShare: [] , read:allTypes) {success, error in
//            let workoutSession = WorkoutSession(healthStore: self.healthStore)
//            workoutSession.startHeartbeatSampleQuery()
//        }
//    }
//}
