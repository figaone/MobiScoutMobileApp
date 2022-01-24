//
//  InterfaceController.swift
//  wearablePart WatchKit Extension
//
//  Created by Sharma, Anuj [CCE E] on 1/15/22.
//

import WatchKit
import Foundation
import HealthKit


class MainInterfaceController: WKInterfaceController{
   
    

    @IBOutlet weak var appNameLabel: WKInterfaceLabel!
    @IBOutlet weak var stepCountsLabel: WKInterfaceLabel!
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        print("AWAKE")
        
        WorkoutTracking.shared.requestAuthorization()
//        WorkoutTracking.authorizeHealthKit()
//        WorkoutTracking.shared.startWorkOut()
        WorkoutTracking.shared.delegate = self
//        workoutManager.requestAuthorization()
//        workoutManager.session?.delegate = self
        WatchKitConnection.shared.delegate = self
        WatchKitConnection.shared.startSession()
//        DispatchQueue.main.async {
//            self.heartRateLabel.setText(self.workoutManager.heartRate.formatted(.number.precision(.fractionLength(0))) + " bpm")
//        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        print("WILL ACTIVE")
//        workoutManager.requestAuthorization()
//        WorkoutTracking.shared.fetchStepCounts()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        print("DID DEACTIVE")
    }
    
    @IBAction func startWorkoutPressed(){
        WorkoutTracking.shared.startWorkOut()
       
    }
    
    @IBAction func stopWorkoutPressed(){
        WorkoutTracking.shared.stopWorkOut()
        
    }
    
    func controlWorkout(controlType:String){
        if controlType == "start"{
            startWorkoutPressed()
        }else{
            stopWorkoutPressed()
        }
    }

}

extension MainInterfaceController: WorkoutTrackingDelegate {
    func didReceiveHealthKitHeartRate(_ heartRate: Double) {
        heartRateLabel.setText("\(heartRate) BPM")
        WatchKitConnection.shared.sendMessage(message: ["heartRate":
            "\(heartRate)" as AnyObject])
    }

    func didReceiveHealthKitStepCounts(_ stepCounts: Double) {
        stepCountsLabel.setText("\(stepCounts) STEPS")
    }
}

extension MainInterfaceController: WatchKitConnectionDelegate {
    func didReceiveUserName(_ userName: String) {
        print(userName)
        appNameLabel.setText(userName)
        controlWorkout(controlType: userName)
    }
}
