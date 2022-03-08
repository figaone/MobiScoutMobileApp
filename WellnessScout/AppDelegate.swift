//
//  AppDelegate.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/1/21.
//

import UIKit
import Amplify
import AmplifyPlugins
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    
    var restrictRotation:UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocalNotificationHelper.requestPermission()
        
        WatchKitConnection.shared.startSession()
    
        configureAmplify()
        fetchCurrentAuthSession()
        
        
            
        
        return true
    }
    
    
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    func configureAmplify(){
        do{
            let models = AmplifyModels()
//            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration:models))
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration:models))
            try Amplify.configure()
            print("Amplify configured successfully")
        }catch{
            print("could not initialize Amplify", error)
        }
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        if AllData.shared.storageTaskArray2.count > 0 {
            for task in AllData.shared.storageTaskArray2{
                if task.isExecuting{
                    task.pause()
                }
            }
        }
    }
    
    internal var shouldRotate = false
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return shouldRotate ? .allButUpsideDown : .portrait
    }
    


}

