//
//  TabBarViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//

import UIKit
import Amplify
import AmplifyPlugins

class TabBarViewController: UITabBarController {
    var window: UIWindow?
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    let sessionManager = AmplifySessionManager()
    let authshared = AmplifySessionManager.shared
    var URLOfData : [DateStored] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
//        title = "🏎WellnessScout"
//        hide back button of navigation bar
        navigationItem.hidesBackButton = true
        loadDataFromDataStore(){ totalData in
           print("success")
            self.changeBadge()
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        changeBadge()
       
//        if let barItem = self.tabBar.items{
//            let barItem1 = barItem[1]
//            let barItem2 = barItem[2]
//            barItem2.badgeValue = "\(AllData.shared.storageTaskArray2.count)"
//            if self.URLOfData.count > 0{
//                barItem1.badgeValue = "\(self.URLOfData.count)"
//            }else{
//                barItem1.badgeValue = nil
//            }
//            if AllData.shared.storageTaskArray2.count > 0{
//                barItem2.badgeValue = "\(AllData.shared.storageTaskArray2.count)"
//            }else{
//                barItem2.badgeValue = nil
//            }
//
//        }
        
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            changeBadge()
        }
    
    func changeBadge(){
        loadDataFromDataStore(){ totalData in
           print("success")
            DispatchQueue.main.async {
                if let tabBarItem = (self.tabBar.items) {
                    if self.URLOfData.count > 0{
                        tabBarItem[1].badgeValue = "\(self.URLOfData.count)"
                    }else{
                        tabBarItem[1].badgeValue = nil
                    }
                    
                    if AllData.shared.storageTaskArray2.count > 0{
                        tabBarItem[2].badgeValue = "\(AllData.shared.storageTaskArray2.count)"
                    }else{
                        tabBarItem[2].badgeValue = nil
                    }
                    
                    
                      //seting color of bage optional by default red
        //              tabBarItem.badgeColor = UIColor.red //
        //              //setting atribute , optional
        //                    tabBarItem.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor.red], for: .normal)
                }
            }
            
        }
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
    
    func loadDataFromDataStore(completion: @escaping ([DateStored]) -> Void){
        Amplify.DataStore.query(DateStored.self, sort: .descending(DateStored.keys.createdAt)) {
            self.URLOfData = []
            switch $0 {
            case .success(let result):
                for data in result{
                    self.URLOfData.append(data)
                    
                }
                print("this is the data")
                print(result)
                completion(result)
            case .failure(let error):
                print("Error listing posts - \(error.localizedDescription)")
            }
        }
    }
    
    func dataStoreEventListener(){
        let hubEventListener = Amplify.Hub.listen(to: .dataStore) { event in
            if event.eventName == HubPayload.EventName.DataStore.networkStatus {
                guard let networkStatus = event.data as? NetworkStatusEvent else {
                    print("Failed to cast data as NetworkStatusEvent")
                    return
                }
                print("User receives a network connection status: \(networkStatus.active)")
            }
        }
    }
    
    
}
