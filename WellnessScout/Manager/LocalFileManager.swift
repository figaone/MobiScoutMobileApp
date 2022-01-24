//
//  LocalFileManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/23/21.
//

import Foundation
import UIKit
//class used to save files to file manager
class LocalFileManager{
 
    
    //function used to find the path to the documents directory as a URL
    func pathForDocumentDirectoryAsUrl() -> URL? {
        //get the path to the documents directory
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    //path to the documents directory as a string
    func pathForDocumentDirectoryAsString() -> String? {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    //function used to save the video to the documents directory
    func saveVideoToDocumentsDirectory(srcURL : URL, dstURL: URL, onCompletion : (URL) -> Void){
        //copy the value of the saved video we got from recording to the documents directory
        //create a ref to the file manager obj
        let fileManagerRef = FileManager()
        //copy the contents of the url to another location
        try! fileManagerRef.copyItem(at: srcURL, to: dstURL)
        onCompletion(dstURL)
    }
    
    //function used to display all of the files in a directory
    func displayAllDocuments(){
        //contents of the directory
        let contents = try! FileManager.default.contentsOfDirectory(at: pathForDocumentDirectoryAsUrl()!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        //print the conents of the directory
        
        print("Printing the conetents of the directory")
        
        for file in contents {
            //get the file
            print(file.absoluteURL)
        }
        
    }
    
    //display all of the videos in the DI folder
    func displayAllVideos(){
           //contents of the directory
        let contents = try! FileManager.default.contentsOfDirectory(at: (pathForDocumentDirectoryAsUrl()?.appendingPathComponent("DI", isDirectory: true))!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
           
           //print the conents of the directory
           
           print("Printing the conetents of the directory")
           
           for file in contents {
               print(file.absoluteURL)
               getInfo(fileUrl: file)
           }
       }
    
    
    //function used to get the url array
    func getURLArray() -> [URL]{
        //get the url array
        let urlArray = try! FileManager.default.contentsOfDirectory(at: (pathForDocumentDirectoryAsUrl()?.appendingPathComponent("DI", isDirectory: true))!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        //return the url array
        return urlArray
    }
    
    //function used to get the creation date of the url
    func getCreationDate(fileUrl: URL)-> String{
        //create the attributes
        let attributes = try! FileManager.default.attributesOfItem(atPath: fileUrl.path)
        //get the creation date
        let creationDate = attributes[.creationDate]
        //return the creation date
        return "\(String(describing: creationDate!))"
    }
    
    //function used to get the file size of the file
    func getFileSize(fileUrl: URL)-> String{
        //create the attributes
        let attributes = try! FileManager.default.attributesOfItem(atPath: fileUrl.path)
        //size of the file
        let size = attributes[.size]
        let convertedDouble = size as! Double
        //covert the size in bytes to MBs
        let convertedSize = String(format: "%.3f", (Double(convertedDouble) * 0.000001))
        //return the total size
        return convertedSize
    }
    
    
    //function used to get info about a url
    func getInfo(fileUrl: URL){
        
        //create the attributes
        let attributes = try! FileManager.default.attributesOfItem(atPath: fileUrl.path)
        let creationDate = attributes[.creationDate]
        let size = attributes[.size]
        let type = attributes[.type]
        
        print("Creation Date :", creationDate as Any )
        print("File size: ", size as Any )
        print("Type : ", type as Any )
        
    }
    
    //create a directroy
    func createDirectory(){
        //path to the url of where we will save videos
        let url = pathForDocumentDirectoryAsUrl()?.appendingPathComponent("DI", isDirectory: true)
        print("The created url is :", url as Any)
        //attempt to create the url
        try! FileManager.default.createDirectory(at: url!,
        withIntermediateDirectories: true,
        attributes: nil)
    }
    
    //delete a directory
    func deleteDirectory(dirUrl : URL){
        //attempt to delete the dir
        try! FileManager.default.removeItem(at: dirUrl)
    }
    
    //delete a file
    func deleteFile(fileUrl:URL){
        //attempt to remove the file
        do{
            try! FileManager.default.removeItem(at: fileUrl)
        } catch let error{
            let rootViewController = LibraryTableTableViewController()

            rootViewController.presentAlert(withTitle: "Delete Error", message: "\(error)", actions: ["OK" : UIAlertAction.Style.default])
        }
        
    }
    
    
    
    
    
    //function used to store the data
    private func store(image : UIImage, forKey key : String){
        //check the data type here
        if let pngRepresentation = image.pngData(){
            //check the file path now
            if let filePath = filePath(forKey: key){
                
                do {
                    //try to write the data
                    try pngRepresentation.write(to: filePath, options: .atomic)
                    
                } catch let error {
                    //catch errors here
                    print("Saving file resulted in error: ", error)
                }

        }
    }
    }
    
    
    
    //function used to retrieve the data from the storage
    private func retrieveImage(forKey key : String)-> UIImage {
        //check the file path here
        if let filePath = self.filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData){
            return image
        }
        //in the case we have an error
        return UIImage()
    }
    
    
    //helper function
    private func filePath(forKey key: String) -> URL? {
        //get the refrence to the file manager here
        let fileManager = FileManager.default
        //get the doc url
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        //return the url here
        return documentURL.appendingPathComponent(key + ".png")
    }
  
    
    //find file using filename
    
    func getfile(fileName:String) -> URL? {
        let fileManager = FileManager.default
        //get the doc url
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        //return the url here
        return documentURL.appendingPathComponent(fileName)
    }
    
     func retriveVid(fileName:String) -> URL? {
        //get the refrence to the file manager here
        let fileManager = FileManager.default
//        //get the doc url
//         guard let documentURL = fileManager.urls(for: .moviesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
//        //return the url here
//        let mainurl = (localFileManager.pathForDocumentDirectoryAsUrl()?.appendingPathComponent("DI", isDirectory: true).appendingPathComponent(fileName))!
         //get the doc url
         guard let documentURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
         //return the url here
         return documentURL.appendingPathComponent(fileName)
    }
    func getURL() -> [URL]{
        //get the url array
        let urlArray = try! FileManager.default.contentsOfDirectory(at: (pathForDocumentDirectoryAsUrl()?.appendingPathComponent("DI", isDirectory: true))!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        //return the url array
        return urlArray
    }
    
}
