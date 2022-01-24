//
//  VinData.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 1/14/22.
//

import Foundation

struct VehicleInfoData: Codable {
    let name: String
    let Make: String
    let ManufacturerName: String
    let Model: String
    let ModelYear: String
    let Series: String
    let VehicleType: String
    let PlantCountry: String
    let PlantCompanyName: String
    let PlantState: String
    let BodyClass: String
    let DriveType: String
    let EngineNumberofCylinders: String
    let DisplacementCC: String
    let DisplacementCI: String
    let DisplacementL: String
    let EngineConfiguration: String
    let FuelDeliveryFuelInjectionType: String
    let EngineBrakehpFrom: String
    let FrontAirBagLocations: String
    let KneeAirBagLocations: String
    let SideAirBagLocations: String
    let NCSABodyType: String
    let NCSAMake: String
    let NCSAModel: String
    let main: Main
    let weather: [VehicleInfo]
}

struct Main: Codable {
    let temp: Double
}

struct VehicleInfo: Codable {
    let description: String
    let id: Int
}
