//
//  AmplifyDataUpload.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 11/14/21.
//

import Foundation
import Amplify
import AWSS3

public class AmplifyDataUpload{
    var fileStatus:String = ""
    
    let allData = AllData.shared
    
    
    func uploadFile() {
        let fileKey = "testFile.txt"
        let fileContents = "This is my dummy file"
        let fileData = fileContents.data(using: .utf8)!
        
        Amplify.Storage.uploadData(key: fileKey, data: fileData) {[weak self] result in
            
            switch result {
            case .success(let key):
                print("file with key \(key) uploaded")
                
                DispatchQueue.main.async {
                    self?.fileStatus = "File Uploaded"
                }
                
            case .failure(let storageError):
                print("Failed to upload file", storageError)
            }
            
        }
    }
    
    func uploadData() {
        let dataString = "Example file contents"
        let data = dataString.data(using: .utf8)!
        Amplify.Storage.uploadData(key: "ExampleKey", data: data,
            progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { (event) in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        })
    }
    
    func uploadVideo(url : URL, videoName: String, saveLocation: String, progressView: UIProgressView){
        _ = Amplify.Auth.getCurrentUser()?.userId
        let videoData = NSData(contentsOf: url as URL)
        Amplify.Storage.uploadData(key: "video1", data: videoData! as Data,
            progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { (event) in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        })
    }
    
    func specialUpload(url : URL, videoName: String, saveLocation: String){
//        let userID = Amplify.Auth.getCurrentUser()?.userId
//        let options = StorageUploadDataRequest.Options(accessLevel: .protected, contentType: "video/mp4")
//        let vidlocation = "\(saveLocation)/\(videoName)"
//        Amplify.Storage.uploadFile(key: "\(saveLocation)/\(videoName)", local: url, options: .init(accessLevel: .protected,  contentType: "video/mp4"), progressListener: { progress in
//            let completedBytes = String( format : "%.3f", (Double(progress.completedUnitCount) * 0.000001))
//            //create the total bytes and format
//            let totalBytes = String(format: "%.3f", (Double(progress.totalUnitCount) * 0.000001))
//            print("\(totalBytes)MB")
//            print("total bytes transferred:\(completedBytes) / \(totalBytes)")
//        }, resultListener:{ (event) in
//            switch event {
//            case .success(let data):
//                print("Completed: \(data)")
//            case .failure(let storageError):
//                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
//        }
//    })
//
        let storageOperation = Amplify.Storage.uploadFile(key: "\(saveLocation)/\(videoName)", local: url, options: .init(accessLevel: .protected, contentType: "video/mp4"))
        allData.storageTaskArray2.append(storageOperation)
        
        if storageOperation.isFinished{
            print("it is finished")
        }
        

}
    
    func sensorUpload(url : URL, sensorName: String, saveLocation: String){
//        let expression = AWSS3TransferUtilityUploadExpression()
//        let userID = Amplify.Auth.getCurrentUser()?.userId
//        let options = StorageUploadDataRequest.Options(accessLevel: .protected, contentType: "video/mp4")
//        let vidlocation = "\(saveLocation)/\(videoName)"
//        Amplify.Storage.uploadFile(key: "\(saveLocation)/\(sensorName)", local: url, options: .init(accessLevel: .protected,  contentType: "text/csv"), progressListener: { progress in
////            print("Progress: \(progress.fractionCompleted)")
//            let completedBytes = String( format : "%.3f", (Double(progress.completedUnitCount) * 0.000001))
//            //create the total bytes and format
//            let totalBytes = String(format: "%.3f", (Double(progress.totalUnitCount) * 0.000001))
//            print("total bytes transferred:\(completedBytes) / \(totalBytes)")
//        }, resultListener:{ (event) in
//            switch event {
//            case .success(let data):
//                print("Completed: \(data):\(sensorName)")
//            case .failure(let storageError):
//                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
//        }
//    })
        let storageOperation = Amplify.Storage.uploadFile(key: "\(saveLocation)/\(sensorName)", local: url, options: .init(accessLevel: .protected, contentType: "test/csv"))
        allData.storageTaskArray2.append(storageOperation)
        
}
    func testUpload(url : URL, sensorName: String, saveLocation: String){
        _ =  Amplify.Storage.uploadFile(key: "\(saveLocation)/\(sensorName)", local: url, options: .init(accessLevel: .protected,  contentType: "text/csv"), progressListener: { progress in
            print("Progress: \(progress)")
            
        }, resultListener:{ (event) in
            switch event {
            case .success(let data):
                print("Completed: \(data):\(sensorName)")
            case .failure(let storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
        }
    })
    }
    
    
    
    
    func saveDataURLlocally(dataURLS : DateStored){
        Amplify.DataStore.save(dataURLS) { result in
            switch result {
            case .success:
                print("Post saved successfully!")
            case .failure(let error):
                print("Error saving post \(error)")
            }
        }
    }
    
    func retrieveURLStored(){
        Amplify.DataStore.query(DateStored.self) { result in
            switch result {
            case .success(let posts):
                print("Posts retrieved successfully: \(posts)")
            case .failure(let error):
                print("Error retrieving posts \(error)")
            }
        }
    }
    

    
    func deleteData(data:DateStored){
        Amplify.DataStore.delete(data.self) {
            switch $0 {
            case .success:
                print("Post deleted!")
            case .failure(let error):
                print("Error deleting post - \(error.localizedDescription)")
            }
        }
    }
    func deleteWallet(id: String){
            Amplify.DataStore.delete(DateStored.self, withId: id) {
                switch $0 {
                case .success:
                    print("✅ Wallet deleted!")
                case .failure(let error):
                    print("🛑 Error deleting wallet - \(error.localizedDescription)")
                }
            }
        }
    
    func updateDataStore(id: String){
        Amplify.DataStore.query(DateStored.self, byId: id) {
            switch $0 {
            case .success(let result):
                // result will be a single object of type Post?
//                Amplify.DataStore.save(result!)
                var existingPost: DateStored = result!
                existingPost.uploadStatus = true
                Amplify.DataStore.save(existingPost){ result in
                    switch result {
                    case .success:
                        print("Post saved successfully!")
                    case .failure(let error):
                        print("Error saving post \(error)")
                    }
                }
            case .failure(let error):
                print("Error on query() for type Post - \(error.localizedDescription)")
            }
        }
    }
    
//    func uploadData(key: String, data: Data) {
//        let options = StorageUploadDataRequest.Options(accessLevel: .protected)
//        Amplify.Storage.uploadData(key: key, data: data, options:.init(accessLevel: <#T##StorageAccessLevel#>, targetIdentityId: <#T##String?#>, metadata: <#T##[String : String]?#>, contentType: <#T##String?#>, pluginOptions: <#T##Any?#>)) { progress in
//            print("Progress: \(progress)")
//        } resultListener: { event in
//            switch event {
//            case .success(let data):
//                print("Completed: \(data)")
//            case .failure(let storageError):
//                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
//            }
//        }
//    }
    
//    func uploadData1() {
//
//      let data: Data = Data() // Data to be uploaded
//
//      let expression = AWSS3TransferUtilityUploadExpression()
//         expression.progressBlock = {(task, progress) in
//            DispatchQueue.main.async(execute: {
//              // Do something e.g. Update a progress bar.
//           })
//      }
//
//      var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
//      completionHandler = { (task, error) -> Void in
//         DispatchQueue.main.async(execute: {
//            // Do something e.g. Alert a user for transfer completion.
//            // On failed uploads, `error` contains the error object.
//         })
//      }
//
//      let transferUtility = AWSS3TransferUtility.default()
//
//      transferUtility.uploadData(data,
//           bucket: "YourBucket",
//           key: "YourFileName",
//           contentType: "text/plain",
//           expression: expression,
//           completionHandler: completionHandler).continueWith {
//              (task) -> AnyObject? in
//                  if let error = task.error {
//                     print("Error: \(error.localizedDescription)")
//                  }
//
//                  if let _ = task.result {
//                     // Do something with uploadTask.
//                  }
//                  return nil;
//          }
//    }
//
//    func saveVideo(url : URL, videoName: String, saveLocation: String, progressView: UIProgressView){
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        //create a refrence to the storage location in the realtime database
//        let storageReference = Storage.storage().reference().child("SavedLocations").child("Videos").child(userID).child(saveLocation).child("\(videoName)")
//        //create the metata data container
//        let uploadMetaData = StorageMetadata()
//        //set the video content type
//        //uploadMetaData.contentType = "video/mp4"
//        let videoData = NSData(contentsOf: url as URL)
//        //refrence to the location of the image and put it there
//        let uploadTask = storageReference.putFile(from: url)
//        //add the upload task to the upload task array
//        AllData.shared.storageTaskArray.append(uploadTask)
//    }
}
