//
//  RegisterViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/8/21.
//

import UIKit
import SwiftUI
import Amplify


var username1 = ""

class RegisterViewController: UIViewController, UITextFieldDelegate{
    
//    @ObservedObject var sessionManager = AmplifySessionManager()
    
//    @IBOutlet weak var emailTextfield: UITextField!
    
    let sessionManager = AmplifySessionManager()
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance()?.presentingViewController = self
        self.emailTextfield.delegate = self
        self.passwordTextfield.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    
    @IBAction func seeOrUnseePassword(_ sender: UIButton) {
    }
    //    @IBOutlet weak var genderSelectField: UIPickerView!
//
//    @IBOutlet weak var vehicleSelectField: UIPickerView!
    @IBAction func registerPressed(_ sender: UIButton) {
                if let email = emailTextfield.text,let password = passwordTextfield.text{
                    username1 = email
                    signUp(email: email, password: password)
//                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                        if let e = error {
//                            let alert = UIAlertController(title: "authError", message: e.localizedDescription, preferredStyle: .alert)
//
//                            let okayAction = UIAlertAction(title: "OK", style: .default){
//                                (action) in
//                                print(action)
//                            }
//                            alert.addAction(okayAction)
//                            self.present(alert, animated: true, completion: nil)
////                            print(e.localizedDescription)
//                        } else {
//                            //Navigate to the WellnessScout view controller
//                            self.performSegue(withIdentifier: K.registerSegue, sender: self)
//                        }
//                    }
                }
        
       
        
    }
    
    func signUp(email: String, password: String) {
        let attributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        let username = email
        _ = Amplify.Auth.signUp(username: username, password: password, options: options) {[weak self] result in
            switch result{
                
            case .success(let signUpResult):
                print("Sign Up Result:", signUpResult)
                self?.sessionManager.authState = .signUp
                switch signUpResult.nextStep {
                case .done:
                    print("Finished Sign Up")
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    self?.sessionManager.authState = .confirmationCode
                    if self?.sessionManager.authState == .confirmationCode{
                        DispatchQueue.main.async { [weak self] in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let secondVC = storyboard.instantiateViewController(identifier: "ConfirmationView")

                            self?.show(secondVC, sender: self)
                        }
                    } else {
                        return
                    }
                }
            
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "authError", message: "Sign in failed \(error)", preferredStyle: .alert)

                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
                        print(action)
                    }
                    alert.addAction(okayAction)
                    self?.present(alert, animated: true, completion: nil)
                    
                    print("Sign in failed \(error)")
                }
                print("Sign Up error", error)
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        sessionManager.showLogin()
    }
    
 
    @IBAction func signUpWithGooglePressed(_ sender: Any) {
        socialSignInWithWebUI()
    }
    //    @IBAction func signUpWithGooglePressed(_ sender: Any) {
////        GIDSignIn.sharedInstance()?.presentingViewController = self
////        GIDSignIn.sharedInstance()?.signIn()
////        socialSignInWithWebUI()
//        print("Yes")
//    }
    
    private var window: UIWindow {
        guard
            let scene = UIApplication.shared.connectedScenes.first,
            let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
            let window = windowSceneDelegate.window as? UIWindow
        else{ return UIWindow() }
        
        return window
    }
    
  
    func socialSignInWithWebUI() {
        Amplify.Auth.signInWithWebUI(for: .google, presentationAnchor: window) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "authError", message: "Sign in failed \(error)", preferredStyle: .alert)

                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
                        print(action)
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    print("Sign in failed \(error)")
                }
               
            }
        }
    }
    

    
    
}


//func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//
//
//    if let error = error {
//                let alert = UIAlertController(title: "authError", message: error.localizedDescription, preferredStyle: .alert)
//
//                let okayAction = UIAlertAction(title: "OK", style: .default){
//                    (action) in
//                    print(action)
//                }
//                alert.addAction(okayAction)
//                self.present(alert, animated: true, completion: nil)
//                print(error.localizedDescription)
//       return
//     }
//     guard let email = user.profile.email else { return }
//
//    Auth.auth().fetchSignInMethods(forEmail: email) { FIREmailAuthProvider, Error in
//        if let e = Error{
//            print(e)
//        }
//        if let providers = FIREmailAuthProvider {
//            if providers.count > 0 {
//                let alert = UIAlertController(title: "authError", message: "User Exists in our database", preferredStyle: .alert)
//
//                let okayAction = UIAlertAction(title: "OK", style: .default){
//                    (action) in
//                    print(action)
//                }
//                alert.addAction(okayAction)
//                self.present(alert, animated: true, completion: nil)
//                  print("user exist")
//            }
//        } else{
//
//    // Get credential object using Google ID token and Google access token
//    guard let authentication = user.authentication else {
//        return
//    }
//    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                   accessToken: authentication.accessToken)
//
//    // Authenticate with Firebase using the credential object
//    Auth.auth().signIn(with: credential) { (authResult, error) in
//        if let error = error {
//            let alert = UIAlertController(title: "authError", message: error.localizedDescription, preferredStyle: .alert)
//
//            let okayAction = UIAlertAction(title: "OK", style: .default){
//                (action) in
//                print(action)
//            }
//            alert.addAction(okayAction)
//            self.present(alert, animated: true, completion: nil)
//            print(error.localizedDescription)
//        } else{
//            self.performSegue(withIdentifier: K.registerSegue, sender: self)
//            print("user does not exist")
//        }
//
//
//    }
////
////         Auth.auth().fetchSignInMethods(email: email){ (providers, error) in
////           if let error = error {
////            print(error)
////            return
////           }
////
////           if let providers = providers {
////            //This returns an array and will tell you if an user exists or not
////            //If the user exists you will get providers.count > 0 else 0
////
////             if providers.count > 0 {
////              //User Exists and you can print the providers like [google.com, facebook.com] <-- Providers used to sign in
////             } else {
////              //Show Alert user does not exist
////             }
////           }
////
////
////         }
//
//        }
//    }
//}

//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
////         Check for sign in error
////            if let error = error {
////                if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
////                    print("The user has not signed in before or they have since signed out.")
////                } else {
////                    print("\(error.localizedDescription)")
////                }
////                return
////            }
//        print(user.profile.email)
//
//            // Get credential object using Google ID token and Google access token
//            guard let authentication = user.authentication else {
//                return
//            }
//            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                           accessToken: authentication.accessToken)
//
//            // Authenticate with Firebase using the credential object
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//                if let error = error {
//                    let alert = UIAlertController(title: "authError", message: error.localizedDescription, preferredStyle: .alert)
//
//                    let okayAction = UIAlertAction(title: "OK", style: .default){
//                        (action) in
//                        print(action)
//                    }
//                    alert.addAction(okayAction)
//                    self.present(alert, animated: true, completion: nil)
//                    print(error.localizedDescription)
//                } else{
//                    Auth.auth().fetchSignInMethods(forEmail: user.profile.email, completion: { (signInMethods, error) in
//                        print(signInMethods as Any)
//                    })
////                    let databaseRef = Database.database().reference()
////
////                    databaseRef.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
////
////                                if snapshot.hasChild(String(user.profile.email)){
////
////                                    print("user exist")
////
////                                }else{
////
////                                    print("user doesn't exist")
////                                }
////                            })
//
//                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
//                }
//
//
//
//                // Post notification after user successfully sign in
////                NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
//
//
//            }
//    }
    
