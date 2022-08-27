//
//  AmplifySessionManager.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 11/14/21.
//

import Foundation
import Amplify
import UIKit
import SwiftUI
import Combine

enum AuthState {
    case signUp
    case login
    case confirmationCode
    case session
}



final class AmplifySessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    var window: UIWindow?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    static let shared = AmplifySessionManager()
    var sink: AnyCancellable?
    
    func getCurrentAuthUser(){
        //if aplify has user login, then we add user,if not user is shown a login to log
        if let user = Amplify.Auth.getCurrentUser() {
            print("This is the user\(user)")
            authState = .session
        } else {
            print("user is not sign in")
            authState = .login
        }
    }
    func showSignUp() {
        authState = .signUp
//        DispatchQueue.main.async {
//            let mainTabBarController = self.storyboard.instantiateViewController(identifier: "TermsAndConditions")
//            self.window?.rootViewController = mainTabBarController
//        }
        
        
    }
    
    func showLogin() {
        authState = .login
        DispatchQueue.main.async {[weak self] in
            let mainTabBarController = self?.storyboard.instantiateViewController(identifier: "LogInView")
            self?.window?.rootViewController = mainTabBarController
        }
        
    }
    
    func signUp( email: String, password: String) {
        let attributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        _ = Amplify.Auth.signUp(username: email, password: password, options: options) {[weak self] result in
            switch result{
                
            case .success(let signUpResult):
                print("Sign Up Result:", signUpResult)
                
                switch signUpResult.nextStep {
                case .done:
                    print("Finished Sign Up")
                case .confirmUser(let details, _):
                    
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmationCode
                        let mainTabBarController = self?.storyboard.instantiateViewController(identifier: "ConfirmationView")
                        self?.window?.rootViewController = mainTabBarController
                    }
                }
            
            case .failure(let error):
                print("Sign Up error", error)
            }
        }
    }
    
    func confirm(username: String, code: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code) { [weak self] result in
            
            switch result {
            case.success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete {
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
            
            case .failure(let error):
                print("failed to confirm code:", error)
            }
            
        }
    }
    
    func login(username: String, password: String) {
        _ = Amplify.Auth.signIn(username: username, password: password) {[weak self] result in
            
            
            switch result{
            case .success(let signInResult):
                print(signInResult)
                if signInResult.isSignedIn {
                    DispatchQueue.main.async {
                        self?.getCurrentAuthUser()
                        let mainTabBarController = self?.storyboard.instantiateViewController(identifier: "MainTabBarView")
                        let navigationController = UINavigationController(rootViewController: mainTabBarController!)
                        self?.window?.rootViewController = navigationController
                    }
                }
            
            case .failure(let error):
                print("Login error", error)
            }
        }
    }
    func signOut(){
        _ = Amplify.Auth.signOut{ result in
            switch result {
            case .success:
                print("user signout")
//                DispatchQueue.main.async {
//                    let mainTabBarController = self?.storyboard.instantiateViewController(identifier: "LogInView")
//                    self?.window?.rootViewController = mainTabBarController
//                    self?.getCurrentAuthUser()
//
//                }
            case .failure(let error):
                print("Sign out erro:", error)
            }
        }
        
    }
    
    func observeAuthEvents() {
        _ = Amplify.Hub.listen(to: .auth) { [weak self] result in
            switch result.eventName {
            case HubPayload.EventName.Auth.signedIn:
                print("kojo is signed in")
                DispatchQueue.main.async {
                    print("kojo is signed in")
                    self?.authState = .session
                }
            case HubPayload.EventName.Auth.signedOut:
                print("kojo is signed out")
                DispatchQueue.main.async {
                    self?.authState = .login
                }
            case HubPayload.EventName.Auth.sessionExpired:
                print("kojo's sessionExpired")
                DispatchQueue.main.async {
                    self?.authState = .login
                }
            default:
                break
            }
            
        }
    }
    
    func ObserveToken(){
        sink = Amplify.Hub
               .publisher(for: .auth)
               .sink { payload in
                   switch payload.eventName {
                   case HubPayload.EventName.Auth.signedIn:
                       print("User signed in")
                       // Update UI

                   case HubPayload.EventName.Auth.sessionExpired:
                       print("Session expired")
                       // Re-authenticate the user

                   case HubPayload.EventName.Auth.signedOut:
                       print("User signed out")
                       // Update UI
                   default:
                       break
                   }
               }
    }
    
    
}
