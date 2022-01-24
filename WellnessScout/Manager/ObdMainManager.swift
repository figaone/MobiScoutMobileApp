//
//  ObdMainManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 1/7/22.
//

import Foundation
import CoreBluetooth
import Combine

class ObdMainManager: NSObject, ObservableObject {
    
    let instanceOfCustomObject = CustomObject()
    //value for obd car speed
    var obdSpeedMain: String = ""
    //value for obd car rpm
    var obdRpmMain: String = ""
    //value for obd car temperature
    var obdTempMain: String = ""
    //val for adaptor status
    var obdAdaptorStats: String = ""
    
    var obdspeedPublisher = PassthroughSubject<String, Error>()
    var obdRPMPublisher = PassthroughSubject<String, Error>()
    var obdTemperaturePublisher = PassthroughSubject<String, Error>()
    var adaptorStatusPublisher = PassthroughSubject<String, Error>()
    
    private override init(){
        super.init()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(startObdParameters), userInfo: nil, repeats: true)
    }
    
    static let shared = ObdMainManager()
    
    func getObdData(){
        instanceOfCustomObject.onStartup()
        obdspeedPublisher.send(obdSpeedMain)
        obdRPMPublisher.send(obdRpmMain)
        obdTemperaturePublisher.send(obdTempMain)
        adaptorStatusPublisher.send(obdAdaptorStats)
    }
    
    @objc func startObdParameters(){
        obdSpeedMain = instanceOfCustomObject.speedLabel as? String ?? ""
        obdRpmMain = instanceOfCustomObject.rpmLabel as? String ?? ""
        obdTempMain = instanceOfCustomObject.tempLabel as? String ?? ""
        obdAdaptorStats = instanceOfCustomObject.adapterStatusLabel as? String ?? ""
        print("kojo kojo kojo kojo")
    }
    
    func startOBDDevice(){
        instanceOfCustomObject.onStartup()
    }
}
