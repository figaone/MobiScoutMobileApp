//
//  TabBarViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//

import UIKit
import Amplify

class TabBarViewController: UITabBarController {
    var window: UIWindow?
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let sessionManager = AmplifySessionManager()
    let authshared = AmplifySessionManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
//        title = "🏎WellnessScout"
//        hide back button of navigation bar
        navigationItem.hidesBackButton = true
    }

//    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
//    }
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        sessionManager.signOut()
        print(sessionManager.authState)
        if sessionManager.authState == .login{
            DispatchQueue.main.async { [weak self] in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondVC = storyboard.instantiateViewController(identifier: "LogInView")

                self?.show(secondVC, sender: self)
            }
        } else {
            return
        }
        
            
       
            
       
//    do {
////      try sessionManager.signOut()
//      try Auth.auth().signOut()
//        navigationController?.popToRootViewController( animated: true)
//
//    } catch let signOutError as NSError {
//        let alert = UIAlertController(title: "authError", message: signOutError.localizedDescription, preferredStyle: .alert)
//
//        let okayAction = UIAlertAction(title: "OK", style: .default){
//            (action) in
//            print(action)
//        }
//        alert.addAction(okayAction)
//        self.present(alert, animated: true, completion: nil)
//      print("Error signing out: %@", signOutError)
//    }
}
    
    func signOutLocally() {
        Amplify.Auth.signOut() {[weak self] result in
            switch result {
            case .success:
                print("Successfully signed out")
                self?.navigationController?.popToRootViewController( animated: true)
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
    
    func signOut(){
        _ = Amplify.Auth.signOut{ [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                }
            case .failure(let error):
                print("Sign out erro:", error)
            }
        }
        
    }
    
    func getCurrentAuthUser(){
        //if aplify has user login, then we add user,if not user is shown a login to log
        if let user = Amplify.Auth.getCurrentUser() {
            print("This is the user\(user)")
//            authState = .session
        } else {
            print("user is not sign in")
            self.navigationController?.popToRootViewController( animated: true)
        }
    }
    
    
}
