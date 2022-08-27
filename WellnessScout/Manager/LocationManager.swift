//
//  LocationManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 12/31/21.
//

import Foundation
import Combine
import CoreLocation
import CoreMedia
import MapKit


class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject, MKMapViewDelegate {
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance: Double = 0
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    var speedPublisher = PassthroughSubject<CLLocationSpeed, Error>()
    var traveledDistancedistancePublisher = PassthroughSubject<CLLocationDistance, Error>()
    var StraightDistancedistancePublisher = PassthroughSubject<CLLocationDistance, Error>()
    var headingPublisher = PassthroughSubject<String, Error>()
    var altitudePublisher = PassthroughSubject<CLLocationDistance, Error>()
    
    var deniedLocationAccuracyAuthPublisher = PassthroughSubject<String, Error>()
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
    private override init(){
        super.init()
    }
    
    static let shared = LocationManager()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = kCLDistanceFilterNone
        manager.delegate = self
        return manager
    }()
    func requestLocationUpdates(){
        
        
        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        default:
            deniedLocationAccessPublisher.send()
        }
        switch locationManager.accuracyAuthorization{
            
        case .fullAccuracy:
            print("full Accuracy")
        case .reducedAccuracy:
            deniedLocationAccuracyAuthPublisher.send("Please navigate to the Ios app settings and switch to precise location")
        @unknown default:
            print("unkown fault")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        case .denied:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let initialLocation = locations.first else { return }
//        guard let location = locations.last else { return }
//        guard let heading = manager.heading?.trueHeading else { return }
//        coordinatesPublisher.send(location.coordinate)
//        speedPublisher.send(location.speed)
//        print(heading)
//        headingPublisher.send(heading)
        if startLocation == nil {
            startLocation = locations.first
            } else if let location = locations.last{
                altitudePublisher.send(location.altitude)
                speedPublisher.send(location.speed * 2.23694)
                coordinatesPublisher.send(location.coordinate)
                traveledDistance += lastLocation.distance(from: location)
                traveledDistancedistancePublisher.send(traveledDistance)
                StraightDistancedistancePublisher.send( startLocation.distance(from: locations.last!))
            }
            lastLocation = locations.last
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingPublisher.send(cardinalValue(from: newHeading.trueHeading))
    }
    
    func cardinalValue(from heading: CLLocationDirection) -> String {
            switch heading {
            case 0 ..< 22.5:
                return "N"
            case 22.5 ..< 67.5:
                return "NE"
            case 67.5 ..< 112.5:
                return "E"
            case 112.5 ..< 157.5:
                return "SE"
            case 157.5 ..< 202.5:
                return "S"
            case 202.5 ..< 247.5:
                return "SW"
            case 247.5 ..< 292.5:
                return "W"
            case 292.5 ..< 337.5:
                return "NW"
            case 337.5 ... 360.0:
                return "N"
            default:
                return ""
            }
        }
    
//    func startHeadUpdates(_ manager: CLLocationManager){
//        if manager.heading != nil {
//            manager.startUpdatingHeading()
//        }
//        return
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
        speedPublisher.send(completion: .failure(error))
        traveledDistancedistancePublisher.send(completion: .failure(error))
        headingPublisher.send(completion: .failure(error))
    }
    
   
    
}
