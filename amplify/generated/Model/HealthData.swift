//
//  Healthdata.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/25/21.
//

import Foundation

class HealthData: Codable{
    var HeartRate:[Double] = []
    var HeadphoneAudioExposure:[Double] = []
    var DistanceWalkingRunning:[Double] = []
    var StepCount:[Double] = []
}
