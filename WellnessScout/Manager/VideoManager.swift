//
//  VideoManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/24/21.
//

import Foundation
import AVFoundation
import UIKit
import MobileCoreServices
import AVKit
import Photos

public class VideoManager{
    
    //MARK: Singelton Instance use this to refrence all data
    let allData = AllData.shared
    
    
    //MARK: Used to manage the video
    //setup the camera here
    public func setupCamera(videoPreviewLayer : AVCaptureVideoPreviewLayer, captureSession: AVCaptureSession!, view : UIView, movieOutput : AVCaptureMovieFileOutput){
        //creates a new session and sets the settings for it
        captureSession.sessionPreset = .high
        //gets the back camera
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                //tell the user we could accesses the camera and return
                print("Unable to access back camera!")
                return
        }
        //try to set the camera up and call the live preview
        do {
            //sets the input
            let input = try AVCaptureDeviceInput(device: backCamera)
            //checks to make sure the session can get access to teh camera
            if captureSession.canAddInput(input){
                captureSession.addInput(input)
                captureSession.addOutput(movieOutput)
                //set the input new
                allData.activeInput = input
                //calls the function to setup to preview
                setupLivePreview(videoPreviewLayer: videoPreviewLayer, captureSession: captureSession, view: view)
            }
        }
            //checks for errors in the camera
        catch let error  {
            //prints an error if one occurs
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    //MARK: Starts the video view
    private func setupLivePreview(videoPreviewLayer : AVCaptureVideoPreviewLayer, captureSession: AVCaptureSession!, view : UIView){
        //sets up the live preview for the main view
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
        //puts in on its own queue so the application fires up as quickly as possible
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            captureSession.startRunning()
        }
        //starts the setup on the main queue to increase performance
        DispatchQueue.main.async {
            //sets the view layer here for the preview layer
            videoPreviewLayer.frame = view.bounds
        }
    }
    
    //function used to switch the views
    func switchCameras(captureSession: AVCaptureSession, videoPreviewLayer : AVCaptureVideoPreviewLayer, frontCameraEnabled: Bool) {
        //remove old capture session
        captureSession.stopRunning()
        videoPreviewLayer.removeFromSuperlayer()
        
        //set the new cameras session
        if frontCameraEnabled == true {
            //remove all inputs
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession.removeInput(input)
                }
            }
            //add the front camera input
            let frontInput = try! AVCaptureDeviceInput(device: getFrontCamera()!)
            captureSession.addInput(frontInput)
        } else {
            //remove all inputs from the session
            if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    captureSession.removeInput(input)
                }
            }
            //set the back camera
            let backInput = try! AVCaptureDeviceInput(device: getBackCamera())
            captureSession.addInput(backInput)
        }
        //start the session again
        captureSession.startRunning()
    }
    
    //function used to remove the front camera from the capture device
    func getFrontCamera() -> AVCaptureDevice?{
        let videoDevices = AVCaptureDevice.devices(for: AVMediaType.video)
        //search through the devices until we find the front camera device
        for device in videoDevices{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevice.Position.front {
                print("Found front camera ")
                return device
            }
        }
        //return nil if we cant find the front camera
        return nil
    }
    
    //function used to get the back camera from the device
    func getBackCamera() -> AVCaptureDevice{
        //return the capture device
        return AVCaptureDevice.default(for: AVMediaType.video)!
    }
    
    //set the current video orientatiom
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        return orientation
    }
    //create the temp url for the file stsysem
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
    //stop the recording by passing the instance of the movie output int
    func stopRecording(movieOutput : AVCaptureMovieFileOutput) {
        //checks to see if we are already recording
        if movieOutput.isRecording == true {
            //stops the recording
            
            movieOutput.stopRecording()
        }
    }
    //dispatcht the video queue when the user trys to access the camera
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }

    //MARK: Used for recording
    func startRecording(movieOutput : AVCaptureMovieFileOutput, activeInput: AVCaptureDeviceInput, recordingDelegate :AVCaptureFileOutputRecordingDelegate){
        print("Test")
        //check to see if we are already recording
        if movieOutput.isRecording == false{
            print("We werent recording, starting recording")
            //connect the movie output
            let connection = movieOutput.connection(with: AVMediaType.video)
            //check to see if we have the correct orientation
            if connection?.isVideoOrientationSupported == false {
                //set if it is
                connection?.videoOrientation = currentVideoOrientation()
            }
            //check to see if the video type is supported
            if connection?.isVideoStabilizationSupported == false {
                //set if it is
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            //set the back camera up
            guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
                else {
                    //tell the user we could accesses the camera and return
                    print("Unable to access back camera!")
                    return
            }
            //check to see if the device is auto focusing
            if backCamera.isSmoothAutoFocusEnabled == true {
                //look for config files
                do{
                    try backCamera.lockForConfiguration()
                    backCamera.isSmoothAutoFocusEnabled = false
                    backCamera.unlockForConfiguration()
                }catch{
                    //print error if we catch one
                    print("Error occured in start Recording, caught here")
                    print(error)
                }
            }
            //set the output url here
            guard let outputURLTemp  = tempURL() else { return }
            //set the url to the output url in the singelton
            AllData.shared.outputURL = outputURLTemp
            //metaddata for the item
            let metadata = AVMutableMetadataItem()
            metadata.keySpace = AVMetadataKeySpace.quickTimeMetadata
            metadata.key = AVMetadataKey.quickTimeMetadataKeyLocationISO6709 as NSString
            metadata.identifier = AVMetadataIdentifier.commonIdentifierTitle
            metadata.value = String(format: "%+09.5f%+010.5f%+.0fCRSWGS_84", 9.8091, 10.98072) as NSString
            movieOutput.metadata = [metadata]
            
            //start recording
            movieOutput.startRecording(to: outputURLTemp, recordingDelegate: recordingDelegate)
        }else{
            //stops the recording if we are already recording
            stopRecording(movieOutput: movieOutput)
            print("We were already recording now we stopped")
        }
    }
    
    //func used to fetch assets
    private func fetchAssets(){
        // Sort the images by descending creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        //fetch the metadata and save it to the results
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: fetchOptions)
        
        print(fetchResult)
        print(fetchResult.firstObject?.creationDate as Any)
        print(fetchResult.firstObject?.burstIdentifier as Any)
        print(fetchResult.firstObject?.burstIdentifier as Any)
        print(fetchResult.firstObject?.localIdentifier as Any)
        print(fetchResult.firstObject?.location as Any)
        print(fetchResult.lastObject?.localIdentifier as Any)
        print(fetchResult.lastObject?.creationDate as Any)
        print(fetchResult.lastObject?.burstIdentifier as Any)
        print(fetchResult.lastObject?.burstIdentifier as Any)
        print(fetchResult.lastObject?.localIdentifier as Any)
        print(fetchResult.lastObject?.location as Any)
    }
    
    
    
    //function used to save the video to the photo library
    func saveVideoToPhotoLibrary(outputFileURL : URL){
        
        saveVideoToPhotos(url: outputFileURL)
        
        
        /*
        //saves the video to the photo library
        UISaveVideoAtPathToSavedPhotosAlbum(outputFilrURL.path, nil, nil, nil)
        */
    }
    
    
    func printSupportedFPSRanges()->String{
        //try to access the back camera
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                //tell the user we could accesses the camera and return
                print("Unable to access back camera!")
                return "Error"
        }
        //try to set the camera up and call the live preview
        do {
            //sets the input
            let input = try AVCaptureDeviceInput(device: backCamera)
            //checks to make sure the session can get access to teh camera
            //returns the supported fps ranges for the device
            return "\(backCamera.activeFormat.videoSupportedFrameRateRanges[0].minFrameRate)-\(backCamera.activeFormat.videoSupportedFrameRateRanges[0].maxFrameRate)"
        }
            //checks for errors in the camera
        catch let error  {
            //prints an error if one occurs
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        return "\(backCamera.activeFormat.videoSupportedFrameRateRanges[0].minFrameRate)-\(backCamera.activeFormat.videoSupportedFrameRateRanges[0].maxFrameRate)"
    }
    
    //function used to return the min frame rate value as a double
    func getMinFrameRateValue()->Double{
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
            return backCamera.activeFormat.videoSupportedFrameRateRanges[0].minFrameRate
        }
            //checks for errors in the camera
        catch let error  {
            //prints an error if one occurs
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        return backCamera.activeFormat.videoSupportedFrameRateRanges[0].minFrameRate
    }
    
    //function used to return the max frame rate as a double
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
            return backCamera.activeFormat.videoSupportedFrameRateRanges[0].maxFrameRate
        }
            //checks for errors in the camera
        catch let error  {
            //prints an error if one occurs
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        return backCamera.activeFormat.videoSupportedFrameRateRanges[0].maxFrameRate
    }
    
    //set the frame rate
    func setFrameRate(frameRate : Double){
        //try to access the back camera
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                //tell the user we could accesses the camera and return
                print("Unable to access back camera!")
                return
        }
        //try to set the camera up and call the live preview
        do {
            //sets the input
            let input = try AVCaptureDeviceInput(device: backCamera)
            //checks to make sure the session can get access to teh camera
            backCamera.set(frameRate: frameRate)
            print(backCamera.activeFormat.videoSupportedFrameRateRanges)
            
        }
            //checks for errors in the camera
        catch let error  {
            //prints an error if one occurs
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    
    //function used to ask the user for photo library premission
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("Authorized")
        //handle authorized status
        case .denied, .restricted :
            print("Denied")
        //handle denied status
        case .notDetermined:
            print("Not determined")
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("Approved")
                // as above
                case .denied, .restricted:
                    print("Denied")
                case .notDetermined:
                    print("NA")
                default:
                    print("Default case")
                }
                
            }
        default:
            print("Default case ")
        }
        
    }
    
    //save videos to photos
    private func saveVideoToPhotos(url:URL){
    
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { saved, error in
            if saved {
                
                let asset = AVAsset(url: url)
                let formatsKey = "availableMetadataFormats"
                asset.loadValuesAsynchronously(forKeys: [formatsKey]) {
                    var error: NSError? = nil
                    let status = asset.statusOfValue(forKey: formatsKey, error: &error)
                    if status == .loaded {
                        for format in asset.availableMetadataFormats {
                            let metadata = asset.metadata(forFormat: format)
                            // process format-specific metadata collection
                            print(metadata)
                        }
                    }
                }
                self.fetchAssets()
            }
        }
    }
    
    
    
    //used to access the private sensetive url
     func createTemporaryURLforVideoFile(url: URL) -> URL {
         print("Private url is: ", url)
         /// Create the temporary directory.
         let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
         /// create a temporary file for us to copy the video to.
         let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(url.lastPathComponent )
         /// Attempt the copy.
         do {
             try FileManager().copyItem(at: url.absoluteURL, to: temporaryFileURL)
         } catch {
             print("There was an error copying the video file to the temporary location.")
         }
         //return the new url
         return temporaryFileURL as URL
     }
    
    //function used to completly stop all session
    func stopSingleCameraSession(videoPreviewLayer : AVCaptureVideoPreviewLayer, captureSession: AVCaptureSession!){
        //stop the session
        captureSession.stopRunning()
        videoPreviewLayer.removeFromSuperlayer()
    }
    
    
    
    
    
    
}

extension AVCaptureDevice {
    func set(frameRate: Double) {
        guard let range = activeFormat.videoSupportedFrameRateRanges.first,
            range.minFrameRate...range.maxFrameRate ~= frameRate
            else {
                print("Requested FPS is not supported by the device's activeFormat !")
                print()
                return
        }
        
        do { try lockForConfiguration()
            activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
            activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: Int32(frameRate))
            unlockForConfiguration()
        } catch {
            print("LockForConfiguration failed with error: \(error.localizedDescription)")
        }
    }
}


