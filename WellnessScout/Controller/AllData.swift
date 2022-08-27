//
//  AllData.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//

import Foundation

import UIKit
import CoreMotion
import AVFoundation
import CoreLocation
import Charts
import Amplify
import AWSS3

//MARK: Used to keep track of all the data using a Singelton
//STORES ALL DATA IN THIS CLASS THAT IS USED IN MULTIPLE PLACES

class AllData{
    //creates instance of this class
    //use singelton by Singleton.shared.doSomething()
    //MARK: Singelton Instance
    static let shared = AllData()
    
    //MARK: //Data for the singelton declared here//
    
    
    
    //MARK:Objects used to interface with the hardware
    //video object that controls the video layer
    var previewLayer = AVCaptureVideoPreviewLayer()
    //session object that controls the capture session label
    var captureSession = AVCaptureSession()
    //moveie output
    var movieOutput = AVCaptureMovieFileOutput()
    //active input
    var activeInput : AVCaptureDeviceInput!
    //object that controls access and control to the sensors
    var motionManager = CMMotionManager()
    //refrence to the back camera
    var backCamera : AVCaptureDevice!
    //refrence to the front camera
    var frontCamera : AVCaptureDevice!
    //current camera we are using
    var currentCamera : AVCaptureDevice!
    //photo output
    var photoOutput = AVCapturePhotoOutput()
    //variables
    var outputURL: URL?
    //cell
    var cellData : [Cell] = []
    //inits the timer used for animation
    var clockTimer = Timer()
    //inits the health data
    var healthdataArray : [HealthData] = []
    var heatlthdataObject = HealthData()
    //inits the timer used for recording data
    var recordDataTimer = Timer()
    var recordAwsTimer = Timer()
    //timer that will save data every minute automatically
    var saveDataTimer = Timer()
//    storage upload progress array
    var storageTaskArray2 : [StorageUploadFileOperation] = []
    //z sensor data used for graphing
    var graphData : [GraphData] = []
    //timer that runs for the graph
    var graphTimer = Timer()
    //is recording variable
    var isRecording = false
    //var used for the front camera
    var frontCameraEnabled = false
    //array of sensor data
    var sensorDataArray : [SensorData] = []
    //the rate to record the sensor data 1/t = hz
    var sensorFrequency = 0.033
    //sensor data obj
    var sensorDataOBJ = SensorData()
    //date tat the user starts recording
    var recordingStartDate = Date()
    //temp url
    var tempURL : URL!
    //video ID, used to track the video id
    var videoID : Double = 0
    //name
    var name : String = ""
    //url of the video
    var videoURL : String = ""
    //uid of local data stored file
    var dateStoredId : String = ""
    // heart rate variable
    var heartRate : Double = 0
    var heartRateArray = [Double]()
    
    //MARK: Objects used for location
//    var mangaer = CLLocationManager()
    //total distance the user has traveled in each session
    var totalDistance : Double = 0
    
    
    var dateStored: String?
    var driverMonitorURL: String?
    var roadViewURL: String?
    var sensorDataURL: String?
    var initiaLHealthData: String?
    var initialVehicleData: String?
    
    
    
    
    
    //MARK: Priavte constructer
    //inits class as private so we dont have duplicates of this class
    private init() {}
}

