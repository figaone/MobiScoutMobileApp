//
//  VinManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 1/14/22.
//

import Foundation
import SwiftyJSON

protocol VehicleInfoManagerDelegate {
    func didUpdateVin(_ vinManager: VehicleInfoManager, vehicleInfo: VehicleInfoModel)
    func didFailWithError(error: Error)
}

struct VehicleInfoManager {
    

    let vinApiURL = "https://vpic.nhtsa.dot.gov/api/vehicles/decodevinextended/VIN_to_Lookup?format=csv"
    
    var delegate:VehicleInfoManagerDelegate?
    
    func fecthVehicleInformation(vinNumber: String) {
        let urlString = "https://vpic.nhtsa.dot.gov/api/vehicles/decodevinextended/\(vinNumber)?format=json"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data , response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let vehicleInfo = self.parseJSON(safeData) {
                        self.delegate?.didUpdateVin(self, vehicleInfo: vehicleInfo)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ vehicleInfo: Data) -> VehicleInfoModel? {
        do {
//            let jsonResponse = try JSONSerialization.jsonObject(with:
//                                                vehicleInfo, options: [])
            let json = try JSON(data: vehicleInfo)
            
//            jsonResponse["data"]["username"]
//            print(json["Results"][6]["Value"])
            let vehicleInfo = VehicleInfoModel(Make: json["Results"][6]["Value"].stringValue, ManufacturerName: json["Results"][7]["Value"].stringValue, Model: json["Results"][8]["Value"].stringValue, ModelYear: json["Results"][9]["Value"].stringValue, Series: json["Results"][11]["Value"].stringValue, VehicleType: json["Results"][13]["Value"].stringValue, PlantCountry: json["Results"][14]["Value"].stringValue, PlantCompanyName: json["Results"][15]["Value"].stringValue, PlantState: json["Results"][16]["Value"].stringValue, BodyClass: json["Results"][21]["Value"].stringValue, Doors: json["Results"][22]["Value"].stringValue, DriveType: json["Results"][49]["Value"].stringValue, EngineNumberofCylinders: json["Results"][68]["Value"].stringValue, DisplacementCC: json["Results"][69]["Value"].stringValue, DisplacementCI: json["Results"][70]["Value"].stringValue, DisplacementL: json["Results"][71]["Value"].stringValue, EngineConfiguration: json["Results"][77]["Value"].stringValue, FuelDeliveryFuelInjectionType: json["Results"][79]["Value"].stringValue, EngineBrakehpFrom: json["Results"][80]["Value"].stringValue, SeatBeltType: json["Results"][89]["Value"].stringValue, CurtainAirBagLocations: json["Results"][91]["Value"].stringValue, FrontAirBagLocations: json["Results"][93]["Value"].stringValue, KneeAirBagLocations: json["Results"][94]["Value"].stringValue, SideAirBagLocations: json["Results"][95]["Value"].stringValue, NCSABodyType: json["Results"][107]["Value"].stringValue, NCSAMake: json["Results"][108]["Value"].stringValue, NCSAModel: json["Results"][109]["Value"].stringValue)
//            //Response result
//            let decodedData = try decoder.decode(VehicleInfoData.self, from: vehicleInfo)
//            print(decodedData)
//            let id = decodedData.weather[0].id
//            let temp = decodedData.main.temp
//            let name = decodedData.name
            
//            let weather = VehicleInfoModel(conditionId: id, cityName: name, temperature: temp)
//            return weather
            return vehicleInfo
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
