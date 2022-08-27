//
//  SourceOfTruth.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 11/28/21.
//

import Foundation
import Amplify
import AWSS3

class SourceOfTruth: ObservableObject {
    @Published var sensordat = [MainSensorData]()
    @Published var startdate = [SaveLocation]()
    @Published var initialvehHealth = [InitialHealthData]()
    @Published var initialVehData = [InitialVehicleData]()
    @Published var driverdat = [MobileAppUser]()
    
    func sendSensorData(_ sensordat: MainSensorData) {
        Amplify.API.mutate(request: .create(sensordat)) { mutationresult in
            switch mutationresult {
            case .success(let creationResult):
                switch creationResult {
                case.success:
                    print("successfully created sensordata")
                case.failure(let error):
                    print(error)
                }
            case .failure(let apiError):
                print(apiError)
            }
            
        }
    }
    func sendTimeData(_ startdate: SaveLocation) {
        Amplify.API.mutate(request: .create(startdate)) { mutationresult in
            switch mutationresult {
            case .success(let creationResult):
                switch creationResult {
                case.success:
                    print("successfully created startdatedata")
                case.failure(let error):
                    print(error)
                }
            case .failure(let apiError):
                print(apiError)
            }
            
        }
    }
    
    func initialVehHealthData(_ initialvehHealth: InitialHealthData) {
        Amplify.API.mutate(request: .create(initialvehHealth)) { mutationresult in
            switch mutationresult {
            case .success(let creationResult):
                switch creationResult {
                case.success:
                    print("successfully created initialHealthdata")
                case.failure(let error):
                    print(error)
                }
            case .failure(let apiError):
                print(apiError)
            }
            
        }
    }
    
    func driverData(_ driverdat: MobileAppUser) {
        Amplify.API.mutate(request: .create(driverdat)) { mutationresult in
            switch mutationresult {
            case .success(let creationResult):
                switch creationResult {
                case.success:
                    print("successfully created initialHealthdata")
                case.failure(let error):
                    print(error)
                }
            case .failure(let apiError):
                print(apiError)
            }
            
        }
    }
    
    func vehicleData(_ vehicledat: InitialVehicleData) {
        Amplify.API.mutate(request: .create(vehicledat)) { mutationresult in
            switch mutationresult {
            case .success(let creationResult):
                switch creationResult {
                case.success:
                    print("successfully created initialvehicledata")
                case.failure(let error):
                    print(error)
                }
            case .failure(let apiError):
                print(apiError)
            }
            
        }
    }
    
        
}
