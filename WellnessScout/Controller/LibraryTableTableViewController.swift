//
//  LibraryTableTableViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/23/21.
//

import UIKit
import Combine
import Amplify
import SwiftUI
import AmplifyPlugins
import QuickLook



class LibraryTableTableViewController: UITableViewController,QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    
    var fileURL : URL?
    @State var observationToken: AnyCancellable?
    //instance of the local file manager class
    let localFileManager = LocalFileManager()
    let defaultManager = DefaultsManager()
    let amplifyVidUpload = AmplifyDataUpload()
    var URLOfData : [DateStored] = []
    //local variables
    var urlArray : [URL] = []
    //selected url
    var selectedUrlIndex : Int!
    enum cameraTypes {
        case frontcam
        case backcam
    }
    var camState: cameraType = .backcam
    
    enum csvFileType {
        case initialHealth
        case initialVehicle
        case sensorData
    }
    var csvState: csvFileType = .sensorData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
        self.tableView.reloadData()
        //loadURLS from dataStore
        
        loadDataFromDataStore(){ totalData in
            self.URLOfData = totalData
            print(totalData)
        }
       
        
//        observeData()
        
        //load the url array with the saved urls in the document dir
        urlArray = localFileManager.getURLArray()
        //after loading reload the table view
        self.tableView.reloadData()
        //set the intital values for the table
        tableView.allowsSelection = false
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
        loadDataFromDataStore(){ totalData in
            self.URLOfData = totalData
            self.tableView.reloadData()
        }
    }
   
    
//    override func viewDidAppear(_ animated: Bool) {
//        //load the url array with the saved urls in the document dir
////        urlArray = localFileManager.getURLArray()
////        loadDataFromDataStore(){ totalData in
////            print(totalData)
////        }
////        observeData()
////        //after loading reload the table view
////        tableView.reloadData()
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disappeared")
    }
    
    //Code that executes when the preview button is pressed for each cell
    @objc func openInitHealthButtonPressed(sender: UIButton!){
        //set the selected url
        csvState = .initialHealth
        selectedUrlIndex = sender.tag
        //perform segue to the preview
        if let fileN = URLOfData[selectedUrlIndex].initiaLHealthData{
            if let fileU = localFileManager.getfile(fileName: fileN){
                fileURL = fileU
                showCsvFile()
            }else{
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: "File Error", message: "Initial Health data file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                    
                }
            }
        }else{
            DispatchQueue.main.async {
                self.presentAlert(withTitle: "File Error", message: "Initial Health data file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                
            }
        }
        
//        performSegue(withIdentifier: "ShowCSVFile", sender: self)
//        print("InitHealth")
    }
    @objc func openInitVehicleButtonPressed(sender: UIButton!){
        //set the selected url
        csvState = .initialVehicle
        selectedUrlIndex = sender.tag
        //perform segue to the preview
        if let fileN = URLOfData[selectedUrlIndex].initialVehicleData{
            if let fileU = localFileManager.getfile(fileName: fileN){
                fileURL = fileU
                showCsvFile()
            }else{
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: "File Error", message: "Initial CAN BUS data file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                    
                }
            }
        }else{
            DispatchQueue.main.async {
                self.presentAlert(withTitle: "File Error", message: "Initial CAN BUS data file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                
            }
        }
        
//        performSegue(withIdentifier: "ShowCSVFile", sender: self)
//        print("VehicleButton")
    }
    @objc func openSensorButtonPressed(sender: UIButton!){
        //set the selected url
        csvState = .initialVehicle
        selectedUrlIndex = sender.tag
        //perform segue to the preview
        if let fileN = URLOfData[selectedUrlIndex].sensorDataURL{
            if let fileU = localFileManager.getfile(fileName: fileN){
                fileURL = fileU
                showCsvFile()
            }else{
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: "File Error", message: "Sensor data file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                }
            }
        }else{
            DispatchQueue.main.async {
                self.presentAlert(withTitle: "File Error", message: "Sensor data file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
            }
        }
        
        
//        fileURL = URL(string: (URLOfData[selectedUrlIndex].sensorDataURL)!)
       
//        performSegue(withIdentifier: "ShowCSVFile", sender: self)
//        print("SensorButton")
    }
    
    
    @objc func previewButtonPressed(sender: UIButton!){
        //set the selected url
        selectedUrlIndex = sender.tag
        //perform segue to the preview
        performSegue(withIdentifier: "goToPreview", sender: self)
        print("Preview button pressed")
    }
    @objc func previewButtonPressed2(sender: UIButton!){
        //set the selected url
        camState = .frontcam
        selectedUrlIndex = sender.tag
        print(selectedUrlIndex as Any)
        if let fileN = URLOfData[selectedUrlIndex].driverMonitorURL{
            if localFileManager.retriveVid(fileName: fileN) != nil{
                performSegue(withIdentifier: "goToPreview", sender: self)
                print("Preview button pressed")
            }else{
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: "File Error", message: "Video file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                    
                }
            }
        }else {
            DispatchQueue.main.async {
                self.presentAlert(withTitle: "File Error", message: "Video file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                
            }
        }
        

//        perform segue to the preview
        
    }
    
    @objc func previewButtonPressed3(sender: UIButton!){
        //set the selected url
        camState = .backcam
        selectedUrlIndex = sender.tag
        print(selectedUrlIndex as Any)
        if let fileN = URLOfData[selectedUrlIndex].roadViewURL{
            if localFileManager.retriveVid(fileName: fileN) != nil{
                performSegue(withIdentifier: "goToPreview", sender: self)
                print("Preview button pressed")
            }else{
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: "File Error", message: "Video file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                    
                }
            }
        }else{
            DispatchQueue.main.async {
                self.presentAlert(withTitle: "File Error", message: "Video file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                
            }
        }
        

        
//        let url = URL(string: URLOfData[selectedUrlIndex].roadViewURL!)
//        perform segue to the preview
        
        
    }
    
    func verifyUrl (urlString: Int?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: URLOfData[urlString].driverMonitorURL!) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    //passes the url to the video playback controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.destination is VideoPlaybackViewController{
            let vc = segue.destination as? VideoPlaybackViewController
            switch camState{
            case .backcam:
                let fileN = URLOfData[selectedUrlIndex].roadViewURL
                let fileU = localFileManager.retriveVid(fileName: fileN!)
                print(fileU as Any)
                vc?.videoURL = fileU
                print("back")
            case .frontcam:
                let fileN = URLOfData[selectedUrlIndex].driverMonitorURL
                let fileU = localFileManager.retriveVid(fileName: fileN!)
                print(fileU as Any)
                vc?.videoURL = fileU
                print("front")
            }
            //get the view controller
            //set the values to be sent
//            URLOfData[indexPath.row].dateStored
//            let url = URL(string: (URLOfData[selectedUrlIndex].driverMonitorURL)!)
           
//            vc?.videoURL = urlArray[selectedUrlIndex]
        }
    }
    
    
    @objc func updateCells(){
        
        _ = tableView.indexPathsForVisibleRows
        loadDataFromDataStore(){ totalData in
            self.tableView.reloadData()
            print("reload")
        }
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! LibraryTableViewCell
    }
    
    
    
    
    @objc func uploadButtonPressed(sender: UIButton!){
        selectedUrlIndex = sender.tag
        if let fileN1 = URLOfData[selectedUrlIndex].driverMonitorURL,let fileN2 = URLOfData[selectedUrlIndex].roadViewURL,let fileN3 = URLOfData[selectedUrlIndex].initiaLHealthData,let fileN4 = URLOfData[selectedUrlIndex].initialVehicleData,let fileN5 = URLOfData[selectedUrlIndex].sensorDataURL,let fileN6 = URLOfData[selectedUrlIndex].dateStored{
            
            AllData.shared.dateStoredId = URLOfData[selectedUrlIndex].id
            let fileU1 = localFileManager.retriveVid(fileName: fileN1)
            let fileU2 = localFileManager.retriveVid(fileName: fileN2)
            let fileU3 = localFileManager.retriveVid(fileName: fileN3)
            let fileU4 = localFileManager.retriveVid(fileName: fileN4)
            let fileU5 = localFileManager.retriveVid(fileName: fileN5)
            amplifyVidUpload.specialUpload(url: fileU1!, videoName: fileU1!.lastPathComponent, saveLocation: fileN6)
            amplifyVidUpload.specialUpload(url: fileU2!, videoName: fileU2!.lastPathComponent, saveLocation: fileN6)
            amplifyVidUpload.sensorUpload(url: fileU3!, sensorName: fileU3!.lastPathComponent, saveLocation: fileN6)
            amplifyVidUpload.sensorUpload(url: fileU4!, sensorName: fileU4!.lastPathComponent, saveLocation: fileN6)
            amplifyVidUpload.sensorUpload(url: fileU5!, sensorName: fileU5!.lastPathComponent, saveLocation: fileN6)
            
            
            
           
//            if let tabBarController = self.window.rootViewController as? UITabBarController {
//                   tabBarController.selectedIndex = 3
//               }
            //remove file from amplifyDataStore
//            amplifyVidUpload.deleteWallet(id: URLOfData[selectedUrlIndex].id)
            loadDataFromDataStore(){ totalData in
                self.URLOfData = totalData
                print("this is data after upload", totalData)
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.presentAlert(withTitle: "Upload Started", message: "Video upload and data upload has been started, navigate to the upload tab to monitor the progress.", actions: ["OK" : UIAlertAction.Style.default])
            }
            DispatchQueue.main.async {
                self.tabBarController?.selectedIndex = 2
            }
            
        }else{
            DispatchQueue.main.async {
                self.presentAlert(withTitle: "File Error", message: "file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
                
            }
        }
//        //the current date
//        let dateFormatter : DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy_MMM_dd_HH_mm_ss"
//        let date = Date()
//        let dateString = dateFormatter.string(from: date)
//        //name of the video
//        let nameString = urlArray[sender.tag].lastPathComponent
//        //create the progress view
//        let progressView = UIProgressView()
//        //save the video to firebase and pass the data
//        firebaseManager.saveVideo(url: urlArray[sender.tag], videoName: nameString, saveLocation: AllData.shared.name, progressView: progressView)
//        //now we also want to retrieve
//        firebaseManager.saveSensorData(saveLocation: dateString, sensorDataArray: defaultManager.getSensorDataArray(videoName: urlArray[sender.tag].lastPathComponent)  , videoName: urlArray[sender.tag].lastPathComponent , videoID: 0)
        print("Upload button pressed")
        
        
        
    }

    //Code that executes when the cancel button is pressed for each cell
    @objc func deleteButtonPressed(sender: UIButton!){
        //remove the url and the contents
        selectedUrlIndex = sender.tag
        if let fileN1 = URLOfData[selectedUrlIndex].driverMonitorURL,let fileN2 = URLOfData[selectedUrlIndex].roadViewURL,let fileN3 = URLOfData[selectedUrlIndex].initiaLHealthData,let fileN4 = URLOfData[selectedUrlIndex].initialVehicleData,let fileN5 = URLOfData[selectedUrlIndex].sensorDataURL {
            
            let fileU1 = localFileManager.retriveVid(fileName: fileN1)
            let fileU2 = localFileManager.retriveVid(fileName: fileN2)
            let fileU3 = localFileManager.retriveVid(fileName: fileN3)
            let fileU4 = localFileManager.retriveVid(fileName: fileN4)
            let fileU5 = localFileManager.retriveVid(fileName: fileN5)
            localFileManager.deleteFile(fileUrl: fileU1!)
            localFileManager.deleteFile(fileUrl: fileU2!)
            localFileManager.deleteFile(fileUrl: fileU3!)
            localFileManager.deleteFile(fileUrl: fileU4!)
            localFileManager.deleteFile(fileUrl: fileU5!)
            //remove file from amplifyDataStore
            amplifyVidUpload.deleteWallet(id: URLOfData[selectedUrlIndex].id)
            loadDataFromDataStore(){ totalData in
                self.URLOfData = totalData
                print("this is data after upload", totalData)
                self.tableView.dataSource = self
                self.tableView.reloadData()
                self.presentAlert(withTitle: "File Deleted", message: "File deleted succesfully.", actions: ["OK" : UIAlertAction.Style.default])
            }
            
        }else{
            DispatchQueue.main.async {
            self.presentAlert(withTitle: "File Error", message: "file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
            }
        }
        
        
        
//        //remove the sensor data array that was saved
//        defaultManager.removeSensorDataArray(videoName: urlArray[sender.tag].lastPathComponent)
//        //remove from local array
//        urlArray.remove(at: sender.tag)
        //reload amplifyDataStore
        loadDataFromDataStore(){ totalData in
            //reload the table view
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return urlArray.count
        return URLOfData.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Library"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //gets the cell and sets it to the custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "libraryCell", for: indexPath) as! LibraryTableViewCell
        
        //        //Adds a target for when the buttons are pressed, the selector is going to another function
                cell.previewButton.addTarget(self, action: #selector(previewButtonPressed3(sender:)), for: UIControl.Event.touchUpInside)
                cell.driverMOnitorPreButtonOulet.addTarget(self, action: #selector(previewButtonPressed2(sender:)), for: UIControl.Event.touchUpInside)
                cell.sensorDataButOpenLabel.addTarget(self, action: #selector(openSensorButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
                cell.healthDataButtonLabel.addTarget(self, action: #selector(openInitHealthButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
                cell.obdDataOpenButtonLabel.addTarget(self, action: #selector(openInitVehicleButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
                cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
                cell.uploadButton.addTarget(self, action: #selector(uploadButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
        
        
        if URLOfData[indexPath.row].uploadStatus != nil {
//            print(uploadtStat)
            //        //set the upload tag
            cell.uploadButton.tag = indexPath.row
    //        //set the delete tag
            cell.deleteButton.tag = indexPath.row
    //        set the preview tag
            cell.previewButton.tag = indexPath.row
            cell.driverMOnitorPreButtonOulet.tag = indexPath.row
            cell.sensorDataButOpenLabel.tag = indexPath.row
            cell.healthDataButtonLabel.tag = indexPath.row
            cell.obdDataOpenButtonLabel.tag = indexPath.row
            cell.uploadButton.setTitle("Uploaded", for: .normal)
            cell.uploadButton.isEnabled = false
//            cell.uploadButton.titleLabel?.text = "Uploaded"
        }else{
//            print("upload")
    //        //set the upload tag
            cell.uploadButton.tag = indexPath.row
    //        //set the delete tag
            cell.deleteButton.tag = indexPath.row
    //        set the preview tag
            cell.previewButton.tag = indexPath.row
            cell.driverMOnitorPreButtonOulet.tag = indexPath.row
            cell.sensorDataButOpenLabel.tag = indexPath.row
            cell.healthDataButtonLabel.tag = indexPath.row
            cell.obdDataOpenButtonLabel.tag = indexPath.row
            cell.uploadButton.setTitle("Upload", for: .normal)
            cell.uploadButton.isEnabled = true
        }
        
    
        

//        // Configure the cell...
//        cell.nameOfVideoLabel.text = urlArray[indexPath.row].lastPathComponent
//        cell.creationDateLabel.text = localFileManager.getCreationDate(fileUrl: urlArray[indexPath.row])
//        cell.sizeOfVideoLabel.text = localFileManager.getFileSize(fileUrl: urlArray[indexPath.row]) + " MB"
        
        cell.dateDataCollected.text = URLOfData[indexPath.row].dateStored
        cell.creationDateLabel.text = URLOfData[indexPath.row].dateStored
        //newcells
    
        //return the cell
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 530
    }
    
//    func loadLocalData()->[DateStored]{
//
//    }

    func loadDataFromDataStore(completion: @escaping ([DateStored]) -> Void){
        Amplify.DataStore.query(DateStored.self, sort: .descending(DateStored.keys.dateStored)) {
            switch $0 {
            case .success(let result):
                
//                self.URLOfData = result
                
                completion(result)
            case .failure(let error):
                print("Error listing posts - \(error.localizedDescription)")
            }
        }
    }
    func observeData(){
       observationToken = Amplify.DataStore.publisher(for: DateStored.self).sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            },
            receiveValue: { changes in
//                guard let data = try? changes.decodeModel(as: DateStored.self) else{ return}
                    
                switch changes.mutationType {
                case "create":
//                    self.URLOfData.append(data)
                    print("new entry into datastore")
                    self.loadDataFromDataStore{ result in
                        self.URLOfData = result
                        self.tableView.reloadData()
                    }
                case "update":
                    print("update into datastore")
                    self.loadDataFromDataStore{ result in
                        self.URLOfData = result
                        self.tableView.reloadData()
                    }
                case "delete":
                    self.loadDataFromDataStore{ result in
                        self.URLOfData = result
                        self.tableView.reloadData()
                    }
//                    if let index = self.URLOfData.firstIndex(where: { $0.id == data.id}) {
//                        self.URLOfData.remove(at: index)
//                    }
                    break
                    
                default:
                    break
                }
            }
        )
    }
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = fileURL
        return url! as QLPreviewItem
    }
    
    func showCsvFile(){
        let preview = QLPreviewController()
        preview.dataSource = self
        self.present(preview, animated: true, completion: nil)
    }

}
