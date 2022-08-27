//
//  MobileSensorManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//




import Foundation
import CoreMotion

public class SensorManager {
//MARK:Used to manage the Sensor data
    
    func setTimeInterval(motionManager : CMMotionManager, updateInterval : TimeInterval){
        //sets the update interval
        //.01 second = 100 Hz  1/time = hertz
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.gyroUpdateInterval = updateInterval
        motionManager.magnetometerUpdateInterval = updateInterval
        motionManager.deviceMotionUpdateInterval = updateInterval
    }
    //function used to start updating the sensor data
    func startUpdatingSensorData(motionManager: CMMotionManager){
        //starts the updating of all the sensors
        motionManager.startGyroUpdates()
        motionManager.startDeviceMotionUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startAccelerometerUpdates()
    }
    //function used to stop updating the sensor data
    func stopUpdatingSensorData(motionManager: CMMotionManager){
        //stops the updating of the sensors
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopMagnetometerUpdates()
        motionManager.stopAccelerometerUpdates()
    }
    //function used to check for hardware ( for debugging)
    func checkForHardware(motionManager: CMMotionManager){
        //checks to see if the hardware we want is avaliable
        print("Gyro Avaliable?", motionManager.isGyroAvailable)
        print("Device Motion Avaliable?", motionManager.isDeviceMotionAvailable)
        print("Magnetometer Avaliable?", motionManager.isMagnetometerAvailable)
        print("Accelerometer Avaliable?", motionManager.isAccelerometerAvailable)
    }
    //function used to check if the sensors are activite (for debugging)
    func checkIfActive(motionManager: CMMotionManager)-> Bool{
        //checks to see if the hardware we want is avaliable
        if motionManager.isGyroActive && motionManager.isDeviceMotionActive && motionManager.isMagnetometerActive && motionManager.isAccelerometerActive{
            //return true if all sensors are active
            return true
        }else{
            //print values if error
            print("Gyro Active?", motionManager.isGyroActive)
            print("Device Motion Active?", motionManager.isDeviceMotionActive)
            print("Magnetometer Active?", motionManager.isMagnetometerActive)
            print("Accelerometer Active?", motionManager.isAccelerometerActive)
            return false
        }
    }
    
    
    //function used to check if we are getting data from the motion manager devices
    func checkData(motionManager : CMMotionManager)-> Bool{
        //acceleromter data from the manager class
        let accelerometerData =  motionManager.accelerometerData
        //gyroscope data
        let gyroscopeData = motionManager.gyroData
        //magnetmeter data
        let magnetometerData = motionManager.magnetometerData
        //device motion data acceleration,altitude rotation rates, orientation
        let deviceMotionData = motionManager.deviceMotion
        
        //check to make sure there is data
        if accelerometerData != nil && gyroscopeData != nil && magnetometerData != nil && deviceMotionData != nil{
            //return true if all are returning data
            return true
        }else{
            //return false if we don't have data
            return false
        }
    }
    
    
    
    //function that prints the sensor data to the console
    func printSensorData(motionManager: CMMotionManager){
        //function prints the sensor data
        //acceleromter data from the manager class
        let accelerometerData =  motionManager.accelerometerData
        //gyroscope data
        let gyroscopeData = motionManager.gyroData
        //magnetmeter data
        let magnetometerData = motionManager.magnetometerData
        //device motion data acceleration,altitude rotation rates, orientation
        let deviceMotionData = motionManager.deviceMotion
        //prints the sensor data
        print("Accelerometer Data=", accelerometerData as Any)
        print("")
        print("Gyroscope Data=", gyroscopeData as Any)
        print("")
        print("Magnetometer Data=", magnetometerData as Any)
        print("")
        print("Device Motion Data=", deviceMotionData as Any)
    }
    
    
    //function used to get the default sensor time interval
    func getSensorRate(motionManager : CMMotionManager)->TimeInterval{
        //return the default interval the sesnors are recording at
        return motionManager.gyroUpdateInterval
    }
    
    
    
    //function used to save the graph data
    func saveGraphData(motionManager : CMMotionManager){
        //graph data
        let accelerationX = motionManager.accelerometerData?.acceleration.x
        let accelerationY = motionManager.accelerometerData?.acceleration.y
        let accelerationZ = motionManager.accelerometerData?.acceleration.z
        //set the values and add them to the data
        let graphData = GraphData()
        //add the graph data values
        graphData.accelerometerX = accelerationX
        graphData.accelerometerY = accelerationY
        graphData.accelerometerZ = accelerationZ
        //add the graph data to the array
        AllData.shared.graphData.append(graphData)
    }
    
}



//import Foundation
//import CoreMotion
//
//var xdata : [Double] = []
//var ydata : [Double] = []
//var zdata : [Double] = []
//
//var pitchdata : [Double] = []
//var rollxdata : [Double] = []
//var yawdata : [Double] = []
//
//
//
//class MobileSensorManager {
//    private var motionManager : CMMotionManager
//    var userData : UserDefaultsData!
//
//    //instance of the firebase manager class
//    let firebaseManager = FirebaseManager()
//
////    let chartdata = GraphData()
////    let singleData = SingleData.shared.graphData
//
//
//
//    init() {
//        self.motionManager = CMMotionManager()
//    }
//
//    func startUpdatingSensorData(){
//        //starts the updating of all the sensors
//        motionManager.startGyroUpdates()
//        motionManager.startDeviceMotionUpdates()
//        motionManager.startMagnetometerUpdates()
//        motionManager.startAccelerometerUpdates()
//    }
//
//    func sensorDataUpdate() {
//        let sensorDataObj = SensorData()
//        let allData = AllData.shared
//
//        motionManager.gyroUpdateInterval = 0.5
//        motionManager.startGyroUpdates(to: OperationQueue.current!){ (data,error) in
////            print(data as Any)
//            if let e = error {
//                print(e.localizedDescription)
//
//
//            } else{
//                sensorDataObj.gyroDataX = data?.rotationRate.x
//                sensorDataObj.gyroDataY = data?.rotationRate.y
//                sensorDataObj.gyroDataZ = data?.rotationRate.z
//
////                allData.sensorDataArray.append(sensorDataObj)
////                print(allData.sensorDataArray)
////                for data in allData.sensorDataArray{
////                    print(data.gyroDataX!)
////                }
//            }
//        }
//
//        motionManager.accelerometerUpdateInterval = 0.5
//        motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data,error) in
//            if let e = error {
//                print(e.localizedDescription)
//
//
//            } else{
//                sensorDataObj.accelerationX = data?.acceleration.x
//                sensorDataObj.accelerationY = data?.acceleration.y
//                sensorDataObj.accelerationZ = data?.acceleration.z
//            }
//
//
//        }
//
//        motionManager.deviceMotionUpdateInterval = 0.5
//        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {(data,error) in
//            if let e = error {
//                print(e.localizedDescription)
//
//
//            } else{
//                sensorDataObj.pitchData = data?.attitude.pitch
//                sensorDataObj.rollData = data?.attitude.roll
//                sensorDataObj.yawData = data?.attitude.yaw
//                sensorDataObj.quaternionX = data?.attitude.quaternion.x
//                sensorDataObj.quaternionY = data?.attitude.quaternion.y
//                sensorDataObj.quaternionZ = data?.attitude.quaternion.z
//                sensorDataObj.quaternionW = data?.attitude.quaternion.w
//                sensorDataObj.timeStamp = data?.timestamp
//            }
//
//
//
//    }
//
//        motionManager.magnetometerUpdateInterval = 0.5
//        motionManager.startMagnetometerUpdates(to: OperationQueue.current!){(data,error) in
//            if let e = error {
//                print(e.localizedDescription)
//
//
//            } else{
//                sensorDataObj.pitchData = data?.magneticField.x
//                sensorDataObj.rollData = data?.magneticField.y
//                sensorDataObj.yawData = data?.magneticField.z
//            }
//
//        }
//        sensorDataObj.timeStamp = AllData.shared.motionManager.deviceMotion?.timestamp
//        sensorDataObj.unixTimestamp = Date().timeIntervalSince1970
//        sensorDataObj.videoID = AllData.shared.videoID
////        if userData.saveToPhotoLibrary == false{
////            //save the json data as we collect it
////            firebaseManager.saveIndividualSensorData(saveLocation: AllData.shared.name, sensorData: sensorDataObj, videoName: AllData.shared.videoURL)
////        }
//        allData.sensorDataArray.append(sensorDataObj)
////        for data in allData.sensorDataArray{
////            print(data)
////        }
//    }
//
//}
//
////- (void) startMotionUpdate {
////
////if (self.motionManager == nil) {
////    self.motionManager = [[CMMotionManager alloc] init];
////}
////
////self.motionManager.deviceMotionUpdateInterval = kUpdateInterval;
////
////[self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical
////                                                        toQueue:self.deviceQueue
////                                                    withHandler:^(CMDeviceMotion *motion, NSError *error)
////{
////    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
////        CGFloat x = motion.gravity.x;
////        CGFloat y = motion.gravity.y;
////        CGFloat z = motion.gravity.z;
////
////
////        CMQuaternion quat = self.motionManager.deviceMotion.attitude.quaternion;
////        double yaw = asin(2*(quat.x*quat.z - quat.w*quat.y));
////
////        DLog(@"Yaw ==> %f", yaw);
////
////        double myPitch = radiansToDegrees(atan2(2*(quat.x*quat.w + quat.y*quat.z), 1 - 2*quat.x*quat.x - 2*quat.z*quat.z));
////
////        DLog(@"myPitch ==> %.2f degree", myPitch);
////
////        self.motionLastPitch = myPitch;
////    }];
////}];
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
