//
//  WatchKitConnection.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/10/21.
//

import Foundation
import WatchConnectivity
import HealthKit
import Combine

var heartDouble : Double = 0

protocol WatchKitConnectionDelegate: AnyObject {
    func didFinishedActiveSession()
}

protocol WatchKitConnectionProtocol {
    func startSession()
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)?, errorHandler: ((NSError) -> Void)?)
}

@available(iOS 13.0, *)
class WatchKitConnection: NSObject {
    
    var watchConnectionPublisher = PassthroughSubject<Bool, Error>()
    static let shared = WatchKitConnection()
    let healthStore = HKHealthStore()
    weak var delegate: WatchKitConnectionDelegate?
    var heartPublisher = PassthroughSubject<Double, Error>()
    
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var validSession: WCSession? {
#if os(iOS)
        if let session = session, session.isPaired, session.isWatchAppInstalled {
            return session
        }
#elseif os(watchOS)
            return session
#endif
        return nil
    }
    
    private var validReachableSession: WCSession? {
        if let session = validSession, session.isReachable {
            return session
        }
        return nil
    }
    
    func sendMessage2(_ message: [String: Any]) {
       

        guard WCSession.default.activationState == .activated else {
            return
        }
        
        WCSession.default.sendMessage(message, replyHandler: { replyMessage in
            print(replyMessage)

        }, errorHandler: { error in
            print(error)
        })
        
    }
    
    func startWatchApp() {
        let configuration = HKWorkoutConfiguration()
        print("method called to open app ")
    
        getActiveWCSession { (wcSession) in
            print(wcSession.isComplicationEnabled, wcSession.isPaired)
            if wcSession.activationState == .activated && wcSession.isWatchAppInstalled {
                print("starting watch app")
    
                self.healthStore.startWatchApp(with: configuration, completion: { (success, error) in
                    // Handle errors
                    if !success{
                        self.watchConnectionPublisher.send(false)
                    }else{
                        self.watchConnectionPublisher.send(true)
                    }
                    
                })
            }
    
            else{
                print("watch not active or not installed")
                self.watchConnectionPublisher.send(false)
            }
        }
    
    }
    func getActiveWCSession(completion: @escaping (WCSession)->Void) {
       guard WCSession.isSupported() else { return }
    
        let wcSession = WCSession.default
       wcSession.delegate = self
    
       if wcSession.activationState == .activated {
           completion(wcSession)
       } else {
           wcSession.activate()
    //            startSession()
       }
    }
}

@available(iOS 13.0, *)
extension WatchKitConnection: WatchKitConnectionProtocol {
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    func sendMessage(message: [String : AnyObject],
                     replyHandler: (([String : AnyObject]) -> Void)? = nil,
                     errorHandler: ((NSError) -> Void)? = nil)
    {
        validReachableSession?.sendMessage(message, replyHandler: { (result) in
            print(result)
            
        }, errorHandler: { (error) in
            print(error)
        })
    }
}


@available(iOS 13.0, *)
extension WatchKitConnection: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
        delegate?.didFinishedActiveSession()
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("didReceiveMessage")
        print(message)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("didReceiveMessage with reply")
        print(message)
        guard let heartReate = message.values.first as? String else {
            return
        }
        guard let heartReateDouble = Double(heartReate) else {
            return
        }
        print(heartReate)
        heartDouble = heartReateDouble
        AllData.shared.heartRateArray.append(heartReateDouble)
        heartPublisher.send( heartReateDouble)
        
        
    
//        LocalNotificationHelper.fireHeartRate(heartReateDouble)
    }
    
    func getData(valueDouble: Double, completion: @escaping (String) -> Void){
        print(valueDouble)
        let stFormat = String(valueDouble)
        completion(stFormat)
    }
}




//func startWatchApp() {
//    let configuration = HKWorkoutConfiguration()
//    print("method called to open app ")
//
//    getActiveWCSession { (wcSession) in
//        print(wcSession.isComplicationEnabled, wcSession.isPaired)
//        if wcSession.activationState == .activated && wcSession.isWatchAppInstalled {
//            print("starting watch app")
//
//            self.healthStore.startWatchApp(with: configuration, completion: { (success, error) in
//                // Handle errors
//            })
//        }
//
//        else{
//            print("watch not active or not installed")
//        }
//    }
//
//}
//func getActiveWCSession(completion: @escaping (WCSession)->Void) {
//   guard WCSession.isSupported() else { return }
//
//    let wcSession = WCSession.default
//   wcSession.delegate = self
//
//   if wcSession.activationState == .activated {
//       completion(wcSession)
//   } else {
//       wcSession.activate()
////            startSession()
//   }
//}
