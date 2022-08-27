//
//  SceneDelegate.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/1/21.
//

import UIKit
import SwiftUI
import Amplify

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    @ObservedObject var sessionManager = AmplifySessionManager()
    @ObservedObject var authshared = AmplifySessionManager.shared
    var window: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        sessionManager.observeAuthEvents()
        sessionManager.ObserveToken()
        sessionManager.getCurrentAuthUser()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch sessionManager.authState {
        case .login:
            let mainTabBarController = storyboard.instantiateViewController(identifier: "LogInView")
            window?.rootViewController = mainTabBarController
        case .signUp:
            let mainTabBarController = storyboard.instantiateViewController(identifier: "TermsAndConditions")
            window?.rootViewController = mainTabBarController
        case .confirmationCode:
            let mainTabBarController = storyboard.instantiateViewController(identifier: "ConfirmationView")
            window?.rootViewController = mainTabBarController
        case .session:
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarView")
            let navigationController = UINavigationController(rootViewController: mainTabBarController)
            window?.rootViewController = navigationController
        }
        
        
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
//    func fetchCurrentAuthSession() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        _ = Amplify.Auth.fetchAuthSession { result in
//            switch result {
//            case .success(let session):
//                print("Is user signed in - \(session.isSignedIn)")
//                if session.isSignedIn == true{
//                    DispatchQueue.main.async { [weak self] in
//                        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarView")
//                        let navigationController = UINavigationController(rootViewController: mainTabBarController)
//                        self?.window?.rootViewController = navigationController
//
//                    }
//                } else {
//                    DispatchQueue.main.async { [weak self] in
//                        let mainTabBarController = storyboard.instantiateViewController(identifier: "LogInView")
//                        self?.window?.rootViewController = mainTabBarController
//                    }
//                }
//
//
//            case .failure(let error):
//                print("Fetch session failed with error \(error)")
//            }
//        }
//    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

