//
//  SensorData.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//

import Foundation
import UIKit
import CoreMotion



class SensorData: Codable{
    
    //MARK: Add device motion data here
    
    //latitude
    var latitude : Double!
    //longitude
    var longitude : Double!
    //accelerometer data x
    var accelerationX : Double!
    //accelerometer data y
    var accelerationY : Double!
    //accelerometer data z
    var accelerationZ : Double!
    //gyro data x
    var gyroDataX : Double!
    //gyro data z
    var gyroDataY : Double!
    //gyro data z
    var gyroDataZ : Double!
    //pitch
    var pitchData : Double!
    //roll
    var rollData : Double!
    //yaw
    var yawData : Double!
    //quadrant Data x
    var quaternionX : Double!
    //quadrant Data y
    var quaternionY : Double!
    //quadrant Data z
    var quaternionZ : Double!
    //quadrant Data w
    var quaternionW : Double!
    //gravity data
    var gravityDataX : Double!
    //gravity data
    var gravityDataY : Double!
    //gravity data
    var gravityDataZ : Double!
    //user acceleration
    var userAccelerationX : Double!
    //user acceleration
    var userAccelerationY : Double!
    //user acceleration
    var userAccelerationZ : Double!
    //timestamp
    var timeStamp : Double!
    //image of a stress location
    var image : Data!
    //sensor timestamp
    var unixTimestamp : Double!
    //type of stress identified
    //var stressType : StressType!
    //video that will be saved
    var videoData : Data!
    //speed of the device at that moment in time in meters per second
    var deviceSpeed : String!
    //video name
    var videName : String!
    //the video id
    var videoID : Double!
    //total distance in meters
    var distanceInMetersTotal : Double!
    //header info
    var header : Double!
    
    var heartRate : Double!
}

