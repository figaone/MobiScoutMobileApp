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



class LibraryTableTableViewController: UIViewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LibraryCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        //loadURLS from dataStore
//        tableView.register(UINib(nibName: "LibraryTableViewCell", bundle: nil), forCellReuseIdentifier: "libraryCell")
        loadDataFromDataStore(){ totalData in
            print(self.URLOfData.count)
        }
        amplifyVidUpload.observeDataStore()
       
        
//        observeData()
        
        //after loading reload the table view
        //set the intital values for the table
        tableView.allowsSelection = false
        
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 600
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
        loadDataFromDataStore(){ totalData in
           print("view will appeared")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadDataFromDataStore(){ totalData in
            print("view did appeared")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loadDataFromDataStore(){ totalData in
            print("view did appeared")
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
    
    
    //Code that executes when the preview button is pressed for each cell
    @objc func openInitHealthButtonPressed(sender: UIButton!){
        //set the selected url
        csvState = .initialHealth
        selectedUrlIndex = sender.tag
        //perform segue to the preview
        if let fileN = URLOfData[selectedUrlIndex].initiaLHealthData{
            
            if let fileU = localFileManager.getfile(fileName: fileN){
                if FileManager.default.fileExists(atPath: fileU.path) {
                    fileURL = fileU
                    showCsvFile()
                }else{
                    DispatchQueue.main.async {
                        self.presentAlert(withTitle: "File Error", message: "Initial Health data has been uploaded already and has been deleted.", actions: ["OK" : UIAlertAction.Style.default])
                        
                    }
                }
               
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
                if FileManager.default.fileExists(atPath: fileU.path) {
                    fileURL = fileU
                    showCsvFile()
                }else{
                    DispatchQueue.main.async {
                        self.presentAlert(withTitle: "File Error", message: "Initial CAN BUS data has been uploaded already and has been deleted.", actions: ["OK" : UIAlertAction.Style.default])
                        
                    }
                }
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
        if URLOfData.count > 0{
            csvState = .initialVehicle
            selectedUrlIndex = sender.tag
            //perform segue to the preview
            if let fileN = URLOfData[selectedUrlIndex].sensorDataURL{
                if let fileU = localFileManager.getfile(fileName: fileN){
                    if FileManager.default.fileExists(atPath: fileU.path) {
                        fileURL = fileU
                        showCsvFile()
                    }else{
                        DispatchQueue.main.async {
                            self.presentAlert(withTitle: "File Error", message: "Initial Sensor data has been uploaded already and has been deleted.", actions: ["OK" : UIAlertAction.Style.default])
                            
                        }
                    }
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
            
        }
        
        
//        fileURL = URL(string: (URLOfData[selectedUrlIndex].sensorDataURL)!)
       
//        performSegue(withIdentifier: "ShowCSVFile", sender: self)
//        print("SensorButton")
    }
    
    
    @objc func previewButtonPressed(sender: UIButton!){
        //set the selected url
        if URLOfData.count > 0{
            selectedUrlIndex = sender.tag
            //perform segue to the preview
            performSegue(withIdentifier: "goToPreview", sender: self)
            print("Preview button pressed")
        }
        
    }
    @objc func previewButtonPressed2(sender: UIButton!){
        //set the selected url
        if URLOfData.count > 0{
            camState = .frontcam
            selectedUrlIndex = sender.tag
            print(selectedUrlIndex as Any)
            if let fileN = URLOfData[selectedUrlIndex].driverMonitorURL{
                if let fileU = localFileManager.retriveVid(fileName: fileN){
                    if FileManager.default.fileExists(atPath: fileU.path) {
                        performSegue(withIdentifier: "goToPreview", sender: self)
                        print("Preview button pressed")
                    }else{
                        DispatchQueue.main.async {
                            self.presentAlert(withTitle: "File Error", message: "DriverMonitor video data has been uploaded already and has been deleted.", actions: ["OK" : UIAlertAction.Style.default])
                            
                        }
                    }
                    
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
            
        }
        

//        perform segue to the preview
        
    }
    
    @objc func previewButtonPressed3(sender: UIButton!){
        //set the selected url
        if URLOfData.count > 0{
            camState = .backcam
            selectedUrlIndex = sender.tag
            print(selectedUrlIndex as Any)
            if let fileN = URLOfData[selectedUrlIndex].roadViewURL{
                if let fileU = localFileManager.retriveVid(fileName: fileN){
                    if FileManager.default.fileExists(atPath: fileU.path) {
                        performSegue(withIdentifier: "goToPreview", sender: self)
                        print("Preview button pressed")
                    }else{
                        DispatchQueue.main.async {
                            self.presentAlert(withTitle: "File Error", message: "RoadView video data has been uploaded already and has been deleted.", actions: ["OK" : UIAlertAction.Style.default])
                            
                        }
                    }
                    
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
            print("This is the id : \(URLOfData[selectedUrlIndex].id)")
            let fileU1 = localFileManager.retriveVid(fileName: fileN1)
            let fileU2 = localFileManager.retriveVid(fileName: fileN2)
            let fileU3 = localFileManager.retriveVid(fileName: fileN3)
            let fileU4 = localFileManager.retriveVid(fileName: fileN4)
            let fileU5 = localFileManager.retriveVid(fileName: fileN5)
            amplifyVidUpload.specialUpload(url: fileU1!, fileName: fileU1!.lastPathComponent, saveLocation: fileN6, contentType: "video/mp4")
            amplifyVidUpload.specialUpload(url: fileU2!, fileName: fileU2!.lastPathComponent, saveLocation: fileN6, contentType: "video/mp4")
            amplifyVidUpload.specialUpload(url: fileU3!, fileName: fileU3!.lastPathComponent, saveLocation: fileN6, contentType: "test/csv")
            amplifyVidUpload.specialUpload(url: fileU4!, fileName: fileU4!.lastPathComponent, saveLocation: fileN6, contentType: "test/csv")
            amplifyVidUpload.specialUpload(url: fileU5!, fileName: fileU5!.lastPathComponent, saveLocation: fileN6, contentType: "test/csv")
//            amplifyVidUpload.sensorUpload(url: fileU3!, sensorName: fileU3!.lastPathComponent, saveLocation: fileN6)
//            amplifyVidUpload.sensorUpload(url: fileU4!, sensorName: fileU4!.lastPathComponent, saveLocation: fileN6)
//            amplifyVidUpload.sensorUpload(url: fileU5!, sensorName: fileU5!.lastPathComponent, saveLocation: fileN6)
            
            
            
           
//            if let tabBarController = self.window.rootViewController as? UITabBarController {
//                   tabBarController.selectedIndex = 3
//               }
            //remove file from amplifyDataStore
//            amplifyVidUpload.deleteWallet(id: URLOfData[selectedUrlIndex].id)
            loadDataFromDataStore(){ totalData in
                DispatchQueue.main.async {
                    self.presentAlert(withTitle: "Upload Started", message: "Video upload and data upload has been started", actions: ["OK" : UIAlertAction.Style.default])
                }
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
        if URLOfData.count > 0 {
            let point = sender.convert(CGPoint.zero, to: tableView)
            guard let indexpath = tableView.indexPathForRow(at: point) else {return}
            let urls = URLOfData[indexpath.row]
    //        if let fileN1 = urls.driverMonitorURL
            //,let fileN2 = urls.roadViewURL,let fileN3 = urls.initiaLHealthData,let fileN4 = urls.initialVehicleData,let fileN5 = urls.sensorDataURL {
            if let fileU1 = localFileManager.retriveVid(fileName: urls.driverMonitorURL ?? ""){
                if FileManager.default.fileExists(atPath: fileU1.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileU1.path)
                        print("file removed at url: \(fileU1.path)")
                    } catch {
                        print("Could not remove file at url: \(fileU1.path)")
                    }
                }
            }
            if let fileU1 = localFileManager.retriveVid(fileName: urls.roadViewURL ?? ""){
                if FileManager.default.fileExists(atPath: fileU1.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileU1.path)
                        print("file removed at url: \(fileU1.path)")
                    } catch {
                        print("Could not remove file at url: \(fileU1.path)")
                    }
                }
            }
            if let fileU1 = localFileManager.retriveVid(fileName: urls.sensorDataURL ?? ""){
                if FileManager.default.fileExists(atPath: fileU1.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileU1.path)
                        print("file removed at url: \(fileU1.path)")
                    } catch {
                        print("Could not remove file at url: \(fileU1.path)")
                    }
                }
            }
            if let fileU1 = localFileManager.retriveVid(fileName: urls.initiaLHealthData ?? ""){
                if FileManager.default.fileExists(atPath: fileU1.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileU1.path)
                        print("file removed at url: \(fileU1.path)")
                    } catch {
                        print("Could not remove file at url: \(fileU1.path)")
                    }
                }
            }
            if let fileU1 = localFileManager.retriveVid(fileName: urls.initialVehicleData ?? ""){
                if FileManager.default.fileExists(atPath: fileU1.path) {
                    do {
                        try FileManager.default.removeItem(atPath: fileU1.path)
                        print("file removed at url: \(fileU1.path)")
                    } catch {
                        print("Could not remove file at url: \(fileU1.path)")
                    }
                }
            }
          amplifyVidUpload.deleteWallet(id: URLOfData[indexpath.row].id)
          self.URLOfData.remove(at: indexpath.row)
          tableView.beginUpdates()
          tableView.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .left)
          tableView.endUpdates()
        }
        
      
//        print(self.URLOfData)
//        selectedUrlIndex = sender.tag
//        print(selectedUrlIndex as Any)
//        self.URLOfData.remove(at: selectedUrlIndex)
//        print(self.URLOfData)
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//        let urls = URLOfData[selectedUrlIndex]
//        if let fileN1 = urls.driverMonitorURL,let fileN2 = urls.roadViewURL,let fileN3 = urls.initiaLHealthData,let fileN4 = urls.initialVehicleData,let fileN5 = urls.sensorDataURL {
//
//            let fileU1 = localFileManager.retriveVid(fileName: fileN1)
//            let fileU2 = localFileManager.retriveVid(fileName: fileN2)
//            let fileU3 = localFileManager.retriveVid(fileName: fileN3)
//            let fileU4 = localFileManager.retriveVid(fileName: fileN4)
//            let fileU5 = localFileManager.retriveVid(fileName: fileN5)
//            localFileManager.deleteFile(fileUrl: fileU1!)
//            localFileManager.deleteFile(fileUrl: fileU2!)
//            localFileManager.deleteFile(fileUrl: fileU3!)
//            localFileManager.deleteFile(fileUrl: fileU4!)
//            localFileManager.deleteFile(fileUrl: fileU5!)
//            //remove file from amplifyDataStore
//            amplifyVidUpload.deleteWallet(id: URLOfData[selectedUrlIndex].id)
//            DispatchQueue.main.async {
//                self.URLOfData.remove(at: sender.tag)
//                self.loadDataFromDataStore(){ totalData in
//                    print("success")
//                self.presentAlert(withTitle: "File Deleted", message: "File deleted succesfully.", actions: ["OK" : UIAlertAction.Style.default])
//                }
//            }
//        }else{
//            DispatchQueue.main.async {
//                self.URLOfData.remove(at: sender.tag)
//                self.loadDataFromDataStore(){ totalData in
//                    print("success")
//                }
//            self.presentAlert(withTitle: "File Error", message: "file is unavailable.", actions: ["OK" : UIAlertAction.Style.default])
//            }
//        }
//
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//
//
////        //remove the sensor data array that was saved
////        defaultManager.removeSensorDataArray(videoName: urlArray[sender.tag].lastPathComponent)
////        //remove from local array
////        urlArray.remove(at: sender.tag)
//        //reload amplifyDataStore
////        loadDataFromDataStore(){ totalData in
////            //reload the table view
////            DispatchQueue.main.async {
////                self.tableView.reloadData()
////            }
////
////        }
//
    }
    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
////        return urlArray.count
//        return URLOfData.count
//    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Library"
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //gets the cell and sets it to the custom cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! LibraryCell
//
//
//       if let fileU1 = localFileManager.retriveVid(fileName: URLOfData[indexPath.row].driverMonitorURL ?? ""),
//        let fileU2 = localFileManager.retriveVid(fileName: URLOfData[indexPath.row].roadViewURL ?? ""),
//        let fileU3 = localFileManager.retriveVid(fileName: URLOfData[indexPath.row].initiaLHealthData ?? ""),
//        let fileU4 = localFileManager.retriveVid(fileName: URLOfData[indexPath.row].initialVehicleData ?? ""),
//          let fileU5 = localFileManager.retriveVid(fileName: URLOfData[indexPath.row].sensorDataURL ?? ""){
//
//           //        //set the upload tag
//                   cell.uploadButton.tag = indexPath.row
//           //        //set the delete tag
//                   cell.deleteButton.tag = indexPath.row
//           //        set the preview tag
//                   cell.previewButton.tag = indexPath.row
//                   cell.driverMOnitorPreButtonOulet.tag = indexPath.row
//                   cell.sensorDataButOpenLabel.tag = indexPath.row
//                   cell.healthDataButtonLabel.tag = indexPath.row
//                   cell.obdDataOpenButtonLabel.tag = indexPath.row
//
//
//           if !FileManager.default.fileExists(atPath: fileU1.path) &&  !FileManager.default.fileExists(atPath: fileU2.path) && !FileManager.default.fileExists(atPath: fileU3.path) && !FileManager.default.fileExists(atPath: fileU4.path) && !FileManager.default.fileExists(atPath: fileU5.path){
//                      DispatchQueue.main.async {
//                          self.amplifyVidUpload.deleteWallet(id: self.URLOfData[indexPath.row].id)
//                          self.URLOfData.remove(at: indexPath.row)
//                          self.tableView.reloadData()
//                      }
//                  }else{
//                      cell.dateDataCollected.text = URLOfData[indexPath.row].dateStored
//                      cell.creationDateLabel.text = URLOfData[indexPath.row].dateStored
//                      if !FileManager.default.fileExists(atPath: fileU1.path){
//                          DispatchQueue.main.async {
//          //                            cell.driverMonitorVideoLabel.isHidden = true
//          //                            cell.driverMOnitorPreButtonOulet.isHidden = true
//                              cell.driverMonitorStackCell.tag = indexPath.row
//                              cell.driverMonitorStackCell.isHidden = true
//                          }
//                      }else{
//                          cell.driverMonitorStackCell.isHidden = false
//                      }
//                      if !FileManager.default.fileExists(atPath: fileU2.path){
//                          DispatchQueue.main.async {
//          //                            cell.previewButton.isHidden = true
//          //                            cell.nameOfVideoLabel.isHidden = true
//                              cell.roadViewStackCell.isHidden = true
//                          }
//                      }else{
//                          cell.roadViewStackCell.isHidden = false
//                      }
//                      if !FileManager.default.fileExists(atPath: fileU3.path){
//                          DispatchQueue.main.async {
//          //                            cell.healthDataButtonLabel.isHidden = true
//          //                            cell.healthDataLabel.isHidden = true
//                              cell.healthDataStackCell.isHidden = true
//                          }
//                      }else{
//                          cell.healthDataStackCell.isHidden = false
//                      }
//                      if !FileManager.default.fileExists(atPath: fileU4.path){
//                          DispatchQueue.main.async {
//          //                            cell.obdDataOpenButtonLabel.isHidden = true
//          //                            cell.obdDataLabel.isHidden = true
//                              cell.obdDataStackCell.isHidden = true
//                          }
//                      }else{
//                          cell.obdDataStackCell.isHidden = false
//                      }
//                      if !FileManager.default.fileExists(atPath: fileU5.path){
//                          DispatchQueue.main.async {
//          //                            cell.sensorDataLabel.isHidden = true
//          //                            cell.sensorDataButOpenLabel.isHidden = true
//                              cell.sensorDataStackCell.isHidden = true
//                          }
//                      }else{
//                          cell.sensorDataStackCell.isHidden = false
//                      }
//                  }
//          //        //Adds a target for when the buttons are pressed, the selector is going to another function
//                  cell.previewButton.addTarget(self, action: #selector(previewButtonPressed3(sender:)), for: UIControl.Event.touchUpInside)
//                  cell.driverMOnitorPreButtonOulet.addTarget(self, action: #selector(previewButtonPressed2(sender:)), for: UIControl.Event.touchUpInside)
//                  cell.sensorDataButOpenLabel.addTarget(self, action: #selector(openSensorButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
//                  cell.healthDataButtonLabel.addTarget(self, action: #selector(openInitHealthButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
//                  cell.obdDataOpenButtonLabel.addTarget(self, action: #selector(openInitVehicleButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
//                  cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
//                  cell.uploadButton.addTarget(self, action: #selector(uploadButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
//
//       }
//
//
//
////
////        if FileManager.default.fileExists(atPath: fileU1!.path) &&  FileManager.default.fileExists(atPath: fileU2!.path) && FileManager.default.fileExists(atPath: fileU3!.path) && FileManager.default.fileExists(atPath: fileU4!.path) && FileManager.default.fileExists(atPath: fileU5!.path){
////         //        //set the upload tag
////                 cell.uploadButton.tag = indexPath.row
////         //        //set the delete tag
////                 cell.deleteButton.tag = indexPath.row
////         //        set the preview tag
////                 cell.previewButton.tag = indexPath.row
////                 cell.driverMOnitorPreButtonOulet.tag = indexPath.row
////                 cell.sensorDataButOpenLabel.tag = indexPath.row
////                 cell.healthDataButtonLabel.tag = indexPath.row
////                 cell.obdDataOpenButtonLabel.tag = indexPath.row
////                 cell.uploadButton.setTitle("Upload", for: .normal)
////                 cell.uploadButton.isEnabled = true
////                 cell.sizeOfVideoLabel.isHidden = true
////        }else if  FileManager.default.fileExists(atPath: fileU1!.path) ||  FileManager.default.fileExists(atPath: fileU2!.path) || FileManager.default.fileExists(atPath: fileU3!.path) || FileManager.default.fileExists(atPath: fileU4!.path) || FileManager.default.fileExists(atPath: fileU5!.path){
////            if FileManager.default.fileExists(atPath: fileU1!.path){
////                cell.driverMOnitorPreButtonOulet.tag = indexPath.row
////                cell.uploadButton.tag = indexPath.row
////                cell.sizeOfVideoLabel.isHidden = true
////                print("drivermonitor exists")
////            }else{
////                cell.driverMonitorVideoLabel.isHidden = true
////                cell.driverMOnitorPreButtonOulet.isHidden = true
////                cell.sizeOfVideoLabel.isHidden = true
////            }
////            if FileManager.default.fileExists(atPath: fileU2!.path){
////                cell.previewButton.tag = indexPath.row
////                cell.uploadButton.tag = indexPath.row
////                cell.sizeOfVideoLabel.isHidden = true
////                print("roadview exists")
////            }else{
////                cell.previewButton.isHidden = true
////                cell.nameOfVideoLabel.isHidden = true
////                cell.sizeOfVideoLabel.isHidden = true
////            }
////            if FileManager.default.fileExists(atPath: fileU3!.path){
////                cell.healthDataButtonLabel.tag = indexPath.row
////                cell.uploadButton.tag = indexPath.row
////                cell.sizeOfVideoLabel.isHidden = true
////                print("healthdata exists")
////            }else{
////                cell.healthDataButtonLabel.isHidden = true
////                cell.healthDataLabel.isHidden = true
////                cell.sizeOfVideoLabel.isHidden = true
////            }
////            if FileManager.default.fileExists(atPath: fileU4!.path){
////                cell.obdDataOpenButtonLabel.tag = indexPath.row
////                cell.uploadButton.tag = indexPath.row
////                cell.sizeOfVideoLabel.isHidden = true
////                print("obd data exists")
////            }else{
////                cell.obdDataOpenButtonLabel.isHidden = true
////                cell.obdDataLabel.isHidden = true
////                cell.sizeOfVideoLabel.isHidden = true
////            }
////            if FileManager.default.fileExists(atPath: fileU5!.path){
////                cell.sensorDataButOpenLabel.tag = indexPath.row
////                cell.uploadButton.tag = indexPath.row
////                cell.sizeOfVideoLabel.isHidden = true
////                print("sensor data exists")
////            }else{
////                cell.sensorDataLabel.isHidden = true
////                cell.sensorDataButOpenLabel.isHidden = true
////                cell.sizeOfVideoLabel.isHidden = true
////            }
////        }else{
////            amplifyVidUpload.deleteWallet(id: URLOfData[indexPath.row].id)
////        }
//
//
////        if URLOfData[indexPath.row].uploadStatus != nil {
//
////            print(uploadtStat)
//            //        //set the upload tag
//
////            cell.uploadButton.tag = indexPath.row
////    //        //set the delete tag
////            cell.deleteButton.tag = indexPath.row
////    //        set the preview tag
////            cell.previewButton.tag = indexPath.row
////
////            cell.driverMOnitorPreButtonOulet.tag = indexPath.row
////            cell.sensorDataButOpenLabel.tag = indexPath.row
////            cell.healthDataButtonLabel.tag = indexPath.row
////            cell.obdDataOpenButtonLabel.tag = indexPath.row
//////            cell.uploadButton.setTitle("Upload", for: .normal)
//////            cell.uploadButton.isEnabled = true
////        cell.sizeOfVideoLabel.tag = indexPath.row
//
//
//
//
//
//
//
//
//
////            let dataUrl = localFileManager.retriveVid(fileName: URLOfData[indexPath.row].driverMonitorURL!)
////            if FileManager.default.fileExists(atPath: dataUrl!.path) {
////                cell.previewButton.tag = indexPath.row
////                cell.sizeOfVideoLabel.text = localFileManager.getFileSize(fileUrl: dataUrl!) + " MB"
////            }else{
////                cell.previewButton.isHidden = true
////                cell.nameOfVideoLabel.isHidden = true
////            }
////            if let fileU1 = localFileManager.retriveVid(fileName: URLOfData[indexPath.row].driverMonitorURL!){
////                cell.sizeOfVideoLabel.text = localFileManager.getFileSize(fileUrl: fileU1) + " MB"
////            }
//
////            cell.uploadButton.titleLabel?.text = "Uploaded"
//////        }else{
//////            print("upload")
////    //        //set the upload tag
////            cell.uploadButton.tag = indexPath.row
////    //        //set the delete tag
////            cell.deleteButton.tag = indexPath.row
////    //        set the preview tag
////            cell.previewButton.tag = indexPath.row
////            cell.driverMOnitorPreButtonOulet.tag = indexPath.row
////            cell.sensorDataButOpenLabel.tag = indexPath.row
////            cell.healthDataButtonLabel.tag = indexPath.row
////            cell.obdDataOpenButtonLabel.tag = indexPath.row
////            cell.uploadButton.setTitle("Upload", for: .normal)
////            cell.uploadButton.isEnabled = true
////            cell.sizeOfVideoLabel.isHidden = true
////        }
//
//
//
//
////        // Configure the cell...
////        cell.nameOfVideoLabel.text = urlArray[indexPath.row].lastPathComponent
////        cell.creationDateLabel.text = localFileManager.getCreationDate(fileUrl: urlArray[indexPath.row])
////        cell.sizeOfVideoLabel.text = localFileManager.getFileSize(fileUrl: urlArray[indexPath.row]) + " MB"
//
//
//        //newcells
//
//        //return the cell
//        return cell
//    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 530
//    }
    
//    func loadLocalData()->[DateStored]{
//
//    }

    func loadDataFromDataStore(completion: @escaping ([DateStored]) -> Void){
        Amplify.DataStore.query(DateStored.self, sort: .descending(DateStored.keys.createdAt)) {
            self.URLOfData = []
            switch $0 {
            case .success(let result):
                self.URLOfData = result
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
//                for data in result{
//                    self.URLOfData.append(data)
//                    print("This is URL Data:",URLOfData)
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                        if self.URLOfData.count > 0 {
//                            let indexPath = IndexPath(row: 0, section: 0)
//                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                        }
//
//                    }
//                }
                
                print("this is the data")
                print(result)
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

extension LibraryTableTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if URLOfData.count == 0 {
                self.tableView.setEmptyMessage("There is no data")
            } else {
                self.tableView.restore()
            }
        
        return URLOfData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let urls = URLOfData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! LibraryCell
        let fileU1 = localFileManager.retriveVid(fileName: urls.driverMonitorURL ?? "")
        let fileU2 = localFileManager.retriveVid(fileName: urls.roadViewURL ?? "")
        let fileU3 = localFileManager.retriveVid(fileName: urls.initiaLHealthData ?? "")
        let fileU4 = localFileManager.retriveVid(fileName: urls.initialVehicleData ?? "")
        let fileU5 = localFileManager.retriveVid(fileName: urls.sensorDataURL ?? "")
        
        if !FileManager.default.fileExists(atPath: fileU1?.path ?? "") &&  !FileManager.default.fileExists(atPath: fileU2?.path ?? "") && !FileManager.default.fileExists(atPath: fileU3?.path ?? "") && !FileManager.default.fileExists(atPath: fileU4?.path ?? "") && !FileManager.default.fileExists(atPath: fileU5?.path ?? ""){
              DispatchQueue.main.async {
                  self.amplifyVidUpload.deleteWallet(id: self.URLOfData[indexPath.row].id)
                  self.URLOfData.remove(at: indexPath.row)
                  tableView.beginUpdates()
                  tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .left)
                  tableView.endUpdates()
                  self.loadDataFromDataStore { result in
                      print(result)
                  }
              }
        }else{
            let urls = URLOfData[indexPath.row]
     //        //set the upload tag
            cell.driverMOnitorPreButtonOulet.tag = indexPath.row
            cell.uploadButton.tag = indexPath.row
     //        //set the delete tag
            cell.deleteButton.tag = indexPath.row
     //        set the preview tag
            cell.previewButton.tag = indexPath.row
            cell.driverMOnitorPreButtonOulet.tag = indexPath.row
            cell.sensorDataButOpenLabel.tag = indexPath.row
            cell.healthDataButtonLabel.tag = indexPath.row
            cell.obdDataOpenButtonLabel.tag = indexPath.row
            cell.dateDataCollected.text = urls.dateStored
            cell.creationDateLabel.text = urls.dateStored
        if !FileManager.default.fileExists(atPath: fileU1?.path ?? ""){
            cell.driverMonitorStackCell.isHidden = true
          }else{
            cell.driverMonitorStackCell.isHidden = false
          }
          if !FileManager.default.fileExists(atPath: fileU2?.path ?? ""){
                  cell.roadViewStackCell.isHidden = true
          }else{
              cell.roadViewStackCell.isHidden = false
          }
          if !FileManager.default.fileExists(atPath: fileU3?.path ?? ""){
               cell.healthDataStackCell.isHidden = true
             
          }else{
              cell.healthDataStackCell.isHidden = false
          }
          if !FileManager.default.fileExists(atPath: fileU4?.path ?? ""){
                  cell.obdDataStackCell.isHidden = true
              
          }else{
              cell.obdDataStackCell.isHidden = false
          }
          if !FileManager.default.fileExists(atPath: fileU5?.path ?? ""){
                  cell.sensorDataStackCell.isHidden = true
          }else{
              cell.sensorDataStackCell.isHidden = false
          }
        }
        
//    Adds a target for when the buttons are pressed, the selector is going to another function
      cell.previewButton.addTarget(self, action: #selector(previewButtonPressed3(sender:)), for: UIControl.Event.touchUpInside)
      cell.driverMOnitorPreButtonOulet.addTarget(self, action: #selector(previewButtonPressed2(sender:)), for: UIControl.Event.touchUpInside)
      cell.sensorDataButOpenLabel.addTarget(self, action: #selector(openSensorButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
      cell.healthDataButtonLabel.addTarget(self, action: #selector(openInitHealthButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
      cell.obdDataOpenButtonLabel.addTarget(self, action: #selector(openInitVehicleButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
      cell.deleteButton.addTarget(self, action: #selector(deleteButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
      cell.uploadButton.addTarget(self, action: #selector(uploadButtonPressed(sender:)), for: UIControl.Event.touchUpInside)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Library"
    }
    
    
    
}
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
