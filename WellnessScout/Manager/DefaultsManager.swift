//
//  DefaultsManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/14/21.
//

import Foundation
import UIKit


//class used to set the defaults for the settings in the app
class DefaultsManager : Codable{
    
    //function saves any changes to the users default settings
    func setUserDefaults(userData : UserDefaultsData){
        //To save the object
        UserDefaults.standard.save(customObject: userData, inKey: "userDefaultData")
    }
    
    //function reads the current user default settings
    func getUserDefaults()->UserDefaultsData{
        //gets the user defaults
        let userDataObj = UserDefaults.standard.retrieve(object: UserDefaultsData.self, fromKey: "userDefaultData") ?? UserDefaultsData()
        //return the user defaults
        return userDataObj
    }
    
    //fuction used to save sensor data array
    func setSensorDataArray(sensorDataArray : [SensorData], videoName : String){
        //encode the array as data
        let sensorData = try! JSONEncoder().encode(sensorDataArray)
        //set the data in user defaults
        UserDefaults.standard.set(sensorData, forKey: videoName)
    }
    
    //function used to get the sensor data array for the secified video
    func getSensorDataArray(videoName : String)-> [SensorData]{
        //load the data in from the store
        let sensorData = UserDefaults.standard.data(forKey: videoName)
        //convert to a sensor array
        let sensorDataArray = try! JSONDecoder().decode([SensorData].self, from: sensorData!)
        //print
        print("Size of the sensor data array is: ",sensorDataArray.count)
        //return the array
        return sensorDataArray
    }
    
    //function used to remove the sensor data array for the key
    func removeSensorDataArray(videoName: String){
        //remove the object
        UserDefaults.standard.removeObject(forKey: videoName)
    }

    
    //function used to remove all the saved data
    func removeAllUserDefaults(){
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}

//extension used to encode and decode the object so we can save it in the user defaults
extension UserDefaults {
    
    func save<T:Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            }else {
                print("Couldnt decode object")
                return nil
            }
        }else {
            print("Couldnt find key")
            return nil
        }
    }
    
}

