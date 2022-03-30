//
//  UserData.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/14/21.
//

import Foundation

class UserDefaultsData : Codable{
    //user frame rate
    var frameRate : Double? = 30
    //user frequency
    var frequency : Double? = 30
    //time interval for autosave
    var autoSaveTime : TimeInterval = 600
    //upload data automatically after recording
    var automaticUpload : Bool = true
}
