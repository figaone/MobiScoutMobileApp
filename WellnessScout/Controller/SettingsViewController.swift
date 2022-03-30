//
//  SettingsViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/24/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK:Helper classes
    let vidManager = ViewController()
    //instance to the helper class that controls sensor data
    let sensorManager = SensorManager()
    //instance to helper class to control the video
    let videoManager = VideoManager()
    //instance to helper class that managers the default values
    let defaultManager = DefaultsManager()
    //instance of the helper class used to control multi cam
//    let multipleCameraManager = MultipleVideoManager()
    
    //MARK:Outlets for the view controller
    
    //labels
    
    @IBOutlet weak var sensorFrequencyLabel: UILabel!
    @IBOutlet weak var videoFrameRateLabel: UILabel!
    
//    @IBOutlet weak var autoSaveTimeLabel: UILabel!
    
    //sliders
    
    @IBOutlet weak var frequencySlider: UISlider!
    
    @IBOutlet weak var videoFrameRateSlider: UISlider!
    //    @IBOutlet weak var autoSaveSlider: UISlider!
    @IBOutlet weak var fpsRangeLabel: UILabel!
    

    //labels that indicate where the slider is
    @IBOutlet weak var sliderVideoFrameRateLabel: UILabel!
    
    @IBOutlet weak var sliderFrequencyLabel: UILabel!
    
    //    @IBOutlet weak var siderAutoSaveLabel: UILabel!
    //switches
    //    @IBOutlet weak var saveVideoToPhotos: UISwitch!
    
    @IBOutlet weak var saveVideoToPhotos: UISwitch!
    
    //    @IBOutlet weak var hideAllViews: UISwitch!
    //    @IBOutlet weak var multiCamera: UISwitch!
    
    //MARK: Local Variables
    var userData : UserDefaultsData!
    
    
    //fires when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        saveVideoToPhotos.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)
        //calls the function to setup the values from the defaults
        reloadValues()
    }
    
    
    //fires when the view appears
    override func viewDidAppear(_ animated: Bool) {
        //checks to see if multi cams is supported or not
//        if multipleCameraManager.checkDeviceSupport() == false {
//            //disable the ability to change the switch
//            multiCamera.isEnabled = false
//        } else{
//            //enables the multi camera button
//            multiCamera.isEnabled = true
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
    }
    
    //used to change the frequency of the sensor data
    @IBAction func frequencySliderChanged(_ sender: Any) {
            sliderFrequencyLabel.text = "Frequency is : \(Int(frequencySlider.value)) Hz"
    }
    
    //used to change the video frame rate
    @IBAction func videoFrameSlider(_ sender: Any) {
                //change the frame rate based on the slider value
                sliderVideoFrameRateLabel.text = "Frame rate is : \(Int(videoFrameRateSlider.value)) FPS"
    }
    
    @objc func switchStateDidChange(_ sender:UISwitch!)
        {
            userData = defaultManager.getUserDefaults()
            if (sender.isOn == true){
                print("UISwitch state is now ON")
                userData.automaticUpload = true
                print(userData.automaticUpload)
                defaultManager.setUserDefaults(userData: userData)
            }
            else{
                print("UISwitch state is now Off")
                userData.automaticUpload = false
                print(userData.automaticUpload)
                defaultManager.setUserDefaults(userData: userData)
            }
        }
    //used to change the auto save time interval
//    @IBAction func autoSaveTimerSlider(_ sender: Any) {
//        //change auto save timer based on the slider value
//        siderAutoSaveLabel.text = "Auto Save Time: \(Int(autoSaveSlider.value)) seconds"
//    }
    
    //function used tio update the view when values are changed
    func reloadValues(){
//        //get the current user defaults and set it to the local variable to be used later
//        userData = defaultManager.getUserDefaults()
//        //set the current frame rate and frequency labels
//        videoFrameRateLabel.text = "Current Video Frame Rate: \(userData.frameRate ?? 0) FPS"
//        //set the sensor frequency label
//        sensorFrequencyLabel.text = "Current Sensor Frequency Rate: \(Int(userData.frequency) ?? Int(sensorManager.getSensorRate(motionManager: AllData.shared.motionManager))) Hz"
//        //load the default frame rate here
//        fpsRangeLabel.text = "Supported FPS Range: \(videoManager.printSupportedFPSRanges()) FPS"
//        //set the autosave time
////        autoSaveTimeLabel.text = "Auto Save Time: \(userData.autoSaveTime) seconds"
//        //set the default values for the sliders
//        videoFrameRateSlider.value = Float(userData.frameRate ?? vidManager.getMaxFrameRateValue())
//        //set the frequency slider value
//        frequencySlider.value = Float(Int(userData.frequency) ?? Int(sensorManager.getSensorRate(motionManager: AllData.shared.motionManager)))
//        //init the intial slider values
//            sliderFrequencyLabel.text = "Sensor Frequency is : \(frequencySlider.value) Hz"
//       
//        sliderVideoFrameRateLabel.text = "Video Frame rate is : \(videoFrameRateSlider.value) FPS"
//        //set the values for the swithes
//        saveVideoToPhotos.isOn = userData.automaticUpload
//        //think of it as show views not hide all views
////        hideAllViews.isOn = userData.hideAllViews ?? true
//        //set the multi cam to on or off
////        multiCamera.isOn = userData.multiCameraViewEnabled ?? false
    }

//    //fires when the user confirms the new values via sliders
    
    @IBAction func setNewValuesButtonPressed(_ sender: Any) {
                //chekcs to make sure that we aren't already recording before we switch settings
                if AllData.shared.movieOutput.isRecording == false{
                    //sets the new frame rate
                    print(videoFrameRateSlider.value)
                    vidManager.setFrameRate(frameRate: Double(Int(videoFrameRateSlider.value)))
//                    videoManager.setFrameRate(frameRate: Double(Int(videoFrameRateSlider.value)))
                    //videoManager.setRate(frameRate: 60)
                    //videoManager.setFrameRate(SingeltonData.shared.backCamera, frameRate: Int32(videoFrameRateSlider.value))
                    //set the new frequency to measure sensor data at
                    sensorManager.setTimeInterval(motionManager: AllData.shared.motionManager, updateInterval: TimeInterval(1/frequencySlider.value))
                    //let data update interval equal to 80 percent the sensor frequency
                    AllData.shared.sensorFrequency = Double((1/frequencySlider.value) * 0.80)
                    //save the data so iot persists
                    //set the new default values
                    let userData = UserDefaultsData()
                    //set the auto save time
        //            userData.autoSaveTime = TimeInterval(Int(autoSaveSlider.value))
                    //set the frequency
                    userData.frequency = Double(frequencySlider.value)
                    //set the frames
                    userData.frameRate = Double(Int(videoFrameRateSlider.value))
                    //set the buttons
        //            userData.hideAllViews = hideAllViews.isOn
                    //set the save to camera roll button
                    userData.automaticUpload = saveVideoToPhotos.isOn
                    print(userData.automaticUpload)
                    //set the multi camera button
        //            userData.multiCameraViewEnabled = multiCamera.isOn
                    //set the default values and save them
                    defaultManager.setUserDefaults(userData: userData)
                    //reset the timers if any are running since we changed the values so old data in invalid
                    //reload the view
                    reloadValues()
                    //MARK:CHANGE LATER LEAVE FOR NOW
                    presentAlert(withTitle: "Multi-Camera Alert", message: "Restart the app to apply camera changes!", actions: [ "OK": UIAlertAction.Style.cancel])
                }else{
                    //the user was already recording data and tried to change settings, this isn't allowed
                    presentAlert(withTitle: "Error", message: "You can't change user settings while recording, finish recording and try again.", actions: [ "OK": UIAlertAction.Style.cancel])
                }
    }
}

extension UIViewController {
    //presents an alert controller
    func presentAlert(withTitle title: String, message : String, actions : [String: UIAlertAction.Style], completionHandler: ((UIAlertAction) -> ())? = nil) {
        //create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //loop through actions passed into alert controller
        for action in actions {
            //generate the action
            let action = UIAlertAction(title: action.key, style: action.value) { action in
                //create the completion handler
                if completionHandler != nil {
                    completionHandler!(action)
                }
            }
            //add the actions to the controller
            alertController.addAction(action)
        }
        //present to the user
        self.present(alertController, animated: true, completion: nil)
    }
}


