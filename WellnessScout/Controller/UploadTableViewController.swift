//
//  UploadTableViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/24/21.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos
import Amplify
import AWSS3
import Combine


class UploadTableViewController: UITableViewController {
    
    var uploadOperation: StorageUploadFileOperation?
    var resultSink: AnyCancellable?
    var progressSink: AnyCancellable?
    let amplifyUpload = AmplifyDataUpload()

    
    //MARK: Singelton Instance use this to refrence all data
    let alldata = AllData.shared
    //instance of video manager
    let videoManager = VideoManager()
    //refrence to the last video selected that the user wants to upload
    //local variable to refrence the last value of the taks
    var lastTaskAmount = 0
    
    
    //this fires when the view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the data source and delegate
        tableView.delegate = self
        tableView.dataSource = self
        //ask for access to the photo library
        videoManager.checkPhotoLibraryPermission()
        //reload the view
        tableView.reloadData()
//        alldata.clockTimer = Timer.scheduledTimer( timeInterval: 0.1, target: self, selector: #selector(updateCells), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alldata.clockTimer = Timer.scheduledTimer( timeInterval: 0.1, target: self, selector: #selector(updateCells), userInfo: nil, repeats: true)
        //reload the view
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
        tableView.reloadData()
    }
    //the view will dissapear
    override func viewWillDisappear(_ animated: Bool) {
        //remove the timer here
        alldata.clockTimer.invalidate()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //create the timer here to animate the progress bar

        alldata.clockTimer = Timer.scheduledTimer( timeInterval: 0.1, target: self, selector: #selector(updateCells), userInfo: nil, repeats: true)
        //remove finished tasks from view if any
        removeFinishedTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
        //check to see if any failed, if they did remove them
        removeFailedTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
        //check for unknown values
        removeUnknownTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
        
    }
    
    //Function called every time interval
    @objc func updateCells() {
        //Gets the indexs for the visile rows
        let indexPathsArray = tableView.indexPathsForVisibleRows
        //loops through the indexs in the indexPathsArray
        for indexPath in indexPathsArray! {
            //Creates the cell
            if let cell = tableView.cellForRow(at: indexPath) as? UploadTableViewCell{
                
                if AllData.shared.storageTaskArray2.count > 0{
                    cell.videoNameLabel.text = AllData.shared.storageTaskArray2[indexPath.row].request.local.lastPathComponent
                    let progress = AllData.shared.storageTaskArray2[indexPath.row]
                    progressSink = progress
                        .progressPublisher
                        .receive(on: DispatchQueue.main)
                        .sink{
                            //updates the cell item here
                            cell.progressBar.progress = Float($0.fractionCompleted)
//                                cell.videoNameLabel.text = $0
                            //create the completed bytes and format
                            let completedBytes = String( format : "%.3f", (Double($0.completedUnitCount) * 0.000001))
                            //create the total bytes and format
                            let totalBytes = String(format: "%.3f", (Double($0.totalUnitCount) * 0.000001))
                            //set the total
                            cell.transferedBytesLabel.text = "\(completedBytes) / \(totalBytes) MB"
                        }
                    resultSink = progress
                            .resultPublisher
                            .receive(on: DispatchQueue.main)
                            .sink(
                                receiveCompletion: { completion in
                                    if case .failure(let storageError) = completion {
                                        print(storageError)
                                        self.removeFailedTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
                                    }
                                }, receiveValue: { print("File successfully uploaded: \($0)")
//                                    print("this the data id sent",AllData.shared.dateStoredId)
//                                    self.amplifyUpload.updateDataStore(id: AllData.shared.dateStoredId)
                                    cell.videoNameLabel.text = $0
                                    if AllData.shared.storageTaskArray2.count > 0{
                                        //remove values if they have finished
                                        print("this the data id sent",AllData.shared.dateStoredId)
                                        self.amplifyUpload.updateDataStore(id: AllData.shared.dateStoredId)
                                        self.removeFinishedTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
                                    }
                                }
                            )

                       
                    
                }
//                //Checks if the array is not 0 and that we are on correct segmented control
//                if AllData.shared.storageTaskArray.count > 0{
//                    //checks the storage object and looks at the progress of it
//                    AllData.shared.storageTaskArray[indexPath.row].observe(.progress) {snapshot in
//                        //updates the cell item here
//                        cell.progressBar.progress = Float(snapshot.progress!.fractionCompleted)
//                        cell.videoNameLabel.text = snapshot.reference.name
//                        //create the completed bytes and format
//                        let completedBytes = String( format : "%.3f", (Double(snapshot.progress!.completedUnitCount) * 0.000001))
//                        //create the total bytes and format
//                        let totalBytes = String(format: "%.3f", (Double(snapshot.progress!.totalUnitCount) * 0.000001))
//                        //set the total
//                        cell.transferedBytesLabel.text = "\(completedBytes) / \(totalBytes) MB"
//                    }
//                    //completetion of upload
//                    AllData.shared.storageTaskArray[indexPath.row].observe(.success) { snapshot in
//                        //removes the storage task since its complete
//                        if AllData.shared.storageTaskArray.count > 0{
//                            //remove values if they have finished
//                            self.removeFinishedTasks(uploadTaskArray: AllData.shared.storageTaskArray)
//                        }
//                    }
//                    //failure of upload
//                    AllData.shared.storageTaskArray[indexPath.row].observe(.failure) { snapshot in
//                        // if an error occurs then fire the error event
//                        print("Error occured while uploading")
//                        self.removeFailedTasks(uploadTaskArray: AllData.shared.storageTaskArray)
//                    }
//                }
                
            }else {
                print("No uploads")
            }
        }
        //reloads if the values in the storage task array change
        if lastTaskAmount != AllData.shared.storageTaskArray2.count{
            //reload cells that need to change
            tableView.reloadData()
            //set the new count
            lastTaskAmount = AllData.shared.storageTaskArray2.count
            //check for unknown values
            removeUnknownTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
        }
    }
    
    //function to remove finished items
    func removeFinishedTasks(uploadTaskArray : [StorageUploadFileOperation]){
        //loop thru all the tasks
        var index = 0
        for task in uploadTaskArray{
            //if the item is complete
            print(task)
            if task.isFinished{
                print(index)
                AllData.shared.storageTaskArray2.remove(at: index)
                //check to see if the task had an error, if it did pause it and report that there was an error
                index = index - 1
            }
//            if task.snapshot.status == StorageTaskStatus.success{
//                //confirm that an error isn't thrown
//                //remove the item from the data
//                print(index)
//                AllData.shared.storageTaskArray2.remove(at: index)
//                //check to see if the task had an error, if it did pause it and report that there was an error
//                index = index - 1
//            }
            //incriment the index
            index = index + 1
        }
        //reload the view
        tableView.reloadData()
    }
    
    //function used to pause items that failed
    func removeFailedTasks(uploadTaskArray : [StorageUploadFileOperation]){
        //loop thru all the tasks
        var index = 0
        for task in uploadTaskArray{
            //if the item is complete
            if task.isFinished{
                //remove the item from the data
                AllData.shared.storageTaskArray2.remove(at: index)
                //remove index
                index = index - 1
            }
            //incriment the index
            index = index + 1
        }
        //reload the view
        tableView.reloadData()
    }
    
    //function used to pause items that failed
    func removeUnknownTasks(uploadTaskArray : [StorageUploadFileOperation]){
        //loop thru all the tasks
        var index = 0
        for task in uploadTaskArray{
            //if the item is complete
            if task.isFinished{
                //remove the item from the data
                AllData.shared.storageTaskArray2.remove(at: index)
                //remove index
                index = index - 1
            }
            //incriment the index
            index = index + 1
        }
        //reload the view
        tableView.reloadData()
    }
    
    //MARK:Pause button change later
    //Code that executes when the upload button is pressed for each cell
    @objc func uploadButtonPressed(sender: UIButton!){
        //creates the cell for the index the user presses
        if AllData.shared.storageTaskArray2[sender.tag].isExecuting{
            //change the text of the button
            sender.setTitle("Resume", for: .normal)
            //upload button to upload the file
            AllData.shared.storageTaskArray2[sender.tag].pause()
        }else{
            //change the text of the button
            sender.setTitle("Pause", for: .normal)
            //upload button to upload the file
            AllData.shared.storageTaskArray2[sender.tag].resume()
        }
        //reload the tableview when you pause or resume an item
        tableView.reloadData()
    }
    
    //Code that executes when the cancel button is pressed for each cell
    @objc func cancelButtonPressed(sender: UIButton!){
        //cancel the upload and remove it
        AllData.shared.storageTaskArray2[sender.tag].cancel()
        //remove the item from the table view
        AllData.shared.storageTaskArray2.remove(at: sender.tag)
        //reload the data
        tableView.reloadData()
        //remove temp files if cancel button was pressed
//        FileManager.default.clearTmpDirectory()
        print("Cancel button pressed")
    }
    
    /*
     //fires when the photo library button  is pressed
     @IBAction func photoLibraryButtonPressed(_ sender: Any) {
     //present the view here
     presentImagePickerController(withSourceType: .photoLibrary)
     }
     */
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AllData.shared.storageTaskArray2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //gets the cell and sets it to the custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "uploadCell", for: indexPath) as! UploadTableViewCell
        
        //set the upload tag
        cell.videoNameLabel.tag = indexPath.row
        cell.uploadButton.tag = indexPath.row
        //set the cancel tag
        cell.cancelButton.tag = indexPath.row
        //Adds a target for when the buttons are pressed, the selector is going to another function
        cell.uploadButton.addTarget(self, action: #selector(uploadButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
        cell.cancelButton.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
        
        let progress = AllData.shared.storageTaskArray2[indexPath.row]
        cell.videoNameLabel.text = AllData.shared.storageTaskArray2[indexPath.row].request.local.lastPathComponent
        progressSink = progress
            .progressPublisher
            .receive(on: DispatchQueue.main)
            .sink{ print("\($0.fractionCompleted * 100)% completed")
                //updates the cell item here
                cell.progressBar.progress = Float($0.fractionCompleted)
//                                cell.videoNameLabel.text = $0
                //create the completed bytes and format
                let completedBytes = String( format : "%.3f", (Double($0.completedUnitCount) * 0.000001))
                //create the total bytes and format
                let totalBytes = String(format: "%.3f", (Double($0.totalUnitCount) * 0.000001))
                //set the total
                cell.transferedBytesLabel.text = "\(completedBytes) / \(totalBytes) MB"
            }
        
        resultSink = progress
                .resultPublisher
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let storageError) = completion {
                            print(storageError)
                            self.removeFailedTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
                        }
                    }, receiveValue: { print("File successfully uploaded: \($0)")
//                        print("this the data id sent",AllData.shared.dateStoredId)
//                        self.amplifyUpload.updateDataStore(id: AllData.shared.dateStoredId)
//                        cell.videoNameLabel.text = $0
                        if AllData.shared.storageTaskArray2.count > 0{
                            //remove values if they have finished
                            print("this the data id sent",AllData.shared.dateStoredId)
                            self.amplifyUpload.updateDataStore(id: AllData.shared.dateStoredId)
                            self.removeFinishedTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
                        }
                    }
                )

            
        
//        //checks the storage object and looks at the progress of it
//        AllData.shared.storageTaskArray2[indexPath.row].observe(.progress) { snapshot in
//            //updates the cell item here
//            cell.progressBar.progress = Float(snapshot.progress!.fractionCompleted)
//            cell.videoNameLabel.text = snapshot.reference.name
//            //create the completed bytes and format
//            let completedBytes = String( format : "%.3f", (Double(snapshot.progress!.completedUnitCount) * 0.000001))
//            //create the total bytes and format
//            let totalBytes = String(format: "%.3f", (Double(snapshot.progress!.totalUnitCount) * 0.000001))
//            //set the total
////            cell.transferedBytesLabel.text = "\(completedBytes) / \(totalBytes) MB"
//        }
//
//        //completetion of upload
//        AllData.shared.storageTaskArray2[indexPath.row].observe(.success) { snapshot in
//            // Download completed successfully
//            // Stop progress indicator
//            print("Finished")
//            self.removeFinishedTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
//            //remove all temp files here so the app doesn't continue to grow in size
//            FileManager.default.clearTmpDirectory()
//        }
//        //failure of upload
//        AllData.shared.storageTaskArray2[indexPath.row].observe(.failure) { snapshot in
//            // An error occurred!
//            // Stop progress indicator
//            print("Error occured while uploading")
//            self.presentAlert(withTitle: "Upload Removed", message: "Removing upload named \(String(describing: cell.videoNameLabel.text!)) this is due to an invalid internet connection or it was manually removed!", actions: ["OK" : UIAlertAction.Style.default])
//            //MARK: Could have two options on the failure button, which are remove and retry
//            self.removeFailedTasks(uploadTaskArray: AllData.shared.storageTaskArray2)
//            //remove all temp files here so the app doesn't continue to grow in size
//            FileManager.default.clearTmpDirectory()
//        }
        
        //returns the cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //returns the height of the cell
        return 250
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Upload"
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
    
}

//extension UploadTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
//
//    // MARK: UIImagePickerController
//    func presentImagePickerController(withSourceType sourceType: UIImagePickerController.SourceType) {
//        let controller = UIImagePickerController()
//        //set delegate
//        controller.delegate = self
//        //set controller
//        controller.sourceType = sourceType
//        //set media type(video)
//        controller.mediaTypes = [String(kUTTypeMovie), String(kUTTypeMPEG4)]
//
//        //present the controller here
//        present(controller, animated: true, completion: nil)
//    }
//
//    // MARK: UIImagePickerController Delegate
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        //make sure the video is not compressed
//        picker.videoExportPreset = AVAssetExportPresetPassthrough
//        //get the video that the user selected from the photo library
//        if let pickedVideo = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//            print(pickedVideo.absoluteURL)
//            //refrence to the firebase manager
//            let firebaseManager = FirebaseManager()
//            //progress view instance to be passed in
//            let progress = UIProgressView()
//            print("full Url : ", pickedVideo.absoluteURL)
//            print("the old url was :", pickedVideo.lastPathComponent)
//            //create a temp url to access the private url
//            let tempUrl = createTemporaryURLforVideoFile(url: pickedVideo)
//            print("Temp url is:", tempUrl)
//            //save the video now after it has been selected
//            firebaseManager.saveVideo(url: tempUrl, videoName: tempUrl.lastPathComponent, saveLocation: AllData.shared.name, progressView: progress)
//
//            //reload the tableview
//            tableView.reloadData()
//        }
//        dismiss(animated: true, completion: nil)
//    }
//}
//extension FileManager {
//    func clearTmpDirectory() {
//        do {
//            let tmpDirURL = FileManager.default.temporaryDirectory
//            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
//            try tmpDirectory.forEach { file in
//                let fileUrl = tmpDirURL.appendingPathComponent(file)
//                try removeItem(atPath: fileUrl.path)
//                print("Temp file removed")
//            }
//        } catch {
//            //catch the error somehow
//            print("Error occured when clearing temp files")
//        }
//    }
//}
