//
//  CSVparser.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 12/3/21.
//

import Foundation
import OrderedCollections
//instance of the local file manager class
let localFileManager = LocalFileManager()

class CSVparser {
    
    func createCsv(_ initialvehHealth: OrderedDictionary<String, [Any]>, _ filename: String, onCompletion : (URL) -> Void){
        
//        let pathComponent = "pack(self.packID)-(selectRow + 1).mp4"
//          let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//          let folderPath: URL = directoryURL.appendingPathComponent("Downloads", isDirectory: true)
//          let fileURL: URL = folderPath.appendingPathComponent(pathComponent)
        
        let output = OutputStream.toMemory()
        
        let sFilename = filename
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFilename)
        
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
//        csvWriter?.writeField("heartRate")
//        csvWriter?.writeField("stepCount")
//        csvWriter?.writeField("distanceWalkedInMetres")
//        csvWriter?.finishLine()
        
        
        for (keys,_) in initialvehHealth{
            csvWriter?.writeField(keys)
        }
        csvWriter?.finishLine()
        
//        for vals in initialvehHealth.values{
//            csvWriter?.writeField(vals)
//        }
//        8AF58F-2C5E-4F7E-B754-6B26B5E1490F
        var maxlen:Int = 0
        var elCount:[Int] = []
        
        for valu in initialvehHealth.values{
//            let x = Set(valu).intersection(valu).count
//            maxlen = max(x,x)
            elCount.append(valu.count)
        }
        if let y = elCount.max(){
            maxlen = y
        }else{
         print("object is empty")
        }

        
       
        for i in stride(from: 0, through: maxlen-1, by: 1){
            for (_,val) in initialvehHealth{
                if val.endIndex > i{
//                    print("\(key) index is more than \(i)")
                    csvWriter?.writeField(val[i])
                }else if val.endIndex < i{
//                    print("\(key) index is less than \(i)")
                    csvWriter?.writeField("")
                }else{
//                    print("\(key) index is less than \(i)")
                    csvWriter?.writeField("")
                }

//                else if i > val.startIndex || i < val.endIndex{
//                    csvWriter?.writeField(val[i])
//                }
            }
            csvWriter?.finishLine()
        }
        csvWriter?.closeStream()

//        var arrayOfEmployeeData = [[String]]()
//
//        arrayOfEmployeeData.append(["123","kojo","29","manager"])
//        arrayOfEmployeeData.append(["234","kwame","24","writer"])
//        arrayOfEmployeeData.append(["345","Yaw","23","scientist"])
//        arrayOfEmployeeData.append(["678","Afia","25","worker"])
//
//
//
//        for (elements) in arrayOfEmployeeData.enumerated() {
//            csvWriter?.writeField(elements.element[0])
//            csvWriter?.writeField(elements.element[1])
//            csvWriter?.writeField(elements.element[2])
//            csvWriter?.writeField(elements.element[3])
//            csvWriter?.finishLine()
//        }
//        csvWriter?.closeStream()
        
        let buffer = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        do{
            try buffer.write(to: documentURL)
        }
        catch{
           
        }
        
        onCompletion(documentURL)
    }
    
//    func passDataToCsv(withManagedObjects arrManagedObject:[InitialHealthData]){
//        var CSVString = "id,stepCount,heartRate,distanceWalkedInMetres\n"
//        arrManagedObject.forEach { (eachObject) in
//            let entityContent = "\(String(describing: eachObject.id)), \(String(describing: eachObject.stepCount)), \(String(describing: eachObject.heartRate)), \(String(describing: eachObject.distanceWalkedInMetres))"
//            CSVString.append(entityContent)
//        }
//        let fileManager = FileManager.default
//        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let path = directory.appendingPathComponent("Employee").appendingPathExtension("csv")
//        if(!fileManager.fileExists(atPath: path.path)){
//            fileManager.createFile(atPath: path.path, contents: nil, attributes: nil)
//        }
//        do {
//            try CSVString.write(to: path, atomically: true, encoding: .utf8)
//        }
//        catch let error {
//            print("Error creating CSV \(error.localizedDescription)")
//        }
//    }
//
//    var employeeArray:[Dictionary<String, AnyObject>] =  Array()
//
//    func createCSV2(from recArray:[Dictionary<String, AnyObject>]) {
//            var csvString = "\("Employee ID"),\("Employee Name")\n\n"
//            for dct in recArray {
//                csvString = csvString.appending("\(String(describing: dct["EmpID"]!)) ,\(String(describing: dct["EmpName"]!))\n")
//            }
//
//            let fileManager = FileManager.default
//            do {
//                let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
//                let fileURL = path.appendingPathComponent("CSVRec.csv")
//                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
//            } catch {
//                print("error creating file")
//            }
//
//        }
    
//    func createExportString(_ initialvehHealth: OrderedDictionary<String, [Any]>) -> String {
//        var export = "id, time, latitude, longitude, pitch, roll, yaw, quartanionX, quartanionY, quartanionZ, quartanionW, usergenaccelX, usergenaccelY, usergenaccelZ, rotationrateX, rotationrateY, rotationrateZ, gyroX, gyroY, gyroZ, accelX, accelY, accelZ, relativeAltitude, heading, speed, distanceTravelled, headingCardinalPoint,time \n"
////        let data = self.driverData.sensor
////        let sortedData = data.sorted{ $0.value < $1.value }
//        for (_, sensor) in initialvehHealth.enumerated() {
//            export += "\(sensor.id ?? UUID()),\(sensor.indexValues),\(sensor.latitude ?? "_"),\(sensor.longitude ?? "_"),\(sensor.pitch ?? "_"),\(sensor.roll ?? "_"),\(sensor.yaw ?? "_"),\(sensor.quartanionX ?? "_"),\(sensor.quartanionY ?? "_"),\(sensor.quartanionZ ?? "_"),\(sensor.quartanionW ?? "_"),\(sensor.usergenaccelX ?? "_"),\(sensor.usergenaccelY ?? "_"),\(sensor.usergenaccelZ ?? "_"),\(sensor.rotationrateX ?? "_"),\(sensor.rotationrateY ?? "_"),\(sensor.rotationrateZ ?? "_"),\(sensor.gyroX ?? "_"),\(sensor.gyroY ?? "_"),\(sensor.gyroZ ?? "_"),\(sensor.accelX ?? "_"),\(sensor.accelY ?? "_"),\(sensor.accelZ ?? "_"),\(sensor.relativeAltitude ?? "_"),\(sensor.heading ?? "_"),\(sensor.speed ?? "_"),\(sensor.distanceTravelled ?? "_"),\(sensor.headingCardinalPoint ?? "_"),\(sensor.time ?? "_")\n"
//        }
//        return export
//    }
//    
//    func saveExport(export : String) -> URL{
//        print(driverData.csvFileName as Any)
//    
//        let fileName = driverData.collectionTime
//        let url = getDocumentsDirectory().appendingPathComponent("sensor\(fileName ?? "")data.csv")
//        do {
//            try export.write(to: url, atomically: true, encoding: .utf8)
//            let input = try String(contentsOf: url)
//            print(input)
//        } catch {
//            print(error.localizedDescription)
//        }
//        return url
//    }
//    
//    func getDocumentsDirectory() -> URL {
//        // find all possible documents directories for this user
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//
//        // just send back the first one, which ought to be the only one
//        return paths[0]
//    }
    
}








//        for val in initialvehHealth.values{
//            if val.endIndex <= maxlen {
//                for i in stride(from: 0, through: maxlen, by: 1){
//                    csvWriter?.writeField(val[i])
//                }
//            } else {
//                csvWriter?.writeField("")
//            }
//        }
        
//        for (key,val) in initialvehHealth{
//            let ind = 5
//            for i in stride(from: 0, through: maxlen-1, by: 1){
//                if val.endIndex < maxlen{
//                    print("These is the ones with less length\(val)")
//                    csvWriter?.writeField("")
//                    csvWriter?.finishLine()
//                } else if val.endIndex == maxlen {
//                    print("These is the ones with largest length\(val)")
//                    csvWriter?.writeField(val[i])
//                    csvWriter?.finishLine()
//                }
//
//            }
//
//        }
        
//        for i in stride(from: 0, through: maxlen, by: 1){
//            csvWriter?.writeField(initialvehHealth.values[i])
//        }
        
//        for val in initialvehHealth.values{
//                        if maxlen > (initialvehHealth.values.endIndex){
//            //                    csvWriter?.writeField(values[i])
//                            csvWriter?.writeField("")
//                        } else if maxlen > initialvehHealth.values.startIndex && maxlen < initialvehHealth.values.endIndex{
//                            csvWriter?.writeField(initialvehHealth.values[maxlen])
//                        }
//        }
