//
//  CameraViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//

import UIKit
import AVFoundation
import Photos
import HealthKit
import CoreMotion
import CoreLocation
import Amplify
import AmplifyPlugins
import OrderedCollections
import Combine
import MapKit
import CareKit
import Charts
import Vision

var start = "true"
var AvSpeed : Any = 0
var trvdistance : Any = 0
var miSpeed : Any = 0
var maxSpeed : Any = 0
var time_cst : Any = 0
//<String, Int>
var dtaURLS = DateStored()
//var realDat = DateStored()
//Dictionary for health data
var firstdat : OrderedDictionary<String, [Any]> = ["Date":[],"StepCount":[],"DistanceWalkingRunning":[],"HeadphoneAudioExposure":[],"HeartRate":[]]
var obdData : OrderedDictionary<String, [Any]> = [:]
var recordedDataDictionary : OrderedDictionary<String, [Any]> = ["id":[],"indexVal":[],"time_utc":[],"time_cst": [],"gps_lat":[],"gps_long":[],"accel_x":[],"accel_y":[],"accel_z":[],"gyro_x":[],"gyro_y":[],"gyro_z":[],"pitch":[],"roll":[],"yaw":[],"quarternionX":[],"quarternionY":[],"quarternionZ":[],"quarternionW":[],"userAccelerationX":[],"userAccelerationY":[],"userAccelerationZ":[],"timeStamp":[],"unixTimeStamp":[],"heartRateWearablePart":[],"speedMobileDevice(mph)":[],"speedVehicleOBD(mph)":[],"rpmVehicleOBD(rpm)":[],"temperatureVehicleOBD(C)":[],"videoName":[],"videoID":[],"distance_miles":[],"straightDistanceInMiles":[],"gps_elevation":[],"headingcardinal":[],"gps_heading":[],"savelocationID":[]]
var DataArraySensor : [MainSensorData] = []
var stepC = [Double].self
var heartRt = [Double].self
var distancewlk = [Double].self
//var autostart : Bool = true

enum sensorType{
    case sensorData
    case initialHealthData
    case canBusData
}
var sensorDataState: sensorType = .sensorData

enum cameraType {
    case frontcam
    case backcam
}
var camState: cameraType = .backcam


@available(iOS 14.0, *)
class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, CLLocationManagerDelegate,MKMapViewDelegate{
    
    
        
    var existingPost: DateStored = DateStored()
    var frntcm : String = ""
    var stepC = [[Double]]()
    var heartRt = [[Double]]()
    var distancewlk = [[Double]]()
    var hasRequestedHealthData: Bool = false

    var startDate: Date!
    var traveledDistance: Double = 0
    var arrayMPH: [Double]! = []
    let now = Date()
    var minSpeedLabel : String!
    var maxSpeedLabel : String!
    var avgSpeedLabel : String!
    var distanceLabel : String!
    
    @IBOutlet weak var graphView: LineChartView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var heartRateImage: UIImageView!
    @IBOutlet weak var heartRateValue: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var doubleTapToExit: UILabel!
    
    
    @IBOutlet weak var speedometerTextField: UILabel!
    @IBOutlet weak var watchConnectionIcon: UIImageView!
    @IBOutlet weak var adaptorStatusLabel: UILabel!
    @IBOutlet weak var obdAdaptorButtonOutlet: UIButton!
    
    @IBOutlet weak var videoStackView: UIStackView!
    @IBOutlet weak var accelerationInZ: UILabel!
    
    let tabBarControl = TabBarViewController()
    //instance of the defaults manager
    let csvParser = CSVparser()
    let sot = SourceOfTruth()
    let amplifyVidUpload = AmplifyDataUpload()
    let defaultsManager = DefaultsManager()
    var userData : UserDefaultsData!
    let allData = AllData.shared
    let sensorManager = SensorManager()
    var timer = Timer()
    //instance of the local file manager class
    let localFileManager = LocalFileManager()
    //instance of the video manager class
    let videoManager = VideoManager()
    let graphManager = GraphManager()
    //instance of locationmanager
    var deviceLocationService = LocationManager.shared
    // instance of Obd main manager
    //Combine syncs being stored
    var tokens: Set<AnyCancellable> = []
    //tuples for latitude and lonagitude
    var coordinates: (lat: Double, lon: Double) = (0,0)
    //value for speed
    var speedMain: String = ""
    //value for distance
    var distanceMain: Double = 0
    //value for straightdistance
    var StraightdistanceMain: Double = 0
    //value for header
    var headerMain: String = ""
    
    var gpsHeading : Double = 0
    //value for altitude
    var altitudeMain: Double = 0
    //value for watch heart rate
    var heartRateMain: Double = 0
    //value for obd car speed
    var obdSpeedMain: String = ""
    //value for obd car rpm
    var obdRpmMain: String = ""
    //value for obd car temperature
    var obdTempMain: String = ""
    //vehicleinfoManager
    var vehicleInfoManager = VehicleInfoManager()
    //set the state of the workoutcontrol for watch
    var workoutContorl: String = "start"
    let healthStore1: HKHealthStore = HKHealthStore()

    var healthdataObject = [InitialHealthData]()
    
    let healthStore = WearableDeviceManager()
    
   
    let calendar: Calendar = .current
    
    var mobilityContent: [String] = [
        HKQuantityTypeIdentifier.heartRate.rawValue,
        HKQuantityTypeIdentifier.stepCount.rawValue,
        HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue,
        HKQuantityTypeIdentifier.headphoneAudioExposure.rawValue
       
//        HKCategoryTypeIdentifier.sleepAnalysis.rawValue
    ]
//    let zyz = DateStored()
    
    var data: [(dataTypeIdentifier: String, values: [Double])] = []
   var deleted: [String] = []
    
    let watchControl = WatchKitConnection.shared
    
    //obd manager instance
    
    let instanceOfCustomObject = CustomObject()
    var recordTimerObd = Timer()
    
    //set
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let amplifySessions = AmplifySessionManager()
    
    //Vision Variables
    private var requests = [VNRequest]()
    // VNRequest: Either Retangles or Landmarks
    private var faceDetectionRequest: VNRequest!
    
    // MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        healthStore.requestAuthorization()
        self.performQuery()
        
        // initialize the map view
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
       
        //start observing data appended to amplify local data store
        amplifyVidUpload.observeDataStore()

        
        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        recordButton.layer.masksToBounds = true
        recordButton.layer.borderWidth = 5
        recordButton.layer.borderColor = UIColor.white.cgColor
        
      
        
        
        //hide blurred view
        blurredUiView.isHidden = true
       
        
        //get user defaults data
        userData = defaultsManager.getUserDefaults()
       
        sensorManager.startUpdatingSensorData(motionManager: allData.motionManager)
        
        
//        requestHealthAuthorization()
        
       
        
        //prevent screen rotation for viewcontroller
        appDelegate.shouldRotate = false
        
        //location data callers
        observeCoordinateUpdates()
        observeSpeed()
        observeTraveledDistance()
        observeStraightDistance()
        observeHeaderInfo()
        observeAltitude()
        
        //check for location update authorisations
        observeLocationAccessDenied()
        deviceLocationService.requestLocationUpdates()
        
    
        //retrive saved local user data in amplifi datastore
        amplifyVidUpload.retrieveURLStored()
        
        //set the watchkit connection
        WatchKitConnection.shared.delegate = self
        
        //start the watch app/extension
        WatchKitConnection.shared.startWatchApp()
        
        //observe watch connection
        observeWatcKitConnectionStatus()
        
        //start observing heartrate from watch extension
        observeHeartRate()
        
        //set the vehicle info manager delegate
        vehicleInfoManager.delegate = self
        
        
        //start OBD connection
        instanceOfCustomObject.onStartup()
            //start observing obd data
        self.recordTimerObd = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.testContinues), userInfo: nil, repeats: true)
        
        
        data = mobilityContent.map { ($0, []) }
     
        
        // Allow users to double tap to switch between the front and back cameras being in a PiP
//        let togglePiPDoubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(togglePiP))
//        togglePiPDoubleTapGestureRecognizer.numberOfTapsRequired = 2
//        view.addGestureRecognizer(togglePiPDoubleTapGestureRecognizer)
       
 
        
        
        localFileManager.createDirectory()
        // Disable UI. Enable the UI later, if and only if the session starts running.
        recordButton.isEnabled = false
        
        
        // Set up the back and front video preview views.if let backcam = backCameraVideoPreviewView, let frontcam = frontCameraVideoPreviewView{
        backCameraVideoPreviewView.videoPreviewLayer.setSessionWithNoConnection(session)
        frontCameraVideoPreviewView.videoPreviewLayer.setSessionWithNoConnection(session)
    
        
        
        
        // Store the back and front video preview layers so we can connect them to their inputs
        backCameraVideoPreviewLayer = backCameraVideoPreviewView.videoPreviewLayer
        frontCameraVideoPreviewLayer = frontCameraVideoPreviewView.videoPreviewLayer
        
        
        // Store the location of the pip's frame in relation to the full screen video preview
//        updateNormalizedPiPFrame()
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        // Set up Vision Request
        faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: handleFaceLandmarks) // Default
        setupVision()
        
        /*
        Configure the capture session.
        In general it is not safe to mutate an AVCaptureSession or any of its
        inputs, outputs, or connections from multiple threads at the same time.
        
        Don't do this on the main queue, because AVCaptureMultiCamSession.startRunning()
        is a blocking call, which can take a long time. Dispatch session setup
        to the sessionQueue so as not to block the main queue, which keeps the UI responsive.
        */
        sessionQueue.async {
            self.configureSession()
        }
        
        // Keep the screen awake
        UIApplication.shared.isIdleTimerDisabled = true
        
        print("this the max frame rate",getMaxFrameRateValue())
        print("this the set frame rate",self.backCameraDeviceInput?.device.activeVideoMaxFrameDuration as Any)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    
    }
    
    //remove device orientation notification
    
    deinit {
       NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //check device orientation and rotate ui icons
    @objc func rotated() {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            var constraints = [NSLayoutConstraint]()
            watchConnectionIcon.transform = CGAffineTransform(rotationAngle: .pi / 2)
            heartRateImage.transform = CGAffineTransform(rotationAngle: .pi / 2)
            constraints.append(heartRateImage.widthAnchor.constraint(equalTo: heartRateImage.widthAnchor, multiplier: 0.2))
            NSLayoutConstraint.activate(constraints)
//            heartRateValue.transform = CGAffineTransform(rotationAngle: .pi / 2)
            speedometerTextField.transform = CGAffineTransform(rotationAngle: .pi / 2)
            graphView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            carImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            driverActive.transform = CGAffineTransform(rotationAngle: .pi / 2)
            recordButton.transform = CGAffineTransform(rotationAngle: .pi / 2)
        
            print("Landscape left")
        } else if(UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) {
            watchConnectionIcon.transform = CGAffineTransform(rotationAngle: .pi / -2)
            heartRateImage.transform = CGAffineTransform(rotationAngle: .pi / -2)
//            heartRateValue.transform = CGAffineTransform(rotationAngle: .pi / -2)
            speedometerTextField.transform = CGAffineTransform(rotationAngle: .pi / -2)
            graphView.transform = CGAffineTransform(rotationAngle: .pi / -2)
            carImageView.frame.size.width = 100
            carImageView.transform = CGAffineTransform(rotationAngle: .pi / -2)
            driverActive.transform = CGAffineTransform(rotationAngle: .pi / -2)
            recordButton.transform = CGAffineTransform(rotationAngle: .pi / -2)
            print("Landscape right")
        }
        else  {

            watchConnectionIcon.transform = .identity
            heartRateImage.transform = .identity
            heartRateValue.transform = .identity
            speedometerTextField.transform = .identity
            graphView.transform = .identity
            carImageView.transform = .identity
            driverActive.transform = .identity
            recordButton.transform = .identity
            print("Portrait")
        }
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        amplifyVidUpload.observeDataStore()
        WatchKitConnection.shared.startWatchApp()
        userData = defaultsManager.getUserDefaults()
        
        AllData.shared.graphTimer = Timer.scheduledTimer( timeInterval: 0.1, target: self, selector: #selector(updateGraph), userInfo: nil, repeats: true)
        appDelegate.shouldRotate = false // or false to disable rotation
        
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                // Only setup observers and start the session running if setup succeeded.
                self.addObservers()
                self.session.startRunning()
                self.isSessionRunning = self.session.isRunning
                
            case .notAuthorized:
                DispatchQueue.main.async {
                    let changePrivacySetting = "\(Bundle.main.applicationName) doesn't have permission to use the camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: Bundle.main.applicationName, message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                            style: .`default`,
                                                            handler: { _ in
                                                                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                                                    UIApplication.shared.open(settingsURL,
                                                                                              options: [:],
                                                                                              completionHandler: nil)
                                                                }
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .configurationFailed:
                DispatchQueue.main.async {
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: Bundle.main.applicationName, message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .multiCamNotSupported:
                DispatchQueue.main.async {
                    let alertMessage = "Alert message when multi cam is not supported"
                    let message = NSLocalizedString("Multi Cam Not Supported", comment: alertMessage)
                    let alertController = UIAlertController(title: Bundle.main.applicationName, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBOutlet weak var cameraViewBounds: UIView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.shouldRotate = false
        observeLocationAccuracySettings()
    }
    
    
    // Ensure that the interface stays locked in Portrait.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // Ensure that the interface stays locked in Portrait.
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    

    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.async {
            if self.setupResult == .success {
                self.session.stopRunning()
                self.isSessionRunning = self.session.isRunning
                self.removeObservers()
            }
        }
        //stop the timer
        AllData.shared.graphTimer.invalidate()
        super.viewWillDisappear(animated)
    }
    
    @objc // Expose to Objective-C for use with #selector()
    private func didEnterBackground(notification: NSNotification) {
        // Free up resources.
        dataOutputQueue.async {
            self.renderingEnabled = false
            self.videoMixer.reset()
            self.currentPiPSampleBuffer = nil
        }
    }
    
    @objc // Expose to Objective-C for use with #selector()
    func willEnterForground(notification: NSNotification) {
        dataOutputQueue.async {
            self.renderingEnabled = true
        }
    }
    
   
    
    // MARK: KVO and Notifications
    
    private var sessionRunningContext = 0
    
    private var keyValueObservations = [NSKeyValueObservation]()
    
    private func addObservers() {
        let keyValueObservation = session.observe(\.isRunning, options: .new) { _, change in
            guard let isSessionRunning = change.newValue else { return }
            
            DispatchQueue.main.async {
                self.recordButton.isEnabled = isSessionRunning
            }
        }
        keyValueObservations.append(keyValueObservation)
        
        let systemPressureStateObservation = observe(\.self.backCameraDeviceInput?.device.systemPressureState, options: .new) { _, change in
            guard let systemPressureState = change.newValue as? AVCaptureDevice.SystemPressureState else { return }
            self.setRecommendedFrameRateRangeForPressureState(systemPressureState)
        }
        keyValueObservations.append(systemPressureStateObservation)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionRuntimeError),
                                               name: .AVCaptureSessionRuntimeError,
                                               object: session)
        
        // A session can run only when the app is full screen. It will be interrupted in a multi-app layout.
        // Add observers to handle these session interruptions and inform the user.
        // See AVCaptureSessionWasInterruptedNotification for other interruption reasons.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionWasInterrupted),
                                               name: .AVCaptureSessionWasInterrupted,
                                               object: session)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionInterruptionEnded),
                                               name: .AVCaptureSessionInterruptionEnded,
                                               object: session)
    }
    
    private func removeObservers() {
        for keyValueObservation in keyValueObservations {
            keyValueObservation.invalidate()
        }
        
        keyValueObservations.removeAll()
    }
    
    
    // MARK: Video Preview PiP Management
    
    private var pipDevicePosition: AVCaptureDevice.Position = .front
    
    private var normalizedPipFrame = CGRect.zero
    
    @IBOutlet private var frontCameraPiPConstraints: [NSLayoutConstraint]!
    
    @IBOutlet private var backCameraPiPConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var driverActive: UILabel!
    
//    @objc // Expose to Objective-C for use with #selector()
//    private func togglePiP() {
//        // Disable animations so the views move immediately
//        CATransaction.begin()
//        UIView.setAnimationsEnabled(false)
//        CATransaction.setDisableActions(true)
//
//        if pipDevicePosition == .front {
////            NSLayoutConstraint.deactivate(frontCameraPiPConstraints)
////            NSLayoutConstraint.activate(backCameraPiPConstraints)
//            view.sendSubviewToBack(frontCameraVideoPreviewView)
//            pipDevicePosition = .back
//        } else {
////            NSLayoutConstraint.deactivate(backCameraPiPConstraints)
////            NSLayoutConstraint.activate(frontCameraPiPConstraints)
//            view.sendSubviewToBack(backCameraVideoPreviewView)
//            pipDevicePosition = .front
//        }
//
//        CATransaction.commit()
//        UIView.setAnimationsEnabled(true)
//        CATransaction.setDisableActions(false)
//    }
    @objc func exitBlurred(){
        blurredUiView.isHidden = true
    }
    
//    private func updateNormalizedPiPFrame() {
//        let fullScreenVideoPreviewView: PreviewView
//        let pipVideoPreviewView: PreviewView
//
//
//        if pipDevicePosition == .back {
//            fullScreenVideoPreviewView = frontCameraVideoPreviewView
//            pipVideoPreviewView = backCameraVideoPreviewView
//        } else if pipDevicePosition == .front {
//            fullScreenVideoPreviewView = backCameraVideoPreviewView
//            pipVideoPreviewView = frontCameraVideoPreviewView
//        } else {
//            fatalError("Unexpected pip device position: \(pipDevicePosition)")
//        }
//
//
//        let pipFrameInFullScreenVideoPreview = pipVideoPreviewView.convert(pipVideoPreviewView.bounds, to: fullScreenVideoPreviewView)
//        let normalizedTransform = CGAffineTransform(scaleX: 1.0 / fullScreenVideoPreviewView.frame.width, y: 1.0 / fullScreenVideoPreviewView.frame.height)
//        normalizedPipFrame = pipFrameInFullScreenVideoPreview.applying(normalizedTransform)
//    }
    
    // MARK: Capture Session Management
    
    
    
    @IBOutlet private var resumeButton: UIButton!
    
    @IBOutlet private var cameraUnavailableLabel: UILabel!
    
    
    @IBOutlet weak var blurredUiView: UIVisualEffectView!
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
        case multiCamNotSupported
    }
    
    private let session = AVCaptureMultiCamSession()
    
    private var isSessionRunning = false
    
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], target: nil) // Communicate with the session and other session objects on this queue.
    
    private let dataOutputQueue = DispatchQueue(label: "data output queue")
    
    private var setupResult: SessionSetupResult = .success
    
    @objc dynamic private(set) var backCameraDeviceInput: AVCaptureDeviceInput?
    
    private let backCameraVideoDataOutput = AVCaptureVideoDataOutput()
    
    //    @IBOutlet private var backCameraVideoPreviewView: PreviewView!
    // @IBOutlet weak var backCameraVideoPreviewView: PreviewView!
    
   
    @IBOutlet weak var backCameraVideoPreviewView: PreviewView!
    
    
    private weak var backCameraVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var frontCameraDeviceInput: AVCaptureDeviceInput?
    
    private let frontCameraVideoDataOutput = AVCaptureVideoDataOutput()
    
    // @IBOutlet weak var frontCameraVideoPreviewView: PreviewView!
    //    @IBOutlet private var frontCameraVideoPreviewView: PreviewView!
    
//    @IBOutlet weak var frontCameraVideoPreviewView: PreviewView!
    @IBOutlet weak var frontCameraVideoPreviewView: FaceView!
    
    private weak var frontCameraVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var microphoneDeviceInput: AVCaptureDeviceInput?
    
    private let backMicrophoneAudioDataOutput = AVCaptureAudioDataOutput()
    
    private let frontMicrophoneAudioDataOutput = AVCaptureAudioDataOutput()
    
    // Must be called on the session queue
    private func configureSession() {
        guard setupResult == .success else { return }
        
        guard AVCaptureMultiCamSession.isMultiCamSupported else {
            print("MultiCam not supported on this device")
            setupResult = .multiCamNotSupported
            return
        }
        
        // When using AVCaptureMultiCamSession, it is best to manually add connections from AVCaptureInputs to AVCaptureOutputs
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
            if setupResult == .success {
                checkSystemCost()
            }
        }

        guard configureBackCamera() else {
            setupResult = .configurationFailed
            return
        }
        
        guard configureFrontCamera() else {
            setupResult = .configurationFailed
            return
        }
        
        guard configureMicrophone() else {
            setupResult = .configurationFailed
            return
        }
    }
    
    private func configureBackCamera() -> Bool {
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        // Find the back camera
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Could not find the back camera")
            return false
        }
        
        // Add the back camera input to the session
        do {
            backCameraDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            
            guard let backCameraDeviceInput = backCameraDeviceInput,
                session.canAddInput(backCameraDeviceInput) else {
                    print("Could not add back camera device input")
                    return false
            }
            session.addInputWithNoConnections(backCameraDeviceInput)
        } catch {
            print("Could not create back camera device input: \(error)")
            return false
        }
        
        // Find the back camera device input's video port
        guard let backCameraDeviceInput = backCameraDeviceInput,
            let backCameraVideoPort = backCameraDeviceInput.ports(for: .video,
                                                              sourceDeviceType: backCamera.deviceType,
                                                              sourceDevicePosition: backCamera.position).first else {
                                                                print("Could not find the back camera device input's video port")
                                                                return false
        }
        
        
        
        // Add the back camera video data output
        guard session.canAddOutput(backCameraVideoDataOutput) else {
            print("Could not add the back camera video data output")
            return false
        }
        session.addOutputWithNoConnections(backCameraVideoDataOutput)
        backCameraVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        backCameraVideoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        
        // Connect the back camera device input to the back camera video data output
        let backCameraVideoDataOutputConnection = AVCaptureConnection(inputPorts: [backCameraVideoPort], output: backCameraVideoDataOutput)
        guard session.canAddConnection(backCameraVideoDataOutputConnection) else {
            print("Could not add a connection to the back camera video data output")
            return false
        }
        session.addConnection(backCameraVideoDataOutputConnection)
        backCameraVideoDataOutputConnection.videoOrientation = .portrait

        // Connect the back camera device input to the back camera video preview layer
        guard let backCameraVideoPreviewLayer = backCameraVideoPreviewLayer else {
            return false
        }
        let backCameraVideoPreviewLayerConnection = AVCaptureConnection(inputPort: backCameraVideoPort, videoPreviewLayer: backCameraVideoPreviewLayer)
        guard session.canAddConnection(backCameraVideoPreviewLayerConnection) else {
            print("Could not add a connection to the back camera video preview layer")
            return false
        }
        session.addConnection(backCameraVideoPreviewLayerConnection)
        
        return true
    }
    
    private func configureFrontCamera() -> Bool {
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        // Find the front camera
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Could not find the front camera")
            return false
        }
        
        // Add the front camera input to the session
        do {
            frontCameraDeviceInput = try AVCaptureDeviceInput(device: frontCamera)
            
            guard let frontCameraDeviceInput = frontCameraDeviceInput,
                session.canAddInput(frontCameraDeviceInput) else {
                    print("Could not add front camera device input")
                    return false
            }
            session.addInputWithNoConnections(frontCameraDeviceInput)
        } catch {
            print("Could not create front camera device input: \(error)")
            return false
        }
        
        // Find the front camera device input's video port
        guard let frontCameraDeviceInput = frontCameraDeviceInput,
            let frontCameraVideoPort = frontCameraDeviceInput.ports(for: .video,
                                                                    sourceDeviceType: frontCamera.deviceType,
                                                                    sourceDevicePosition: frontCamera.position).first else {
                                                                        print("Could not find the front camera device input's video port")
                                                                        return false
        }
        
        // Add the front camera video data output
        guard session.canAddOutput(frontCameraVideoDataOutput) else {
            print("Could not add the front camera video data output")
            return false
        }
        session.addOutputWithNoConnections(frontCameraVideoDataOutput)
        frontCameraVideoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        frontCameraVideoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        
        // Connect the front camera device input to the front camera video data output
        let frontCameraVideoDataOutputConnection = AVCaptureConnection(inputPorts: [frontCameraVideoPort], output: frontCameraVideoDataOutput)
        guard session.canAddConnection(frontCameraVideoDataOutputConnection) else {
            print("Could not add a connection to the front camera video data output")
            return false
        }
        session.addConnection(frontCameraVideoDataOutputConnection)
        frontCameraVideoDataOutputConnection.videoOrientation = .portrait
        frontCameraVideoDataOutputConnection.automaticallyAdjustsVideoMirroring = false
        frontCameraVideoDataOutputConnection.isVideoMirrored = true

        // Connect the front camera device input to the front camera video preview layer
        guard let frontCameraVideoPreviewLayer = frontCameraVideoPreviewLayer else {
            return false
        }
        let frontCameraVideoPreviewLayerConnection = AVCaptureConnection(inputPort: frontCameraVideoPort, videoPreviewLayer: frontCameraVideoPreviewLayer)
        guard session.canAddConnection(frontCameraVideoPreviewLayerConnection) else {
            print("Could not add a connection to the front camera video preview layer")
            return false
        }
        session.addConnection(frontCameraVideoPreviewLayerConnection)
        frontCameraVideoPreviewLayerConnection.automaticallyAdjustsVideoMirroring = false
        frontCameraVideoPreviewLayerConnection.isVideoMirrored = true
        
        return true
    }
    
    private func configureMicrophone() -> Bool {
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        // Find the microphone
        guard let microphone = AVCaptureDevice.default(for: .audio) else {
            print("Could not find the microphone")
            return false
        }
        
        // Add the microphone input to the session
        do {
            microphoneDeviceInput = try AVCaptureDeviceInput(device: microphone)
            
            guard let microphoneDeviceInput = microphoneDeviceInput,
                session.canAddInput(microphoneDeviceInput) else {
                    print("Could not add microphone device input")
                    return false
            }
            session.addInputWithNoConnections(microphoneDeviceInput)
        } catch {
            print("Could not create microphone input: \(error)")
            return false
        }
        
        // Find the audio device input's back audio port
        guard let microphoneDeviceInput = microphoneDeviceInput,
            let backMicrophonePort = microphoneDeviceInput.ports(for: .audio,
                                                                 sourceDeviceType: microphone.deviceType,
                                                                 sourceDevicePosition: .back).first else {
                                                                    print("Could not find the back camera device input's audio port")
                                                                    return false
        }
        
        // Find the audio device input's front audio port
        guard let frontMicrophonePort = microphoneDeviceInput.ports(for: .audio,
                                                                    sourceDeviceType: microphone.deviceType,
                                                                    sourceDevicePosition: .front).first else {
            print("Could not find the front camera device input's audio port")
            return false
        }
        
        // Add the back microphone audio data output
        guard session.canAddOutput(backMicrophoneAudioDataOutput) else {
            print("Could not add the back microphone audio data output")
            return false
        }
        session.addOutputWithNoConnections(backMicrophoneAudioDataOutput)
        backMicrophoneAudioDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        
        // Add the front microphone audio data output
        guard session.canAddOutput(frontMicrophoneAudioDataOutput) else {
            print("Could not add the front microphone audio data output")
            return false
        }
        session.addOutputWithNoConnections(frontMicrophoneAudioDataOutput)
        frontMicrophoneAudioDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        
        // Connect the back microphone to the back audio data output
        let backMicrophoneAudioDataOutputConnection = AVCaptureConnection(inputPorts: [backMicrophonePort], output: backMicrophoneAudioDataOutput)
        guard session.canAddConnection(backMicrophoneAudioDataOutputConnection) else {
            print("Could not add a connection to the back microphone audio data output")
            return false
        }
        session.addConnection(backMicrophoneAudioDataOutputConnection)
        
        // Connect the front microphone to the back audio data output
        let frontMicrophoneAudioDataOutputConnection = AVCaptureConnection(inputPorts: [frontMicrophonePort], output: frontMicrophoneAudioDataOutput)
        guard session.canAddConnection(frontMicrophoneAudioDataOutputConnection) else {
            print("Could not add a connection to the front microphone audio data output")
            return false
        }
        session.addConnection(frontMicrophoneAudioDataOutputConnection)
        
        return true
    }
    
    @objc // Expose to Objective-C for use with #selector()
    private func sessionWasInterrupted(notification: NSNotification) {
        // In iOS 9 and later, the userInfo dictionary contains information on why the session was interrupted.
        if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject?,
            let reasonIntegerValue = userInfoValue.integerValue,
            let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntegerValue) {
            print("Capture session was interrupted (\(reason))")
            
            if reason == .videoDeviceInUseByAnotherClient {
                // Simply fade-in a button to enable the user to try to resume the session running.
                resumeButton.isHidden = false
                resumeButton.alpha = 0.0
                UIView.animate(withDuration: 0.25) {
                    self.resumeButton.alpha = 1.0
                }
            } else if reason == .videoDeviceNotAvailableWithMultipleForegroundApps {
                // Simply fade-in a label to inform the user that the camera is unavailable.
                cameraUnavailableLabel.isHidden = false
                cameraUnavailableLabel.alpha = 0.0
                UIView.animate(withDuration: 0.25) {
                    self.cameraUnavailableLabel.alpha = 1.0
                }
            }
        }
    }
    
    @objc // Expose to Objective-C for use with #selector()
    private func sessionInterruptionEnded(notification: NSNotification) {
        if !resumeButton.isHidden {
            UIView.animate(withDuration: 0.25,
                           animations: {
                            self.resumeButton.alpha = 0
            }, completion: { _ in
                self.resumeButton.isHidden = true
            })
        }
        if !cameraUnavailableLabel.isHidden {
            UIView.animate(withDuration: 0.25,
                           animations: {
                            self.cameraUnavailableLabel.alpha = 0
            }, completion: { _ in
                self.cameraUnavailableLabel.isHidden = true
            })
        }
    }
    
    @objc // Expose to Objective-C for use with #selector()
    private func sessionRuntimeError(notification: NSNotification) {
        guard let errorValue = notification.userInfo?[AVCaptureSessionErrorKey] as? NSError else {
            return
        }
        
        let error = AVError(_nsError: errorValue)
        print("Capture session runtime error: \(error)")
        
        /*
        Automatically try to restart the session running if media services were
        reset and the last start running succeeded. Otherwise, enable the user
        to try to resume the session running.
        */
        if error.code == .mediaServicesWereReset {
            sessionQueue.async {
                if self.isSessionRunning {
                    self.session.startRunning()
                    self.isSessionRunning = self.session.isRunning
                } else {
                    DispatchQueue.main.async {
                        self.resumeButton.isHidden = false
                    }
                }
            }
        } else {
            resumeButton.isHidden = false
        }
    }
    
    @IBAction private func resumeInterruptedSession(_ sender: UIButton) {
        sessionQueue.async {
            /*
            The session might fail to start running. A failure to start the session running will be communicated via
            a session runtime error notification. To avoid repeatedly failing to start the session
            running, we only try to restart the session running in the session runtime error handler
            if we aren't trying to resume the session running.
            */
            self.session.startRunning()
            self.isSessionRunning = self.session.isRunning
            if !self.session.isRunning {
                DispatchQueue.main.async {
                    let message = NSLocalizedString("Unable to resume", comment: "Alert message when unable to resume the session running")
                    let actions = [
                        UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                      style: .cancel,
                                      handler: nil)]
                    self.alert(title: Bundle.main.applicationName, message: message, actions: actions)
                }
            } else {
                DispatchQueue.main.async {
                    self.resumeButton.isHidden = true
                }
            }
        }
    }
    
    func alert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        actions.forEach {
            alertController.addAction($0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Recording Movies
    
    private var movieRecorder: MovieRecorder?
    private var movieRecorderpip: MovieRecorder?
   
    private var frontMovieRecorder: MovieRecorder?

    private var backMovieRecorder: MovieRecorder?
    
    
    private var currentPiPSampleBuffer: CMSampleBuffer?
    
    private var backgroundRecordingID: UIBackgroundTaskIdentifier?
    
    @IBOutlet private var recordButton: UIButton!
    @IBOutlet weak var obdConnectButtonLabel: UIButton!
    
    private var renderingEnabled = true
    
    private var videoMixer = PiPVideoMixer()
    
    private var videoTrackSourceFormatDescription: CMFormatDescription?
    func tempURL() -> URL? {
        //create the directory
        let directory = NSTemporaryDirectory() as NSString
        //set the path
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        //return nil if we encounter an error
        return nil
    }
    
    private func updateRecordButtonWithRecordingState(_ isRecording: Bool) {
        let color = isRecording ? UIColor.red : UIColor.yellow
        let title = isRecording ? "Stop" : "Record"

        recordButton.tintColor = color
        recordButton.setTitleColor(color, for: .normal)
        recordButton.setTitle(title, for: .normal)
    }

    private func upateOBDSensorButoon(_ isConnected:Bool){
        let color = isConnected ? UIColor.red : UIColor.yellow
        let title = isConnected ? "Stop" : "Record"
        
        obdConnectButtonLabel.tintColor = color
        obdConnectButtonLabel.setTitleColor(color, for: .normal)
        obdConnectButtonLabel.setTitle(title, for: .normal)

    }
    
    
   @objc @IBAction private func toggleMovieRecording(_ recordButton: UIButton) {
        recordButton.isEnabled = false
       
        dataOutputQueue.async { [self] in
            defer {
                DispatchQueue.main.async {
                    recordButton.isEnabled = true
                    
                    if let recorder = self.movieRecorder {
                        self.updateRecordButtonWithRecordingState(recorder.isRecording)
                    }
                }
            }
            
            let isRecording = self.movieRecorder?.isRecording ?? false
            if !isRecording {
                if UIDevice.current.isMultitaskingSupported {
                    self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                }
                
                guard let audioSettings = self.createAudioSettings() else {
                    print("Could not create audio settings")
                    return
                }
                
                guard let videoSettings = self.createVideoSettings() else {
                    print("Could not create video settings")
                    return
                }
                
                guard let videoTransform = self.createVideoTransform() else {
                    print("Could not create video transform")
                    return
                }
                
                //set the workout to start on watch when recording has started
                workoutContorl = "start"
                WatchKitConnection.shared.sendMessage(message: ["username" : workoutContorl as AnyObject])
                
                self.movieRecorder = MovieRecorder(audioSettings: audioSettings,
                                                   videoSettings: videoSettings,
                                                   videoTransform: videoTransform)
                self.movieRecorderpip = MovieRecorder(audioSettings: audioSettings,
                                                   videoSettings: videoSettings,
                                                   videoTransform: videoTransform)

                
                self.movieRecorder?.startRecording()
                self.movieRecorderpip?.startRecording()
                
                //create the name for the data
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy_MMM_dd_HH_mm_ss"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
                //set the name for the data
                AllData.shared.name = dateString
                //sets the is recording variable
                
                AllData.shared.isRecording = true
                //start the timer to log the data
                DispatchQueue.main.async { [self] in
                    AllData.shared.recordAwsTimer = Timer.scheduledTimer(timeInterval: AllData.shared.sensorFrequency, target: self, selector: #selector(awsSensordat), userInfo: nil, repeats: true)
                    AllData.shared.saveDataTimer = Timer.scheduledTimer(timeInterval: userData.autoSaveTime + 2, target: self, selector: #selector(saveRecordedData), userInfo: nil, repeats: true)
                }
               
                DispatchQueue.main.async { [self] in
                    blurredUiView.isHidden = false
                    self.performQuery()
                    let togglePiPDoubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exitBlurred))
                    togglePiPDoubleTapGestureRecognizer.numberOfTapsRequired = 2
                    blurredUiView.addGestureRecognizer(togglePiPDoubleTapGestureRecognizer)
//                    didFinishedActiveSession()
                }
                
                
                //fetch vehicle info using the VIN
                DispatchQueue.main.async { [self] in
                    if let vinNumber = instanceOfCustomObject.vinLabel{
                        print(vinNumber)
                        vehicleInfoManager.fecthVehicleInformation(vinNumber: vinNumber as! String)
                    }
                }
                
            } else {
                
                AllData.shared.saveDataTimer.invalidate()
                AllData.shared.recordAwsTimer.invalidate()
                recordTimerObd.invalidate()
                DispatchQueue.main.async { [self] in
                    if let vinNumber = instanceOfCustomObject.vinLabel{
                        print(vinNumber)
                        vehicleInfoManager.fecthVehicleInformation(vinNumber: vinNumber as! String)
                    }
                }
                
                //set the workout to stop on watch when recording has stopped
                workoutContorl = "stop"
                WatchKitConnection.shared.sendMessage(message: ["username" : workoutContorl as AnyObject])
                
                //invalidate the timer when recording stops
                
            
                //initialize new data object
                existingPost = DateStored()
               
                //convert sensor data to csv and save
                csvParser.createCsv(recordedDataDictionary, "sensorData\(AllData.shared.name).csv"){ sensorUrl in
                    existingPost.dateStored = AllData.shared.name
                    existingPost.createdAt = Temporal.DateTime(Date())
                    existingPost.sensorDataURL = String(describing: sensorUrl.lastPathComponent)
                    amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                    sensorDataState = .sensorData
                    //upload senor data automatically to cloud if automatic upload is selected
                    
                    if userData.automaticUpload == true{
                        uploadSensordataAWS(sensor: sensorUrl)
                        AllData.shared.dateStoredId = existingPost.id
                    }
                }
                
                // convert health data to csv
                csvParser.createCsv(firstdat, "initialHealth\(AllData.shared.name).csv"){ sensorUrl in
                    existingPost.initiaLHealthData = String(describing: sensorUrl.lastPathComponent)
                    amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                    sensorDataState = .initialHealthData
                    if userData.automaticUpload == true{
                        uploadSensordataAWS(sensor: sensorUrl)
                    }
                }
                
                // convert obd to csv
                csvParser.createCsv(obdData, "obdData\(AllData.shared.name).csv"){ sensorUrl in
                    allData.initialVehicleData = String(describing: sensorUrl)
                    existingPost.initialVehicleData = String(describing: sensorUrl.lastPathComponent)
                    amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                    sensorDataState = .canBusData
                    if userData.automaticUpload == true{
                        uploadSensordataAWS(sensor: sensorUrl)
                    }
                }
                //REMOVE BLURRED SCREEN AFTER UPLOAD
                DispatchQueue.main.async {
                    blurredUiView.isHidden = true
                }
                AllData.shared.isRecording = false
                self.movieRecorder?.stopRecording { movieURL in
                    camState = .backcam
//                    convertVideo(movieURL, "RoadViewVideo", false)
                    allData.roadViewURL = String(describing: movieURL)
                    let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

                    let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent("RoadViewVideo\(AllData.shared.name).mp4")

                    localFileManager.saveVideoToDocumentsDirectory(srcURL: movieURL, dstURL: documentURL){ movieUrl in
                        
                        // clean up after copying file
                        if FileManager.default.fileExists(atPath: movieURL.path) {
                            do {
                                try FileManager.default.removeItem(atPath: movieURL.path)
                            } catch {
                                print("Could not remove file at url: \(movieURL)")
                            }
                        }
                        
                        if let currentBackgroundRecordingID = self.backgroundRecordingID {
                            self.backgroundRecordingID = UIBackgroundTaskIdentifier.invalid

                            if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
                            }
                        }
                        existingPost.roadViewURL = String(describing: movieUrl.lastPathComponent)
                        amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                        //remove file from temporary storage  after saving to documents directory
                        if userData.automaticUpload == true{
                            amplifyVidUpload.specialUpload(url: movieUrl, fileName: movieUrl.lastPathComponent, saveLocation: AllData.shared.name, contentType: "video/mp4")

                        }

                    }
                    //invalidate the data collection timer
                    AllData.shared.recordAwsTimer.invalidate()
                    
                }
                self.movieRecorderpip?.stopRecording { movieURL in
                    camState = .frontcam
                    
//                    convertVideo(movieURL, "DriverMonitorVideo", true)
                    
                    let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

                    let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent("DriverMonitorVideo\(AllData.shared.name).mp4")

                    localFileManager.saveVideoToDocumentsDirectory(srcURL: movieURL, dstURL: documentURL){ sensorUrl in
                        
                        print(sensorUrl)
                        // clean up after copying file
                        if FileManager.default.fileExists(atPath: movieURL.path) {
                            do {
                                try FileManager.default.removeItem(atPath: movieURL.path)
                            } catch {
                                print("Could not remove file at url: \(movieURL)")
                            }
                        }
                        //remove file from temporary storage  after saving to documents directory
//                        do {
//                                try FileManager.default.removeItem(at: movieURL)
//                                print("file deleted succesfully")
//                            }
//                            catch {
//                                fatalError()
//                            }
                        
                        if let currentBackgroundRecordingID = self.backgroundRecordingID {
                            self.backgroundRecordingID = UIBackgroundTaskIdentifier.invalid

                            if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
                            }
                        }
                        print(sensorUrl)
                        existingPost.driverMonitorURL = String(describing: sensorUrl.lastPathComponent)
                        amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                       
                        if userData.automaticUpload == true{
                            amplifyVidUpload.specialUpload(url: sensorUrl, fileName: sensorUrl.lastPathComponent, saveLocation: AllData.shared.name, contentType: "video/mp4")
                            DispatchQueue.main.async {
                                self.presentAlert(withTitle: "Files Upload", message: "file is uploading automatically, please navigate to upload tab to see progress", actions: ["OK" : UIAlertAction.Style.default])
                            }

                        }else{
                            DispatchQueue.main.async {
                                self.presentAlert(withTitle: "Files Saved", message: "file is saved in library Tab, please upload from there", actions: ["OK" : UIAlertAction.Style.default])
                            }
                        }
                    }
                    print("Kojo KONADU")
                    tabBarControl.changeBadge()
                    self.frntcm = String(describing: movieURL)
                }
            }
        }
}
    
    func convertVideo(_ videoURL: URL, _ filename: String, _ saveToDatestoreDriverMon: Bool){
        let avAsset = AVURLAsset(url: videoURL, options:nil)
        let outputFileType = AVFileType.mp4
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let outputURL =  URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent("\(filename)\(AllData.shared.name).mp4")
        let preset = AVAssetExportPresetHighestQuality
        AVAssetExportSession.determineCompatibility(ofExportPreset: preset, with: avAsset, outputFileType: outputFileType){ isCompatible in
            guard isCompatible else{ return }
            
            // Compatibility check succeeded, continue with export
            guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: preset) else {return}
            
            exportSession.outputFileType = outputFileType
            exportSession.outputURL = outputURL
            exportSession.exportAsynchronously { [self] in
                switch exportSession.status{
                    
                case .unknown:
                    print("video could not be exported")
                case .waiting:
                    print("print export waiting")
                case .exporting:
                    print("exporting to mp4")
                case .completed:
                    print("export completed")
                    if let currentBackgroundRecordingID = self.backgroundRecordingID {
                        self.backgroundRecordingID = UIBackgroundTaskIdentifier.invalid
                        
                        if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                            UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
                        }
                    }
                    if saveToDatestoreDriverMon == true{
                        existingPost.driverMonitorURL = String(describing: outputURL.lastPathComponent)
                    }else{
                        existingPost.roadViewURL = String(describing: outputURL.lastPathComponent)
                    }
                    
                    amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                    if userData.automaticUpload == true{
                        amplifyVidUpload.specialUpload(url: outputURL, fileName: outputURL.lastPathComponent, saveLocation: AllData.shared.name, contentType: "video/mp4")
                        DispatchQueue.main.async {
                            self.presentAlert(withTitle: "Files Upload", message: "file is uploading automatically, please navigate to upload tab to see progress", actions: ["OK" : UIAlertAction.Style.default])
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.presentAlert(withTitle: "Files Saved", message: "file is saved in library Tab, please upload from there", actions: ["OK" : UIAlertAction.Style.default])
                        }
                    }
                case .failed:
                    print("export failed")
                case .cancelled:
                    print("export cancelled")
                @unknown default:
                    print("unknown")
                }
            }
        }
    }

    
    
    
    private func createAudioSettings() -> [String: NSObject]? {
        guard let backMicrophoneAudioSettings = backMicrophoneAudioDataOutput.recommendedAudioSettingsForAssetWriter(writingTo: .mov) as? [String: NSObject] else {
            print("Could not get back microphone audio settings")
            return nil
        }
        guard let frontMicrophoneAudioSettings = frontMicrophoneAudioDataOutput.recommendedAudioSettingsForAssetWriter(writingTo: .mov) as? [String: NSObject] else {
            print("Could not get front microphone audio settings")
            return nil
        }
        
        if backMicrophoneAudioSettings == frontMicrophoneAudioSettings {
            // The front and back microphone audio settings are equal, so return either one
            return backMicrophoneAudioSettings
        } else {
            print("Front and back microphone audio settings are not equal. Check your AVCaptureAudioDataOutput configuration.")
            return nil
        }
    }
    
    private func createVideoSettings() -> [String: NSObject]? {
        guard let backCameraVideoSettings = backCameraVideoDataOutput.recommendedVideoSettings(forVideoCodecType: .h264, assetWriterOutputFileType: .mp4) as? [String: NSObject] else {
            print("Could not get back camera video settings")
            return nil
        }
        guard let frontCameraVideoSettings = backCameraVideoDataOutput.recommendedVideoSettings(forVideoCodecType: .h264, assetWriterOutputFileType: .mp4) as? [String: NSObject] else {
            print("Could not get front camera video settings")
            return nil
        }
        
//        backCameraVideoDataOutput.recommendedVideoSettings(forVideoCodecType: .h264, assetWriterOutputFileType: .mp4) as? [String: NSObject]
        
        
        if backCameraVideoSettings == frontCameraVideoSettings {
            // The front and back camera video settings are equal, so return either one
            return backCameraVideoSettings
        } else {
            print("Front and back camera video settings are not equal. Check your AVCaptureVideoDataOutput configuration.")
            return nil
        }
    }
    
    private func createVideoTransform() -> CGAffineTransform? {
        guard let backCameraVideoConnection = backCameraVideoDataOutput.connection(with: .video) else {
                print("Could not find the back and front camera video connections")
                return nil
        }
        
        let deviceOrientation = UIDevice.current.orientation
        let videoOrientation = AVCaptureVideoOrientation(deviceOrientation: deviceOrientation) ?? .portrait
        
        // Compute transforms from the back camera's video orientation to the device's orientation
        let backCameraTransform = backCameraVideoConnection.videoOrientationTransform(relativeTo: videoOrientation)

        return backCameraTransform

    }
    
    internal func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        //do anything when we start recording
        //save the url of the video to the singelton so we can access
        print("started recording")
        AllData.shared.videoURL = fileURL.lastPathComponent
    }
    
    
    
    
    private func saveMovieToPhotoLibrary(_ movieURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                // Save the movie file to the photo library and clean up.
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .video, fileURL: movieURL, options: options)
                    
//                    DispatchQueue.main.async {
//                        let videoRecorded = movieURL as URL
//                        localFileManager.saveVideoToDocumentsDirectory(srcURL: videoRecorded, dstURL: (localFileManager.pathForDocumentDirectoryAsUrl()?.appendingPathComponent("DI", isDirectory: true).appendingPathComponent(movieURL.lastPathComponent))!)
//                        //if the user is actually uploading the files now over cellular and not later
//                        let nameString = videoRecorded.lastPathComponent
//                        //generate the name of the file based on date
//                        let name = "\(Int(Date().timeIntervalSince1970))"
//                        //saves the video to firebase
//                        //create the progress view
//                        let progressView = UIProgressView()
//                        //save the video to firebase and pass the data
//                        firebaseManager.saveVideo(url: videoRecorded, videoName: nameString, saveLocation: AllData.shared.name, progressView: progressView)
//                    }
                    
                }, completionHandler: { success, error in
                    if !success {
                        print("\(Bundle.main.applicationName) couldn't save the movie to your photo library: \(String(describing: error))")
                    } else {
                        // Clean up
                        if FileManager.default.fileExists(atPath: movieURL.path) {
                            do {
                                try FileManager.default.removeItem(atPath: movieURL.path)
                            } catch {
                                print("Could not remove file at url: \(movieURL)")
                            }
                        }
                        
                        if let currentBackgroundRecordingID = self.backgroundRecordingID {
                            self.backgroundRecordingID = UIBackgroundTaskIdentifier.invalid
                            
                            if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
                            }
                        }
                    }
                })
            } else {
                DispatchQueue.main.async {
                    let alertMessage = "Alert message when the user has not authorized photo library access"
                    let message = NSLocalizedString("\(Bundle.main.applicationName) does not have permission to access the photo library", comment: alertMessage)
                    let alertController = UIAlertController(title: Bundle.main.applicationName, message: message, preferredStyle: .alert)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let videoDataOutput = output as? AVCaptureVideoDataOutput {
            processVideoSampleBuffer(sampleBuffer, fromOutput: videoDataOutput)
            
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)else { return }
            let exifOrientation = CGImagePropertyOrientation(rawValue: exifOrientationFromDeviceOrientation())
            var requestOptions: [VNImageOption : Any] = [:]
            
            if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
                requestOptions = [.cameraIntrinsics : cameraIntrinsicData]
            }
            
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation!, options: requestOptions)
            
            do {
                try imageRequestHandler.perform(requests)
            }
                
            catch {
                print(error)
            }
            
        } else if let audioDataOutput = output as? AVCaptureAudioDataOutput {
            processsAudioSampleBuffer(sampleBuffer, fromOutput: audioDataOutput)
        }
    }
        

    private func processVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer, fromOutput videoDataOutput: AVCaptureVideoDataOutput) {
        if videoTrackSourceFormatDescription == nil {
            videoTrackSourceFormatDescription = CMSampleBufferGetFormatDescription( sampleBuffer )
        }
        
        // Determine:
        // - which camera the sample buffer came from
        // - if the sample buffer is for the PiP
        var fullScreenSampleBuffer: CMSampleBuffer?
        var pipSampleBuffer: CMSampleBuffer?
        
//        if pipDevicePosition == .back && videoDataOutput == backCameraVideoDataOutput {
//            movieRecorder?.recordVideo(sampleBuffer: sampleBuffer)
//        }
//        else if pipDevicePosition == .back && videoDataOutput == frontCameraVideoDataOutput {
//            movieRecorderpip?.recordVideo(sampleBuffer: sampleBuffer)
//        }
        if pipDevicePosition == .front && videoDataOutput == backCameraVideoDataOutput {
            movieRecorder?.recordVideo(sampleBuffer: sampleBuffer)
        }
        else if pipDevicePosition == .front && videoDataOutput == frontCameraVideoDataOutput {
            movieRecorderpip?.recordVideo(sampleBuffer: sampleBuffer)
            
        }
        
        
        if let fullScreenSampleBuffer = fullScreenSampleBuffer {
            processFullScreenSampleBuffer(fullScreenSampleBuffer)
        }
 
    }
    
    private func processFullScreenSampleBuffer(_ fullScreenSampleBuffer: CMSampleBuffer) {
        guard renderingEnabled else {
            return
        }
        
        guard let fullScreenPixelBuffer = CMSampleBufferGetImageBuffer(fullScreenSampleBuffer),
            let formatDescription = CMSampleBufferGetFormatDescription(fullScreenSampleBuffer) else {
                return
        }
        
        guard let pipSampleBuffer = currentPiPSampleBuffer,
            let pipPixelBuffer = CMSampleBufferGetImageBuffer(pipSampleBuffer) else {
                return
        }
        
        if !videoMixer.isPrepared {
            videoMixer.prepare(with: formatDescription, outputRetainedBufferCountHint: 3)
        }
        
        videoMixer.pipFrame = normalizedPipFrame
        
        
        
        // If we're recording, append this buffer to the movie
        if let recorder = movieRecorder,
            recorder.isRecording {
            guard let finalVideoSampleBuffer = createVideoSampleBufferWithPixelBuffer(fullScreenPixelBuffer,
                                                                                           presentationTime: CMSampleBufferGetPresentationTimeStamp(fullScreenSampleBuffer)) else {
                                                                                            print("Error: Unable to create sample buffer from pixelbuffer")
                                                                                            return
            }
            
            recorder.recordVideo(sampleBuffer: finalVideoSampleBuffer)
            recorder.recordVideo(sampleBuffer: pipSampleBuffer)
        }
    }
    
    private func processPiPSampleBuffer(_ pipSampleBuffer: CMSampleBuffer) {
        guard renderingEnabled else {
            return
        }
        
        currentPiPSampleBuffer = pipSampleBuffer
        guard renderingEnabled else {
            return
        }
    }
    
    private func processsAudioSampleBuffer(_ sampleBuffer: CMSampleBuffer, fromOutput audioDataOutput: AVCaptureAudioDataOutput) {
        
        guard (pipDevicePosition == .back && audioDataOutput == backMicrophoneAudioDataOutput) ||
            (pipDevicePosition == .front && audioDataOutput == frontMicrophoneAudioDataOutput) else {
                // Ignoring audio sample buffer
                return
        }
        
        // If we're recording, append this buffer to the movie
        if let recorder = movieRecorder,
            recorder.isRecording {
            recorder.recordAudio(sampleBuffer: sampleBuffer)
        }
    }
    
    private func createVideoSampleBufferWithPixelBuffer(_ pixelBuffer: CVPixelBuffer, presentationTime: CMTime) -> CMSampleBuffer? {
        guard let videoTrackSourceFormatDescription = videoTrackSourceFormatDescription else {
            return nil
        }
        
        var sampleBuffer: CMSampleBuffer?
        var timingInfo = CMSampleTimingInfo(duration: .invalid, presentationTimeStamp: presentationTime, decodeTimeStamp: .invalid)
        
        let err = CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                     imageBuffer: pixelBuffer,
                                                     dataReady: true,
                                                     makeDataReadyCallback: nil,
                                                     refcon: nil,
                                                     formatDescription: videoTrackSourceFormatDescription,
                                                     sampleTiming: &timingInfo,
                                                     sampleBufferOut: &sampleBuffer)
        if sampleBuffer == nil {
            print("Error: Sample buffer creation failed (error code: \(err))")
        }
        
        return sampleBuffer
    }
    
    // MARK: - Session Cost Check
    
    struct ExceededCaptureSessionCosts: OptionSet {
        let rawValue: Int
        
        static let systemPressureCost = ExceededCaptureSessionCosts(rawValue: 1 << 0)
        static let hardwareCost = ExceededCaptureSessionCosts(rawValue: 1 << 1)
    }
    
    func checkSystemCost() {
        var exceededSessionCosts: ExceededCaptureSessionCosts = []
        
        if session.systemPressureCost > 1.0 {
            exceededSessionCosts.insert(.systemPressureCost)
        }
        
        if session.hardwareCost > 1.0 {
            exceededSessionCosts.insert(.hardwareCost)
        }
        
        switch exceededSessionCosts {
            
        case .systemPressureCost:
            // Choice #1: Reduce front camera resolution
            if reduceResolutionForCamera(.front) {
                checkSystemCost()
            }
                
            // Choice 2: Reduce the number of video input ports
            else if reduceVideoInputPorts() {
                checkSystemCost()
            }
                
            // Choice #3: Reduce back camera resolution
            else if reduceResolutionForCamera(.back) {
                checkSystemCost()
            }
                
            // Choice #4: Reduce front camera frame rate
            else if reduceFrameRateForCamera(.front) {
                checkSystemCost()
            }
                
            // Choice #5: Reduce frame rate of back camera
            else if reduceFrameRateForCamera(.back) {
                checkSystemCost()
            } else {
                print("Unable to further reduce session cost.")
            }
            
        case .hardwareCost:
            // Choice #1: Reduce front camera resolution
            if reduceResolutionForCamera(.front) {
                checkSystemCost()
            }
                
            // Choice 2: Reduce back camera resolution
            else if reduceResolutionForCamera(.back) {
                checkSystemCost()
            }
                
            // Choice #3: Reduce front camera frame rate
            else if reduceFrameRateForCamera(.front) {
                checkSystemCost()
            }
                
            // Choice #4: Reduce back camera frame rate
            else if reduceFrameRateForCamera(.back) {
                checkSystemCost()
            } else {
                print("Unable to further reduce session cost.")
            }
            
        case [.systemPressureCost, .hardwareCost]:
            // Choice #1: Reduce front camera resolution
            if reduceResolutionForCamera(.front) {
                checkSystemCost()
            }
                
            // Choice #2: Reduce back camera resolution
            else if reduceResolutionForCamera(.back) {
                checkSystemCost()
            }
                
            // Choice #3: Reduce front camera frame rate
            else if reduceFrameRateForCamera(.front) {
                checkSystemCost()
            }
                
            // Choice #4: Reduce back camera frame rate
            else if reduceFrameRateForCamera(.back) {
                checkSystemCost()
            } else {
                print("Unable to further reduce session cost.")
            }
            
        default:
            break
        }
    }
    
    func reduceResolutionForCamera(_ position: AVCaptureDevice.Position) -> Bool {
        for connection in session.connections {
            for inputPort in connection.inputPorts {
                if inputPort.mediaType == .video && inputPort.sourceDevicePosition == position {
                    guard let videoDeviceInput: AVCaptureDeviceInput = inputPort.input as? AVCaptureDeviceInput else {
                        return false
                    }
                    
                    var dims: CMVideoDimensions
                    
                    var width: Int32
                    var height: Int32
                    var activeWidth: Int32
                    var activeHeight: Int32
                    
                    dims = CMVideoFormatDescriptionGetDimensions(videoDeviceInput.device.activeFormat.formatDescription)
                    activeWidth = dims.width
                    activeHeight = dims.height
                    
                    if ( activeHeight <= 480 ) && ( activeWidth <= 640 ) {
                        return false
                    }
                    
                    let formats = videoDeviceInput.device.formats
                    if let formatIndex = formats.firstIndex(of: videoDeviceInput.device.activeFormat) {
                        
                        for index in (0..<formatIndex).reversed() {
                            let format = videoDeviceInput.device.formats[index]
                            if format.isMultiCamSupported {
                                dims = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
                                width = dims.width
                                height = dims.height
                                
                                if width < activeWidth || height < activeHeight {
                                    do {
                                        try videoDeviceInput.device.lockForConfiguration()
                                        videoDeviceInput.device.activeFormat = format
                                        
                                        videoDeviceInput.device.unlockForConfiguration()
                                        
                                        print("reduced width = \(width), reduced height = \(height)")
                                        
                                        return true
                                    } catch {
                                        print("Could not lock device for configuration: \(error)")
                                        
                                        return false
                                    }
                                    
                                } else {
                                    continue
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return false
    }
    
    func reduceFrameRateForCamera(_ position: AVCaptureDevice.Position) -> Bool {
        for connection in session.connections {
            for inputPort in connection.inputPorts {
                
                if inputPort.mediaType == .video && inputPort.sourceDevicePosition == position {
                    guard let videoDeviceInput: AVCaptureDeviceInput = inputPort.input as? AVCaptureDeviceInput else {
                        return false
                    }
                    let activeMinFrameDuration = videoDeviceInput.device.activeVideoMinFrameDuration
                    var activeMaxFrameRate: Double = Double(activeMinFrameDuration.timescale) / Double(activeMinFrameDuration.value)
                    activeMaxFrameRate -= 10.0
                    
                    // Cap the device frame rate to this new max, never allowing it to go below 15 fps
                    if activeMaxFrameRate >= 15.0 {
                        do {
                            try videoDeviceInput.device.lockForConfiguration()
                            videoDeviceInput.videoMinFrameDurationOverride = CMTimeMake(value: 1, timescale: Int32(activeMaxFrameRate))
                            
                            videoDeviceInput.device.unlockForConfiguration()
                            
                            print("reduced fps = \(activeMaxFrameRate)")
                            
                            return true
                        } catch {
                            print("Could not lock device for configuration: \(error)")
                            return false
                        }
                    } else {
                        return false
                    }
                }
            }
        }
        
        return false
    }
    
    func reduceVideoInputPorts () -> Bool {
        var newConnection: AVCaptureConnection
        var result = false
        
        for connection in session.connections {
            for inputPort in connection.inputPorts where inputPort.sourceDeviceType == .builtInDualCamera {
                print("Changing input from dual to single camera")
                
                guard let videoDeviceInput: AVCaptureDeviceInput = inputPort.input as? AVCaptureDeviceInput,
                    let wideCameraPort: AVCaptureInput.Port = videoDeviceInput.ports(for: .video,
                                                                                     sourceDeviceType: .builtInWideAngleCamera,
                                                                                     sourceDevicePosition: videoDeviceInput.device.position).first else {
                                                                                        return false
                }
                
                if let previewLayer = connection.videoPreviewLayer {
                    newConnection = AVCaptureConnection(inputPort: wideCameraPort, videoPreviewLayer: previewLayer)
                } else if let savedOutput = connection.output {
                    newConnection = AVCaptureConnection(inputPorts: [wideCameraPort], output: savedOutput)
                } else {
                    continue
                }
                session.beginConfiguration()
                
                session.removeConnection(connection)
                
                if session.canAddConnection(newConnection) {
                    session.addConnection(newConnection)
                    
                    session.commitConfiguration()
                    result = true
                } else {
                    print("Could not add new connection to the session")
                    session.commitConfiguration()
                    return false
                }
            }
        }
        return result
    }
    
    func getMaxFrameRateValue()->Double{
        //try to access the back camera
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                //tell the user we could accesses the camera and return
                print("Unable to access back camera!")
                return 0
        }
        //try to set the camera up and call the live preview
        do {
            //sets the input
            let input = try AVCaptureDeviceInput(device: backCamera)
            //checks to make sure the session can get access to teh camera
            //returns the supported fps ranges for the device
            print(self.backCameraDeviceInput?.device.activeVideoMaxFrameDuration as Any)
            return backCamera.activeFormat.videoSupportedFrameRateRanges[0].maxFrameRate
        }
            //checks for errors in the camera
        catch let error  {
            //prints an error if one occurs
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        return backCamera.activeFormat.videoSupportedFrameRateRanges[0].maxFrameRate
    }
    
    private func setRecommendedFrameRateRangeForPressureState(_ systemPressureState: AVCaptureDevice.SystemPressureState) {
        // The frame rates used here are for demonstrative purposes only for this app.
        // Your frame rate throttling may be different depending on your app's camera configuration.
        let pressureLevel = systemPressureState.level
        if pressureLevel == .serious || pressureLevel == .critical {
            if self.movieRecorder == nil || self.movieRecorder?.isRecording == false {
                do {
                    try self.backCameraDeviceInput?.device.lockForConfiguration()
                    
                    print("WARNING: Reached elevated system pressure level: \(pressureLevel). Throttling frame rate.")
                    
                    self.backCameraDeviceInput?.device.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 20 )
//                    print(self.backCameraDeviceInput?.device.activeVideoMinFrameDuration as Any)
                    self.backCameraDeviceInput?.device.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: 15 )
                    
                    self.backCameraDeviceInput?.device.unlockForConfiguration()
                } catch {
                    print("Could not lock device for configuration: \(error)")
                }
            }
        } else if pressureLevel == .shutdown {
            print("Session stopped running due to system pressure level.")
        }
    }
    
    func setFrameRate(frameRate : Double){
        //try to access the back camera
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                //tell the user we could accesses the camera and return
                print("Unable to access back camera!")
                return
        }
            //sets the input
//            let input = try AVCaptureDeviceInput(device: backCamera)
            //checks to make sure the session can get access to teh camera
            if self.movieRecorder == nil || self.movieRecorder?.isRecording == false {
                do {
                    try self.backCameraDeviceInput?.device.lockForConfiguration()
                    
                    self.backCameraDeviceInput?.device.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate) )
//                    try self.backCameraDeviceInput?.device.lockForConfiguration()
//                    self.backCameraDeviceInput?.device.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate) )
//                    print(self.backCameraDeviceInput?.device.activeVideoMinFrameDuration as Any)
//                    self.backCameraDeviceInput?.device.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate) )
                    self.backCameraDeviceInput?.device.unlockForConfiguration()
                } catch {
                    print("Could not lock device for configuration: \(error)")
                }
            }
            print(backCamera.activeFormat.videoSupportedFrameRateRanges)

    
       
       
    }
    

    
    
    
    
    
    func performQuery() {
        // Create a query for each data type.
        for (_, item) in data.enumerated() {
            // Set dates
            let now = Date()
            let startDate = getLastWeekStartDate()
            let endDate = now
            
            let predicate = createLastWeekPredicate()
            let dateInterval = DateComponents(day: 1)
            
            firstdat.updateValue([Date().timeIntervalSince1970 as Any] as [Any], forKey: "unixTimeStamp")
            firstdat.updateValue([AllData.shared.motionManager.deviceMotion?.timestamp as Any] as [Any], forKey: "timeStamp")
            // Process data.
            let statisticsOptions = getStatisticsOptions(for: item.dataTypeIdentifier)
            let initialResultsHandler: (HKStatisticsCollection) -> Void = { (statisticsCollection) in
                var values: [Double] = []
                var dateCollected: [Date] = []
                
                
                
                
                statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                    let statisticsQuantity = getStatisticsQuantity(for: statistics, with: statisticsOptions)
                    if let unit = preferredUnit(for: item.dataTypeIdentifier),
                       let value = statisticsQuantity?.doubleValue(for: unit) {
                        values.append(value)
                        dateCollected.append(statistics.startDate)
                    }
                
                    firstdat["Date"] = dateCollected as [Date]
                    if item.dataTypeIdentifier == "HKQuantityTypeIdentifierStepCount"{
                        firstdat["StepCount"] = values as [Double]
                    }else if item.dataTypeIdentifier == "HKQuantityTypeIdentifierDistanceWalkingRunning"{
                        firstdat["DistanceWalkingRunning"] = values as [Double]
                    }else if item.dataTypeIdentifier == "HKQuantityTypeIdentifierHeadphoneAudioExposure"{
                        firstdat["HeadphoneAudioExposure"] = values as [Double]
                    }else if item.dataTypeIdentifier == "HKQuantityTypeIdentifierHeartRate"{
                        firstdat["HeartRate"] = values as [Double]
                    }
                    
                

                    
                }
                

//                print(firstdat)
                

            }
            
//            var fbdatabase = [String:Double]()
            
            // Fetch statistics.
            healthStore.fetchStatistics(with: HKQuantityTypeIdentifier(rawValue: item.dataTypeIdentifier),
                                       predicate: predicate,
                                       options: statisticsOptions,
                                       startDate: startDate,
                                       interval: dateInterval,
                                       completion: initialResultsHandler)
        }
    }
    
    var index = 0
    
    
    func getCSTUTCTimeZone() -> (UTC : String, CST :String){
        let dtFormatter = DateFormatter()
        let dtFormatter2 = DateFormatter()
        dtFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dtFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss.SSS"
        dtFormatter2.timeZone = NSTimeZone(name: "CST") as TimeZone?
        dtFormatter2.dateFormat = "yyyy-MM-dd HH-mm-ss.SSS"
        let formattedDateTimeCST = dtFormatter2.string(from: Date())
        let formattedDateTimeUTC = dtFormatter.string(from: Date())
        
        return (formattedDateTimeUTC,formattedDateTimeCST)
    }
    
        
    @objc func awsSensordat(){
        
        _ = Amplify.Auth.getCurrentUser()?.userId
        let data = MainSensorData(latitude: self.coordinates.lat, longitude: self.coordinates.lon, accelerationX: AllData.shared.motionManager.accelerometerData!.acceleration.x, accelerationY: AllData.shared.motionManager.accelerometerData!.acceleration.y, accelerationZ: AllData.shared.motionManager.accelerometerData!.acceleration.z, gyrodataX: AllData.shared.motionManager.gyroData?.rotationRate.x, gyrodataY: AllData.shared.motionManager.gyroData?.rotationRate.y, gyrodataZ: AllData.shared.motionManager.gyroData?.rotationRate.z, pitchData: AllData.shared.motionManager.deviceMotion?.attitude.pitch, rollData: AllData.shared.motionManager.deviceMotion?.attitude.roll, yawData: AllData.shared.motionManager.deviceMotion?.attitude.yaw, quarternionX: AllData.shared.motionManager.deviceMotion?.attitude.quaternion.x, quarternionY: AllData.shared.motionManager.deviceMotion?.attitude.quaternion.y, quarternionZ: AllData.shared.motionManager.deviceMotion?.attitude.quaternion.z, quarternionW: AllData.shared.motionManager.deviceMotion?.attitude.quaternion.w, userAccelerationX: AllData.shared.motionManager.accelerometerData?.acceleration.x, userAccelerationY: AllData.shared.motionManager.accelerometerData?.acceleration.y, userAccelerationZ: AllData.shared.motionManager.accelerometerData?.acceleration.z, timeStamp: AllData.shared.motionManager.deviceMotion?.timestamp, unixTimeStamp: Date().timeIntervalSince1970, heartRateWearablePart: self.heartRateMain ,speedMobileDevice: self.speedMain, speedVehicleOBD: self.obdSpeedMain , rpmVehicleOBD: self.obdRpmMain , temperatureVehicleOBD: self.obdTempMain , videoName: AllData.shared.name, videoID: AllData.shared.name, traveledDistanceInMetres:  self.distanceMain, straightDistanceInMetres: self.StraightdistanceMain, header: self.headerMain, altitude: self.altitudeMain ,savelocationID: AllData.shared.name)
        
        
         

        recordedDataDictionary["id"]?.append(data.id)
        recordedDataDictionary["time_utc"]?.append(getCSTUTCTimeZone().UTC)
        recordedDataDictionary["time_cst"]?.append(getCSTUTCTimeZone().CST)
        recordedDataDictionary["indexVal"]?.append(index)
        recordedDataDictionary["gps_lat"]?.append(data.latitude as Any)
        recordedDataDictionary["gps_long"]?.append(data.longitude as Any)
        recordedDataDictionary["accel_x"]?.append(data.accelerationX as Any)
        recordedDataDictionary["accel_y"]?.append(data.accelerationY as Any)
        recordedDataDictionary["accel_z"]?.append(data.accelerationZ as Any)
        recordedDataDictionary["gyro_x"]?.append(data.gyrodataX as Any)
        recordedDataDictionary["gyro_y"]?.append(data.gyrodataY as Any)
        recordedDataDictionary["gyro_z"]?.append(data.gyrodataZ as Any)
        recordedDataDictionary["pitch"]?.append(data.pitchData as Any)
        recordedDataDictionary["roll"]?.append(data.rollData as Any)
        recordedDataDictionary["yaw"]?.append(data.yawData as Any)
        recordedDataDictionary["quarternionX"]?.append(data.quarternionX as Any)
        recordedDataDictionary["quarternionY"]?.append(data.quarternionY as Any)
        recordedDataDictionary["quarternionZ"]?.append(data.quarternionZ as Any)
        recordedDataDictionary["quarternionW"]?.append(data.quarternionW as Any)
        recordedDataDictionary["userAccelerationX"]?.append(data.userAccelerationX as Any)
        recordedDataDictionary["userAccelerationY"]?.append(data.userAccelerationY as Any)
        recordedDataDictionary["userAccelerationZ"]?.append(data.userAccelerationZ as Any)
        recordedDataDictionary["timeStamp"]?.append(data.timeStamp as Any)
        recordedDataDictionary["unixTimeStamp"]?.append(data.unixTimeStamp as Any)
        recordedDataDictionary["heartRateWearablePart"]?.append(data.heartRateWearablePart as Any)
        recordedDataDictionary["speedMobileDevice(mph)"]?.append(data.speedMobileDevice as Any)
        if let speedMph = instanceOfCustomObject.speedLabel as? Double {
            let speedtoMph = speedMph / 1.609
            recordedDataDictionary["speedVehicleOBD(mph)"]?.append(speedtoMph)
        }else{
            recordedDataDictionary["speedVehicleOBD(mph)"]?.append("")
        }
        
        recordedDataDictionary["rpmVehicleOBD(rpm)"]?.append(instanceOfCustomObject.rpmLabel as Any)
        recordedDataDictionary["temperatureVehicleOBD(C)"]?.append(instanceOfCustomObject.tempLabel as Any)
        recordedDataDictionary["videoName"]?.append(data.videoName as Any)
        recordedDataDictionary["videoID"]?.append(data.videoID as Any)
        recordedDataDictionary["distance_miles"]?.append(data.traveledDistanceInMetres as Any)
        recordedDataDictionary["straightDistanceInMiles"]?.append(data.straightDistanceInMetres as Any)
        recordedDataDictionary["gps_elevation"]?.append(data.altitude as Any)
        recordedDataDictionary["headingcardinal"]?.append(data.header as Any)
        recordedDataDictionary["gps_heading"]?.append(self.gpsHeading as Any)
        recordedDataDictionary["savelocationID"]?.append(data.savelocationID as Any)
        
        index += 1
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!){
        if let oldLocationNew = oldLocation as CLLocation?{
             let oldCoordinates = oldLocationNew.coordinate
             let newCoordinates = newLocation.coordinate
             var area = [oldCoordinates, newCoordinates]
             let polyline = MKPolyline(coordinates: &area, count: area.count)
             mapView.addOverlay(polyline)
         }
    }
    private func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.red
            pr.lineWidth = 5
            return pr
        }
        return nil
    }
    
    //function to observe location updates
    func observeCoordinateUpdates(){
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    //function to observe travelling speed
    func observeSpeed(){
        deviceLocationService.speedPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { speed in
                //convert to mph
                let speedToMPH = (speed * 2.23694)
                
                //collect speed only if speed is greater than zero
                if speedToMPH > 0 {
                    self.speedMain = (String(format: "%.0f", speedToMPH))
                } else {
                    //since the data is invalid return nil
                    self.speedMain = ""
                }
            }
            .store(in: &tokens)
    }
    
    //function to observe travelled distance
    func observeTraveledDistance(){
        deviceLocationService.traveledDistancedistancePublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { distance in
                let distanceInMiles = distance * 0.000621371192
                self.distanceMain = Double(String(format:"%.2f", distanceInMiles)) ?? distanceInMiles
            }
            .store(in: &tokens)
    }
    
    //function to observe Straight Distance
    func observeStraightDistance(){
        deviceLocationService.StraightDistancedistancePublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { distance in
                let distanceInMiles = distance * 0.000621371192
                self.StraightdistanceMain = Double(String(format:"%.2f", distanceInMiles)) ?? distanceInMiles
            }
            .store(in: &tokens)
    }
    
    //function to observe Header Info
    func observeHeaderInfo(){
        deviceLocationService.headingPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { header in
//                print( header )
                self.headerMain = header
            }
            .store(in: &tokens)
    }
    
    func observeGPSHeaderInfo(){
        deviceLocationService.headingDegPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { header in
//                print( header )
                self.gpsHeading = header
            }
            .store(in: &tokens)
    }
    
    func observeAltitude(){
        deviceLocationService.altitudePublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { altitude in
                let scale: Int16 = 3

                let behavior = NSDecimalNumberHandler(roundingMode: .plain, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)

                let roundedValue1 = NSDecimalNumber(value: altitude).rounding(accordingToBehavior: behavior)
//                print(roundedValue1)
                self.altitudeMain = Double(truncating: roundedValue1)
            }
            .store(in: &tokens)
    }
    
    //function for observing location authorizations
    func observeLocationAccessDenied() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink{
//                self.presentAlert(withTitle: "Location", message: "User Location Access Denied", actions: ["OK" : UIAlertAction.Style.default])
            }
            .store(in: &tokens)
    }
    
    func observeLocationAccuracySettings() {
        deviceLocationService.deniedLocationAccuracyAuthPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion{
                    print(error)
                }
            } receiveValue: { locationAcc in
                self.alertUserToAppSettings(message:locationAcc)
            }
            .store(in: &tokens)
    }
    
    func alertUserToAppSettings(message:String){
        let alertController = UIAlertController (title: "Location Accuracy", message: message, preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
    }
    
    //observe heartrate from watch extension
    func observeHeartRate(){
        WatchKitConnection.shared.heartPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { heartrate in
                self.watchConnectionIcon.image = UIImage(systemName: "applewatch")
                self.heartRateMain = heartrate
                self.heartRateValue.text = String(heartrate) + "bpm"
                
                
            }
            .store(in: &tokens)
    }
    
    
    //observe obdvehicleSpeed
//    func observeObdSpeed(){
//        obdDeviceService.obdspeedPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    print(error)
//                }
//            } receiveValue: { speed in
//                let kphSpeed = Measurement(value: Double((speed as NSString).integerValue), unit: UnitSpeed.kilometersPerHour)
//                let mphSpeed = kphSpeed.converted(to: .milesPerHour)
//                self.obdSpeedMain = String(mphSpeed.value)
//                self.speedometerTextField.text = String(mphSpeed.value)
//
//            }
//            .store(in: &tokens)
//    }
    
    //observe obdvehicleEngineRPM
//    func observeObdRpm(){
//        obdDeviceService.obdRPMPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    print(error)
//                }
//            } receiveValue: { rpm in
//                self.obdRpmMain = String(rpm)
//
//            }
//            .store(in: &tokens)
//    }
    
    //observe obdvehicleTemperature
//    func observeObdTemp(){
//        obdDeviceService.obdTemperaturePublisher
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    print(error)
//                }
//            } receiveValue: { temp in
//                self.obdTempMain = String(temp)
//            }
//            .store(in: &tokens)
//    }
    
//    func observeObdAdaptorStat(){
//        obdDeviceService.adaptorStatusPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    print(error)
//                }
//            } receiveValue: { [self] stats in
//                self.adaptorStatusLabel.text = String(stats)
//                if stats == "Looking for adapter..."{
//                    obdConnectButtonLabel.titleLabel?.text = "disconnect"
//
//                } else if stats == ""{
//                    obdConnectButtonLabel.titleLabel?.text = "connect"
//                }else{
//                    obdConnectButtonLabel.isEnabled = false
//                }
//            }
//            .store(in: &tokens)
//    }
    
    //start observing watchkitconnection
    func observeWatcKitConnectionStatus(){
        WatchKitConnection.shared.watchConnectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { [self] status in
                if status == true{
                    print("watch is connected")
                    watchConnectionIcon.image = UIImage(systemName: "applewatch")
                }else{
                    print("watch is not connected")
                    watchConnectionIcon.image = UIImage(systemName: "applewatch.slash")
                }
            }
            .store(in: &tokens)
    }
    //reconnect obd adaptor
    
    func updateObdButtonColor(){
        obdAdaptorButtonOutlet.backgroundColor = UIColor.green
    }
    @IBAction func reconnectOBDAdaptor(_ sender: UIButton) {
//        obdConnectButtonLabel
        self.instanceOfCustomObject.onDisconnectAdapterClicked()
        self.instanceOfCustomObject.onConnectAdapterClicked()
//        if adaptorStatusLabel.text == "OBD2AdapterStateGone"{
//            self.instanceOfCustomObject.onConnectAdapterClicked()
//        }else if adaptorStatusLabel.text == "OBD2AdapterStateConnected"{
//            self.instanceOfCustomObject.onDisconnectAdapterClicked()
//        }else if adaptorStatusLabel.text == "OBD2AdapterStateUnsupportedProtocol"{
//            self.presentAlert(withTitle: "OBD2AdapterState", message: "OBD2 Adaptor has UnsupportedProtocol", actions: ["OK" : UIAlertAction.Style.default])
//        }else{
//            self.instanceOfCustomObject.onDisconnectAdapterClicked()
//            self.instanceOfCustomObject.onConnectAdapterClicked()
//        }
    }
    
    func changeAdpatorButtonLanbel(){
        if adaptorStatusLabel.text == "OBD2AdapterStateGone"{
            obdAdaptorButtonOutlet.backgroundColor = UIColor.red
            self.obdConnectButtonLabel.titleLabel?.text = "connect"
        }else if adaptorStatusLabel.text == "OBD2AdapterStateConnected"{
            self.obdConnectButtonLabel.titleLabel?.text = "disconnect"
            obdAdaptorButtonOutlet.backgroundColor = UIColor.green
        }else if adaptorStatusLabel.text == "OBD2AdapterStateUnsupportedProtocol"{
            obdAdaptorButtonOutlet.backgroundColor = UIColor.red
            self.obdConnectButtonLabel.titleLabel?.text = "reconnect"
        }else{
            self.obdConnectButtonLabel.titleLabel?.text = "reconnect"
        }
    }
    

    
    //function used to log the sensor data
    @objc func logSensorData(){
        //create a sensor data obj to save
        let sensorDataObj = SensorData()
        //lat and long
//        let lat = locationManager.getLatitude(manager: SingeltonData.shared.mangaer)
//        let long = locationManager.getLongitude(manager: SingeltonData.shared.mangaer)
        //set sensor data//
        //accelerometer data
        sensorDataObj.accelerationX = AllData.shared.motionManager.accelerometerData!.acceleration.x
        sensorDataObj.accelerationY = AllData.shared.motionManager.accelerometerData!.acceleration.y
        sensorDataObj.accelerationZ = AllData.shared.motionManager.accelerometerData!.acceleration.z
        let zacc = AllData.shared.motionManager.accelerometerData!.acceleration.z
        self.accelerationInZ.text = String(format: "%.2f", zacc)
        //gyroscope data
        sensorDataObj.gyroDataX = AllData.shared.motionManager.gyroData?.rotationRate.x
        sensorDataObj.gyroDataY = AllData.shared.motionManager.gyroData?.rotationRate.y
        sensorDataObj.gyroDataZ = AllData.shared.motionManager.gyroData?.rotationRate.z
        //device motion data
        sensorDataObj.pitchData = AllData.shared.motionManager.deviceMotion?.attitude.pitch
        sensorDataObj.rollData = AllData.shared.motionManager.deviceMotion?.attitude.roll
        sensorDataObj.yawData = AllData.shared.motionManager.deviceMotion?.attitude.yaw
        //quadrant data
        sensorDataObj.quaternionX = AllData.shared.motionManager.deviceMotion?.attitude.quaternion.x
        sensorDataObj.quaternionY = AllData.shared.motionManager.deviceMotion?.attitude.quaternion.y
        sensorDataObj.quaternionZ = AllData.shared.motionManager.deviceMotion?.attitude.quaternion.z
        sensorDataObj.quaternionW = AllData.shared.motionManager.deviceMotion?.attitude.quaternion.w
        //gravity readings
        sensorDataObj.gravityDataX = AllData.shared.motionManager.deviceMotion?.gravity.x
        sensorDataObj.gravityDataY = AllData.shared.motionManager.deviceMotion?.gravity.y
        sensorDataObj.gravityDataZ = AllData.shared.motionManager.deviceMotion?.gravity.z
        //user acceleration
        sensorDataObj.userAccelerationX = AllData.shared.motionManager.accelerometerData?.acceleration.x
        sensorDataObj.userAccelerationY = AllData.shared.motionManager.accelerometerData?.acceleration.y
        sensorDataObj.userAccelerationZ = AllData.shared.motionManager.accelerometerData?.acceleration.z
        
        //healthdata
        sensorDataObj.heartRate = AllData.shared.heartRate
        //time stamp
        sensorDataObj.timeStamp = AllData.shared.motionManager.deviceMotion?.timestamp
//        sensorDataObj.latitude = lat
//        sensorDataObj.longitude = long
        //set the unix timestamp
        sensorDataObj.unixTimestamp = Date().timeIntervalSince1970
        //set the video ids
        sensorDataObj.videoID = AllData.shared.videoID
        //set the speed
//        sensorDataObj.deviceSpeed = locationManager.getSpeedMPH(manager: SingeltonData.shared.mangaer)
//        //gets the header
//        sensorDataObj.header = SingeltonData.shared.motionManager.deviceMotion?.heading ?? 0
        //MARK:Save lat and long here also
        //start saving to the stream of data directly to the database here if the user isnt saving data to the device
        DispatchQueue.main.async {
//            self.heartRateImage.image = UIImage(named: "suit.heart.fill")
//            self.heartRateImage.tintColor = .red
//            self.heartRateValue.text = String(AllData.shared.heartRate)

        }
        if userData.automaticUpload == false {
            //save the json data as we collect it
//            firebaseManager.saveIndividualSensorData(saveLocation: AllData.shared.name, sensorData: sensorDataObj, videoName: AllData.shared.videoURL)
        }
        //logs the sensor data and saves it until we are done recording
        AllData.shared.sensorDataArray.append(sensorDataObj)
       
        //call the function to update the auto save time here also
//        updateAutoSaveTimer(endDate: SingeltonData.shared.recordingStartDate, currentDate: Date(), view: autoSaveView)
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
//                         ) {
//        let location = locations.last
//        let speedToMPH = (location!.speed) * 2.23694
//        let locationZoom = locations.last!
//        let latitude: Double = locationZoom.coordinate.latitude
//        let longitude: Double = locationZoom.coordinate.longitude
//
//            if startDate == nil {
//                   startDate = Date()
//               } else {
//                   print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
//               }
//        if (location!.horizontalAccuracy > 0) {
//            if (speedToMPH > 0) {
//                print(String(format: "%.3f", latitude))
//                print(String(format: "%.3f", longitude))
//
//                speedometerTextField.text = String(format: "%.0f mph", speedToMPH)
//
//                arrayMPH.append(speedToMPH)
//                let lowSpeed = arrayMPH.min()
//                let highSpeed = arrayMPH.max()
//                minSpeedLabel = (String(format: "%.0f mph", lowSpeed!))
//                miSpeed = (String(format: "%.0f mph", lowSpeed!))
//                maxSpeedLabel = (String(format: "%.0f mph", highSpeed!))
//                maxSpeed = (String(format: "%.0f mph", highSpeed!))
//                avgSpeed()
//            } else{
//                speedometerTextField.text = "0"
//            }
//        }
//           if startLocation == nil {
//               startLocation = locations.first
//           } else if let location = locations.last {
//               traveledDistance += lastLocation.distance(from: location)
//            if traveledDistance < 1609 {
//                let tdF = traveledDistance / 3.28084
//                distanceLabel = (String(format: "%.1f Feet", tdF))
//                trvdistance = (String(format: "%.1f Feet", tdF))
//            } else if traveledDistance > 1609 {
//                let tdM = traveledDistance * 0.00062137
//                distanceLabel = (String(format: "%.1f Miles", tdM))
//                trvdistance = (String(format: "%.1f Miles", tdM))
//
//            }
//               print("Traveled Distance:",  traveledDistance)
//               print("Straight Distance:", startLocation.distance(from: locations.last!))
//               print(location.speed)
//           }
//
//           lastLocation = locations.last
//
//
//    }
//
//
//
//       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//           if (error as? CLError)?.code == .denied {
//               manager.stopUpdatingLocation()
//               manager.stopMonitoringSignificantLocationChanges()
//           }
//      }
//
//    func avgSpeed(){
//
//            let speed:[Double] = arrayMPH
//            let speedAvg = speed.reduce(0, +) / Double(speed.count)
////            print(speedAvg)
//        speedometerTextField.text = (String(format: "%.0f", speedAvg))
//        AvSpeed = String(format: "%.0f", speedAvg)
//    }
//
//    func startlocationupdates() {
//        locationManager.startUpdatingLocation()
//        locationManager.startMonitoringSignificantLocationChanges()
//    }
//    func stopLocationUpdates() {
//        locationManager.stopUpdatingLocation()
//        DispatchQueue.main.async {
//
//            self.speedometerTextField.text = "0"
//        }
//
//    }
    
    private func uploadSensordataAWS(sensor : URL){
        DispatchQueue.main.async { [self] in
            var nameString = sensor.lastPathComponent
            switch sensorDataState {
            case .sensorData:
                nameString = sensor.lastPathComponent
            case .initialHealthData:
                nameString = sensor.lastPathComponent
            case .canBusData:
                nameString = sensor.lastPathComponent
            }
            amplifyVidUpload.sensorUpload(url: sensor, sensorName: nameString, saveLocation: AllData.shared.name)
        }
       
    }
    
    @objc private func saveRecordedData(){
        print("Recorded data saved")
        
        //invalidate the data collection timer
        AllData.shared.saveDataTimer.invalidate()
        AllData.shared.recordAwsTimer.invalidate()
        recordTimerObd.invalidate()
        DispatchQueue.main.async {
            if let vinNumber = self.instanceOfCustomObject.vinLabel{
                    print(vinNumber)
                self.vehicleInfoManager.fecthVehicleInformation(vinNumber: vinNumber as! String)
                }
            }
        
            //initialize new data object
            existingPost = DateStored()
           
            //convert sensor data to csv and save
            csvParser.createCsv(recordedDataDictionary, "sensorData\(AllData.shared.name).csv"){ sensorUrl in
                existingPost.dateStored = AllData.shared.name
                existingPost.createdAt = Temporal.DateTime(Date())
                existingPost.sensorDataURL = String(describing: sensorUrl.lastPathComponent)
                amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                sensorDataState = .sensorData
                //upload senor data automatically to cloud if automatic upload is selected
                
                if userData.automaticUpload == true{
//                    uploadSensordataAWS(sensor: sensorUrl)
                    self.amplifyVidUpload.specialUpload(url: sensorUrl, fileName: sensorUrl.lastPathComponent, saveLocation: AllData.shared.name, contentType: "text/csv")
                    AllData.shared.dateStoredId = existingPost.id
                }
            }
            csvParser.createCsv(firstdat, "initialHealth\(AllData.shared.name).csv"){ sensorUrl in
                existingPost.initiaLHealthData = String(describing: sensorUrl.lastPathComponent)
                amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                sensorDataState = .initialHealthData
                if userData.automaticUpload == true{
//                    uploadSensordataAWS(sensor: sensorUrl)
                    self.amplifyVidUpload.specialUpload(url: sensorUrl, fileName: sensorUrl.lastPathComponent, saveLocation: AllData.shared.name, contentType: "text/csv")
                }
            }
            csvParser.createCsv(obdData, "obdData\(AllData.shared.name).csv"){ sensorUrl in
                allData.initialVehicleData = String(describing: sensorUrl)
                existingPost.initialVehicleData = String(describing: sensorUrl.lastPathComponent)
                amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                sensorDataState = .canBusData
                if userData.automaticUpload == true{
//                    uploadSensordataAWS(sensor: sensorUrl)
                    self.amplifyVidUpload.specialUpload(url: sensorUrl, fileName: sensorUrl.lastPathComponent, saveLocation: AllData.shared.name, contentType: "text/csv")
                }
            }
            AllData.shared.isRecording = false
        self.movieRecorder?.stopRecording { movieURL in
//                camState = .backcam
//                    convertVideo(movieURL, "RoadViewVideo", false)
                self.allData.roadViewURL = String(describing: movieURL)
                let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

                let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent("RoadViewVideo\(AllData.shared.name).mp4")

                self.localFileManager.saveVideoToDocumentsDirectory(srcURL: movieURL, dstURL: documentURL){ movieUrl in
                    
                    // clean up after copying file
                    if FileManager.default.fileExists(atPath: movieURL.path) {
                        do {
                            try FileManager.default.removeItem(atPath: movieURL.path)
                        } catch {
                            print("Could not remove file at url: \(movieURL)")
                        }
                    }
                    if let currentBackgroundRecordingID = self.backgroundRecordingID {
                        self.backgroundRecordingID = UIBackgroundTaskIdentifier.invalid

                        if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                            UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
                        }
                    }
                    self.existingPost.roadViewURL = String(describing: movieUrl.lastPathComponent)
                    self.amplifyVidUpload.saveDataURLlocally(dataURLS: self.existingPost)
                    if self.userData.automaticUpload == true{
                        self.amplifyVidUpload.specialUpload(url: movieUrl, fileName: movieUrl.lastPathComponent, saveLocation: AllData.shared.name, contentType: "video/mp4")

                    }

                }
                
                
            }
        self.movieRecorderpip?.stopRecording { movieURL in
                camState = .frontcam
                
//                    convertVideo(movieURL, "DriverMonitorVideo", true)
                
            
                let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

                let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent("DriverMonitorVideo\(AllData.shared.name).mp4")

                self.localFileManager.saveVideoToDocumentsDirectory(srcURL: movieURL, dstURL: documentURL){ sensorUrl in

                    // clean up after copying file
                    if FileManager.default.fileExists(atPath: movieURL.path) {
                        do {
                            try FileManager.default.removeItem(atPath: movieURL.path)
                        } catch {
                            print("Could not remove file at url: \(movieURL)")
                        }
                    }
                    
                    print(sensorUrl)
                    self.existingPost.driverMonitorURL = String(describing: sensorUrl.lastPathComponent)
                    self.amplifyVidUpload.saveDataURLlocally(dataURLS: self.existingPost)
                    if self.userData.automaticUpload == true{
                        self.amplifyVidUpload.specialUpload(url: sensorUrl, fileName: sensorUrl.lastPathComponent, saveLocation: AllData.shared.name, contentType: "video/mp4")
                        print("File is uploading...")
//                        DispatchQueue.main.async {
//                            self.presentAlert(withTitle: "Files Upload", message: "file is uploading automatically, please navigate to upload tab to see progress", actions: ["OK" : UIAlertAction.Style.default])
//                        }

                    }else{
                        print("file is saved...")
//                        DispatchQueue.main.async {
//                            self.presentAlert(withTitle: "Files Saved", message: "file is saved in library Tab, please upload from there", actions: ["OK" : UIAlertAction.Style.default])
//                        }
                    }
                }
                self.frntcm = String(describing: movieURL)
                AllData.shared.recordAwsTimer.invalidate()
            }
        //delay so the values can be switched and we can process the data
        let delay : Double = 2.0 //delay time in seconds
        print("Dispatch time is :", DispatchTime.now())
        let time = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline:time){
            guard let audioSettings = self.createAudioSettings() else {
                print("Could not create audio settings")
                return
            }
            
            guard let videoSettings = self.createVideoSettings() else {
                print("Could not create video settings")
                return
            }
            
            guard let videoTransform = self.createVideoTransform() else {
                print("Could not create video transform")
                return
            }
            
            //set the workout to start on watch when recording has started
            
            self.movieRecorder = MovieRecorder(audioSettings: audioSettings,
                                               videoSettings: videoSettings,
                                               videoTransform: videoTransform)
            self.movieRecorderpip = MovieRecorder(audioSettings: audioSettings,
                                               videoSettings: videoSettings,
                                               videoTransform: videoTransform)

            
            self.movieRecorder?.startRecording()
            self.movieRecorderpip?.startRecording()
            
            //create the name for the data
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy_MMM_dd_HH_mm_ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            //set the name for the data
            AllData.shared.name = dateString
            //sets the is recording variable
            
            AllData.shared.isRecording = true
            //start the timer to log the data
            DispatchQueue.main.async { [weak self] in
                AllData.shared.recordAwsTimer = Timer.scheduledTimer(timeInterval: AllData.shared.sensorFrequency, target: self as Any, selector: #selector(self?.awsSensordat), userInfo: nil, repeats: true)
                self?.performQuery()
                print("travelled distance:",self?.distanceMain as Any)
//                    didFinishedActiveSession()
            }
            
            //fetch vehicle info using the VIN
            DispatchQueue.main.async { [weak self] in
                if let vinNumber = self?.instanceOfCustomObject.vinLabel{
                    print(vinNumber)
                    self?.vehicleInfoManager.fecthVehicleInformation(vinNumber: vinNumber as! String)
                }
            }
        }
        
    }
    
    
    private func saveVideosToDevice(movieURL : URL, moviename : String){
        //save the data to firebase to refrence back, the create and id
        if userData.automaticUpload == true{
            //saves the video to the device instead of uploading
            //copy the video to the user dir for storage
            localFileManager.saveVideoToDocumentsDirectory(srcURL: movieURL, dstURL: (localFileManager.pathForDocumentDirectoryAsUrl()?.appendingPathComponent("DI", isDirectory: true).appendingPathComponent(moviename))!){ sensorUrl in
                switch camState {
                case .frontcam:
                    existingPost.driverMonitorURL = String(describing: sensorUrl.lastPathComponent)
                    amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                    allData.driverMonitorURL = String(describing: movieURL)
                    print("front")
                   
                case .backcam:
                    print("back")
                    existingPost.roadViewURL = String(describing: sensorUrl.lastPathComponent)
                    amplifyVidUpload.saveDataURLlocally(dataURLS: existingPost)
                    allData.roadViewURL = String(describing: movieURL)
//                    amplifyVidUpload.saveDataURLlocally(dataURLS: realDat)
//                    realDat = DateStored()
                }
            }
            //copy the sensor data
            defaultsManager.setSensorDataArray(sensorDataArray: AllData.shared.sensorDataArray, videoName: movieURL.lastPathComponent)
            DispatchQueue.main.async {
                var nameString = movieURL.lastPathComponent
                switch camState {
                case .frontcam:
                    nameString = "DriverMonitorVideo.MOV"
//                    dtaURLS = DateStored(dateStored: AllData.shared.name, driverMonitorURL: allData.driverMonitorURL, roadViewURL: allData.roadViewURL, sensorDataURL: allData.sensorDataURL, initiaLHealthData: allData.initiaLHealthData, initialVehicleData: allData.initialVehicleData)
//                        amplifyVidUpload.saveDataURLlocally(dataURLS: dtaURLS)
//                        print(dtaURLS)
//                        dtaURLS = DateStored()
                case .backcam:
                    nameString = "RoadViewVideo.MOV"
                }
                
                //generate the name of the file based on date
                _ = "\(Int(Date().timeIntervalSince1970))"
                
                //saves the video to firebase
                

                //create the progress view
                _ = UIProgressView()
                //save the video to firebase and pass the data
//                firebaseManager.saveVideo(url: movieURL, videoName: nameString, saveLocation: AllData.shared.name, progressView: progressView)
                //save all of the data as the video uploads otherwise as its collected
//                amplifyVidUpload.uploadVideo(url: movieURL, videoName: nameString, saveLocation: AllData.shared.name, progressView: progressView)
//                amplifyVidUpload.specialUpload(url: movieURL, videoName: nameString, saveLocation: AllData.shared.name)
            }
            
            //remove the sensor data obj
            AllData.shared.sensorDataArray.removeAll()
        } else if userData.automaticUpload == false {
            //if the user is actually uploading the files now over cellular and not later
            localFileManager.saveVideoToDocumentsDirectory(srcURL: movieURL, dstURL: (localFileManager.pathForDocumentDirectoryAsUrl()?.appendingPathComponent("DI", isDirectory: true).appendingPathComponent(movieURL.lastPathComponent))!){ sensorUrl in
                switch camState {
                case .frontcam:
                    print("")
                case .backcam:
                    print("")
                }
                
            }
            
            DispatchQueue.main.async {
                
                _ = movieURL.lastPathComponent
                //generate the name of the file based on date
                _ = "\(Int(Date().timeIntervalSince1970))"
                //saves the video to firebase
                //create the progress view
                _ = UIProgressView()
                //save the video to firebase and pass the data
//                firebaseManager.saveVideo(url: movieURL, videoName: nameString, saveLocation: AllData.shared.name, progressView: progressView)
                //save all of the data as the video uploads otherwise as its collected
//                amplifyVidUpload.specialUpload(url: movieURL, videoName: nameString, saveLocation: AllData.shared.name)
            }
          
        }
        
        
    }
    @IBOutlet weak var backCameraView: UIView!
    
    @objc func testContinues(){
        DispatchQueue.main.async { [weak self] in
            
            if let obdVehSpeed = self?.instanceOfCustomObject.speedLabel{
                let kphSpeed = Measurement(value: Double((obdVehSpeed as! NSString).integerValue ), unit: UnitSpeed.kilometersPerHour)
                let mphSpeed = kphSpeed.converted(to: .milesPerHour)
                self?.speedometerTextField.text = String(format: "%.0f", mphSpeed.value)
            }
            if self?.instanceOfCustomObject.adapterStatusLabel as! String == "OBD2AdapterStateGone"{
                self?.obdAdaptorButtonOutlet.backgroundColor = nil
               
            }else if self?.instanceOfCustomObject.adapterStatusLabel as? String  == "OBD2AdapterStateConnected"{
                self?.obdAdaptorButtonOutlet.backgroundColor = UIColor.green
            }else if self?.instanceOfCustomObject.adapterStatusLabel as? String  == "OBD2AdapterStateUnsupportedProtocol"{
                self?.obdAdaptorButtonOutlet.backgroundColor = nil
            }else{
                self?.obdAdaptorButtonOutlet.backgroundColor = nil
            }
//            self?.adaptorStatusLabel.text = self?.instanceOfCustomObject.adapterStatusLabel as? String
        }
       
    }
//    if adaptorStatusLabel.text == "OBD2AdapterStateGone"{
//        obdAdaptorButtonOutlet.backgroundColor = UIColor.red
//        self.obdConnectButtonLabel.titleLabel?.text = "connect"
//    }else if adaptorStatusLabel.text == "OBD2AdapterStateConnected"{
//        self.obdConnectButtonLabel.titleLabel?.text = "disconnect"
//        obdAdaptorButtonOutlet.backgroundColor = UIColor.green
//    }else if adaptorStatusLabel.text == "OBD2AdapterStateUnsupportedProtocol"{
//        obdAdaptorButtonOutlet.backgroundColor = UIColor.red
//        self.obdConnectButtonLabel.titleLabel?.text = "reconnect"
//    }else{
//        self.obdConnectButtonLabel.titleLabel?.text = "reconnect"
//    }
    @objc func updateGraph(){
        //checks to make sure that the sensors init
        if AllData.shared.motionManager.isAccelerometerActive == true{
            //start updating the graph and input the data
            graphManager.startUpdating(lineChartView: graphView, graphData: AllData.shared.heartRateArray, manger: AllData.shared.motionManager)
            //update the graph and get the new data here
            sensorManager.saveGraphData(motionManager: AllData.shared.motionManager)
            //sets the graph to be a rolling graph
            graphManager.setRollingGraph(maxDataPoints: 100, graphData: AllData.shared.graphData)
        }
    }
    
    
    
    
}

extension ViewController: WatchKitConnectionDelegate {
    func didFinishedActiveSession() {
        print("watch session has started")
    }
}

//MARK: - WeatherManagerDelegate
extension ViewController: VehicleInfoManagerDelegate {
    func didUpdateVin(_ vinManager: VehicleInfoManager, vehicleInfo: VehicleInfoModel) {
        DispatchQueue.main.async {
            obdData["Make"] = [vehicleInfo.Make as Any]
            obdData["ManufacturerName"] = [vehicleInfo.ManufacturerName as Any]
            obdData["Model"] = [vehicleInfo.Model as Any]
            obdData["ModelYear"] = [vehicleInfo.ModelYear as Any]
            obdData["Series"] = [vehicleInfo.Series as Any]
            obdData["VehicleType"] = [vehicleInfo.VehicleType as Any]
            obdData["PlantCountry"] = [vehicleInfo.PlantCountry as Any]
            obdData["PlantCompanyName"] = [vehicleInfo.PlantCompanyName as Any]
            obdData["PlantState"] = [vehicleInfo.PlantState as Any]
            obdData["BodyClass"] = [vehicleInfo.BodyClass as Any]
            obdData["Doors"] = [vehicleInfo.Doors as Any]
            obdData["DriveType"] = [vehicleInfo.DriveType as Any]
            obdData["EngineNumberofCylinders"] = [vehicleInfo.EngineNumberofCylinders as Any]
            obdData["DisplacementCC"] = [vehicleInfo.DisplacementCC as Any]
            obdData["DisplacementCI"] = [vehicleInfo.DisplacementCI as Any]
            obdData["DisplacementL"] = [vehicleInfo.DisplacementL as Any]
            obdData["EngineConfiguration"] = [vehicleInfo.EngineConfiguration as Any]
            obdData["FuelDeliveryFuelInjectionType"] = [vehicleInfo.FuelDeliveryFuelInjectionType as Any]
            obdData["EngineBrakehpFrom"] = [vehicleInfo.EngineBrakehpFrom as Any]
            obdData["SeatBeltType"] = [vehicleInfo.SeatBeltType as Any]
            obdData["CurtainAirBagLocations"] = [vehicleInfo.CurtainAirBagLocations as Any]
            obdData["FrontAirBagLocations"] = [vehicleInfo.FrontAirBagLocations as Any]
            obdData["KneeAirBagLocations"] = [vehicleInfo.KneeAirBagLocations as Any]
            obdData["SideAirBagLocations"] = [vehicleInfo.SideAirBagLocations as Any]
            obdData["NCSABodyType"] = [vehicleInfo.NCSABodyType as Any]
            obdData["NCSAMake"] = [vehicleInfo.NCSAMake as Any]
            obdData["Doors"] = [vehicleInfo.Doors as Any]
            obdData["NCSAModel"] = [vehicleInfo.NCSAModel as Any]
            obdData["DateofCollection"] = [AllData.shared.name as Any]
            obdData["timeStamp"] = [AllData.shared.motionManager.deviceMotion?.timestamp as Any]
            obdData[" unixTimeStamp"] = [Date().timeIntervalSince1970 as Any]
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}


// MARK: -- Helpers
extension ViewController {
    func setupVision() {
        self.requests = [faceDetectionRequest]
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            //perform all the UI updates on the main queue
            guard let results = request.results as? [VNFaceObservation] else { return }
            self.frontCameraVideoPreviewView.removeMask()
            for face in results {
                self.frontCameraVideoPreviewView.drawFaceboundingBox(face: face)
            }
        }
    }
    
    func handleFaceLandmarks(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            //perform all the UI updates on the main queue
            guard let results = request.results as? [VNFaceObservation] else { return }
            self.frontCameraVideoPreviewView.removeMask()
            for face in results {
                self.frontCameraVideoPreviewView.drawFaceWithLandmarks(face: face)
            }
        }
    }

}

// Camera Settings & Orientation
extension ViewController {
    func availableSessionPresets() -> [String] {
        let allSessionPresets = [AVCaptureMultiCamSession.Preset.photo,
                                 AVCaptureMultiCamSession.Preset.low,
                                 AVCaptureMultiCamSession.Preset.medium,
                                 AVCaptureMultiCamSession.Preset.high,
                                 AVCaptureMultiCamSession.Preset.cif352x288,
                                 AVCaptureMultiCamSession.Preset.vga640x480,
                                 AVCaptureMultiCamSession.Preset.hd1280x720,
                                 AVCaptureMultiCamSession.Preset.iFrame960x540,
                                 AVCaptureMultiCamSession.Preset.iFrame1280x720,
                                 AVCaptureMultiCamSession.Preset.hd1920x1080,
                                 AVCaptureMultiCamSession.Preset.hd4K3840x2160]
        
        var availableSessionPresets = [String]()
        for sessionPreset in allSessionPresets {
            if session.canSetSessionPreset(sessionPreset) {
                availableSessionPresets.append(sessionPreset.rawValue)
            }
        }
        
        return availableSessionPresets
    }
    
    fileprivate func radiansForDegrees(_ degrees: CGFloat) -> CGFloat {
        return CGFloat(Double(degrees) * Double.pi / 180.0)
    }
    
//    func exifOrientationForDeviceOrientation(_ deviceOrientation: UIDeviceOrientation) -> CGImagePropertyOrientation {
//
//        switch deviceOrientation {
//        case .portraitUpsideDown:
//            return .rightMirrored
//
//        case .landscapeLeft:
//            return .downMirrored
//
//        case .landscapeRight:
//            return .upMirrored
//
//        default:
//            return .leftMirrored
//        }
//    }
//
//    func exifOrientationForCurrentDeviceOrientation() -> CGImagePropertyOrientation {
//        return exifOrientationForDeviceOrientation(UIDevice.current.orientation)
//    }
    
    
    
    func exifOrientationFromDeviceOrientation() -> UInt32 {
        enum DeviceOrientation: UInt32 {
            case top0ColLeft = 1
            case top0ColRight = 2
            case bottom0ColRight = 3
            case bottom0ColLeft = 4
            case left0ColTop = 5
            case right0ColTop = 6
            case right0ColBottom = 7
            case left0ColBottom = 8
        }
        var exifOrientation: DeviceOrientation

        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            exifOrientation = .left0ColBottom
        case .landscapeLeft:
            exifOrientation = pipDevicePosition == .front ? .top0ColLeft : .bottom0ColRight
        case .landscapeRight:
            exifOrientation = pipDevicePosition == .front ? .top0ColLeft : .bottom0ColRight
        default:
            exifOrientation = pipDevicePosition == .front ? .top0ColLeft : .left0ColTop
        }
        return exifOrientation.rawValue
    }
    
    
}



//extension ViewController: WatchKitConnectionDelegate {
//    func didFinishedActiveSession() {
//
//        WatchKitConnection.shared.sendMessage(message: ["username" : "nhathm" as AnyObject])
//    }
//}



//extension ViewController: WatchKitConnectionDelegate {
//    func didFinishedActiveSession() {
//        WatchKitConnection.shared.sendMessage(message: ["username" : "\(start)" as AnyObject])
//
//    }
//}



// func getActiveWCSession(completion: @escaping (WCSession)->Void) {
//    guard WCSession.isSupported() else { return }
//
//    let wcSession = WCSession.default()
//    wcSession.delegate = self
//
//    if wcSession.activationState == .activated {
//        completion(wcSession)
//    } else {
//        wcSession.activate()
//        wcSessionActivationCompletion = completion
//    }
//}
//
