//
//  Constants.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//
import Foundation

struct K {
    //Use static to prevent creating an instance of the struct during use
    static let appName = "🏎Wellness Scout"
    static let registerSegue = "RegisterToWellnessScout"
    static let loginSegue = "LoginToWellnessScout"
}

class Constants : NSObject {
    // target video input size
    static let inputWidth = 160
    static let inputHeight = 160
    
    static let countOfFramesPerInference = 4
    static let topCount = 5
}
