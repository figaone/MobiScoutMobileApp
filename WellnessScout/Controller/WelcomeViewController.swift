//
//  ViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 10/1/21.
//

import UIKit
import SwiftUI
import Amplify

var username2 = ""
class WelcomeViewController: UIViewController, UITextFieldDelegate {
//    @EnvironmentObject var sessionManager : AmplifySessionManager
    
//    @StateObject var sessionManager = AmplifySessionManager()
    let sessionManager = AmplifySessionManager()
    
    @IBAction func joinUsNow(_ sender: Any) {
//        sessionManager.showSignUp()
//        print("signup")
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondVC = storyboard.instantiateViewController(identifier: "TermsAndConditions")
//                secondVC.modalPresentationStyle = UIModalPresentationStyle.popover
            self?.show(secondVC, sender: self)

       }
    }
//    @ObservedObject var sessionManager = AmplifySessionManager()
    
    
    
    
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        activitySpinner.isHidden = true
        navigationItem.hidesBackButton = true
        activitySpinner.hidesWhenStopped = true
        self.emailTextField.delegate = self
        self.passwordTextfield.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
        activitySpinner.stopAnimating()
    }
//    override func viewWillDisappear(_ animated: Bool) {
////        activitySpinner.stopAnimating()
//    }
    
//    func authscreens() {
//        switch sessionManager.authState{
//        case .login:
//            self.performSegue(withIdentifier: K.loginSegue, sender: self)
//
//        case .signUp:
//            self.performSegue(withIdentifier: K.registerSegue, sender: self)
//        case .confirmationCode(username: let username):
//            return
//        case .session(user: let user):
//            return
//        }
//    }
    
   
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        print("forgot button pressed")
        if let username = emailTextField.text{
            username2 = username
            resetPassword(username: username)
        }
        
            
        
        
//        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
//            if let error = error {
//                let alert = UIAlertController(title: "authError", message: error.localizedDescription, preferredStyle: .alert)
//
//                let okayAction = UIAlertAction(title: "OK", style: .default){
//                    (action) in
////                    print(action)
//                }
//                alert.addAction(okayAction)
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                let alert = UIAlertController(title: "Forgotten Password", message: "password reset has been sent to \(self.emailTextField.text!)", preferredStyle: .alert)
//
//                let okayAction = UIAlertAction(title: "OK", style: .default){
//                    (action) in
//                    print(action)
//                }
//                alert.addAction(okayAction)
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    func resetPassword(username: String) {
        Amplify.Auth.resetPassword(for: username) { result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Confirm Password Reset", message:"Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))", preferredStyle: .alert)
        
                        let okayAction = UIAlertAction(title: "OK", style: .default){
                            (action) in
                            self.performSegue(withIdentifier: "ConfirmationViewOne", sender: self)
                            print(action)
                        }
                        alert.addAction(okayAction)
                        self.present(alert, animated: true, completion: nil)
                        print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                        
                       
                    }
                   
                case .done:
                    print("Reset completed")
                }
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "authError", message: "Reset password failed with error \(error)", preferredStyle: .alert)
    
                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
                        print(action)
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true, completion: nil)
                print("Reset password failed with error \(error)")
                }
                   
            }
        }
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextfield.text {
            signIn(email: email, password: password)
        }
    }
    
    
    @IBAction func signUpWithGooglePressed(_ sender: Any) {
        socialSignInWithWebUI()
    }
    
    
    
    func login(email: String, password: String) {
        _ = Amplify.Auth.signIn(username: email, password: password) {[weak self] result in
            switch result{
                
            case .success(let signInResult):
                print(signInResult)
                if signInResult.isSignedIn{
                DispatchQueue.main.async {
                    self?.sessionManager.getCurrentAuthUser()
                    self?.activitySpinner.startAnimating()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let secondVC = storyboard.instantiateViewController(identifier: "MainTabBarView")
//                    secondVC.modalPresentationStyle = .fullScreen
                    let navigationController = UINavigationController(rootViewController: secondVC)
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.show(navigationController, sender: self)
                }
                }
    
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "authError", message: "\(error)", preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
                        print(action)
                    }
                    alert.addAction(okayAction)
                    self?.present(alert, animated: true, completion: nil)
                    print(error.localizedDescription)
                }
               
            }
        }
    }
    
    func showLogin(){
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "yourVcName") as? UIViewController {
//                self.present(viewController, animated: true, completion: nil)
//            }
        let secondViewController = WelcomeViewController()
        self.present(secondViewController, animated: true, completion: nil)
        
    }
    
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
            case .success(let signInResult):
                if signInResult.isSignedIn {
                    DispatchQueue.main.async {[weak self] in
                        self?.sessionManager.getCurrentAuthUser()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let secondVC = storyboard.instantiateViewController(identifier: "MainTabBarView")
                        let navigationController = UINavigationController(rootViewController: secondVC)
//                        navigationController.show(secondVC, sender: self)
                        self?.window.rootViewController = navigationController
                        
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
                    self.present(alert, animated: true, completion: nil)
                    
                    print("Sign in failed \(error)")
                }
                
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Amplify.Auth.signIn(username: email, password: password) {[weak self] result in
            do {
                    username1 = email
                    let signinResult = try result.get()
                    switch signinResult.nextStep {
                    case .confirmSignInWithSMSMFACode(let deliveryDetails, let info):
                        print("SMS code send to \(deliveryDetails.destination)")
                        print("Additional info \(String(describing: info))")
                        DispatchQueue.main.async {[weak self] in
                            
                            self?.presentAlert(withTitle: "SMS code", message: "SMS code send to \(deliveryDetails.destination).Additional info \(String(describing: info))", actions: ["OK" : UIAlertAction.Style.default])
                        }

                        // Prompt the user to enter the SMSMFA code they received
                        // Then invoke `confirmSignIn` api with the code
                    
                    case .confirmSignInWithCustomChallenge(let info):
                        print("Custom challenge, additional info \(String(describing: info))")
                        DispatchQueue.main.async {[weak self] in
                            
                            self?.presentAlert(withTitle: "Custom challenge", message: "Custom challenge, additional info \(String(describing: info))", actions: ["OK" : UIAlertAction.Style.default])
                        }

                        // Prompt the user to enter custom challenge answer
                        // Then invoke `confirmSignIn` api with the answer
                    
                    case .confirmSignInWithNewPassword(let info):
                        print("New password additional info \(String(describing: info))")
                        DispatchQueue.main.async {[weak self] in
                            
                            self?.sessionManager.getCurrentAuthUser()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let secondVC = storyboard.instantiateViewController(identifier: "ConfirmationPassword")
                            let navigationController = UINavigationController(rootViewController: secondVC)
    //                        navigationController.show(secondVC, sender: self)
                            self?.window.rootViewController = navigationController
                            secondVC.presentAlert(withTitle: "New password additional info", message: "Please complete Mobiscout User Password change. by entering the additional info \(String(describing: info))", actions: ["OK" : UIAlertAction.Style.default])
                        }
                        // Prompt the user to enter a new password
                        // Then invoke `confirmSignIn` api with new password
                    
                    case .resetPassword(let info):
                        print("Reset password additional info \(String(describing: info))")
                        DispatchQueue.main.async {[weak self] in
                            
                            self?.sessionManager.getCurrentAuthUser()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let secondVC = storyboard.instantiateViewController(identifier: "ConfirmationPassword")
                            let navigationController = UINavigationController(rootViewController: secondVC)
    //                        navigationController.show(secondVC, sender: self)
                            self?.window.rootViewController = navigationController
                            secondVC.presentAlert(withTitle: "Reset password additional info", message: "Please complete Mobiscout User Password change. by entering the additional info \(String(describing: info))", actions: ["OK" : UIAlertAction.Style.default])
                        }
                        // User needs to reset their password.
                        // Invoke `resetPassword` api to start the reset password
                        // flow, and once reset password flow completes, invoke
                        // `signIn` api to trigger signin flow again.
                    
                    case .confirmSignUp(let info):
                        print("Confirm signup additional info \(String(describing: info))")
                        DispatchQueue.main.async {
                            self?.presentAlertController()
                        }
                        
                        // User was not confirmed during the signup process.
                        // Invoke `confirmSignUp` api to confirm the user if
                        // they have the confirmation code. If they do not have the
                        // confirmation code, invoke `resendSignUpCode` to send the
                        // code again.
                        // After the user is confirmed, invoke the `signIn` api again.
                    case .done:
                        DispatchQueue.main.async { [weak self] in
                            self?.sessionManager.getCurrentAuthUser()
                            self?.activitySpinner.startAnimating()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let secondVC = storyboard.instantiateViewController(identifier: "MainTabBarView")
        //                    secondVC.modalPresentationStyle = .fullScreen
                            let navigationController = UINavigationController(rootViewController: secondVC)
                            navigationController.modalPresentationStyle = .fullScreen
                            self?.show(navigationController, sender: self)
                        }
                        
                        // Use has successfully signed in to the app
                        print("Signin complete")
                    }
                } catch {
                    print ("Sign in failed \(error)")
                    DispatchQueue.main.async { [weak self] in
                        self?.sessionManager.getCurrentAuthUser()
                        self?.activitySpinner.startAnimating()
                        self?.presentAlert(withTitle: "Sign in failed", message: "\(error)", actions: ["OK" : UIAlertAction.Style.default])
                        self?.activitySpinner.stopAnimating()
                    }
                    
                }
        }
    }
    
    
    func presentAlertController() {
        let alertController = UIAlertController(title: "Cormfirmation Incomplete",
                                                message: "Please complete Mobiscout Registration by entering the confirmation code sent to \(username1) else tap resend to send another code.",
                                                preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Confirmation code"
        }
        
        let continueAction = UIAlertAction(title: "Confirm",
                                           style: .default) { [weak alertController] _ in
                                            guard let textFields = alertController?.textFields else { return }
                                            
                                            if let emailText = self.emailTextField.text,
                                                let confirmationCodeText = textFields[0].text {
                                                self.confirm(username: emailText, code: confirmationCodeText)
                                            }
        }
        
        let resendCodeAction = UIAlertAction(title: "Resend", style: .default){
            (action) in
            self.resendCode()
        }
        
        
        alertController.addAction(resendCodeAction)
        alertController.addAction(continueAction)
        self.present(alertController,
                     animated: true)
    }
    
    func confirm(username: String, code: String) {
        
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code) { [weak self] result in
            switch result {
            case.success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete {

//                    DispatchQueue.main.async { [weak self] in
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let secondVC = storyboard.instantiateViewController(identifier: "LogInView")
//
//                        self?.show(secondVC, sender: self)
//                    }
                    DispatchQueue.main.async { [weak self] in

                        let alert = UIAlertController(title: "Confirmation success", message: "User Succesfully authenticated", preferredStyle: .alert)

                        let okayAction = UIAlertAction(title: "OK", style: .default){
                            (action) in
                            
                                self?.sessionManager.getCurrentAuthUser()
                                self?.activitySpinner.startAnimating()
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let secondVC = storyboard.instantiateViewController(identifier: "MainTabBarView")
            //                    secondVC.modalPresentationStyle = .fullScreen
                                let navigationController = UINavigationController(rootViewController: secondVC)
                                navigationController.modalPresentationStyle = .fullScreen
                                self?.show(navigationController, sender: self)
                            


                        }
                        alert.addAction(okayAction)
                        self?.present(alert, animated: true, completion: nil)


                    }
                }
            
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "authError", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
    //                    print(action)
                    }
                    alert.addAction(okayAction)
                    self?.present(alert, animated: true, completion: nil)
                    print("failed to confirm code:", error)
                }
                
            }
            
        }
    }
    
    func resendCode() {
        Amplify.Auth.resendConfirmationCode(for: .email) { [weak self] result in
            switch result {
            case .success(let deliveryDetails):
                print("Resend code send to - \(deliveryDetails)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Resend code", message: "Resend code send to - \(deliveryDetails)", preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
    //                    print(action)
                    }
                    alert.addAction(okayAction)
                    self?.present(alert, animated: true, completion: nil)
                    print("Resend code send to - \(deliveryDetails)")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Resend code error", message: "Resend code failed with error \(error)", preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
    //                    print(action)
                    }
                    alert.addAction(okayAction)
                    self?.present(alert, animated: true, completion: nil)
                    print("Resend code failed with error \(error)")
                }
               
            }
        }
    }
    
    
//    @IBAction func logInWithGooglePressed(_ sender: GIDSignInButton) {
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.signIn()
//    }
    
    
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
////         Check for sign in error
//            if let error = error {
//                if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
//                    print("The user has not signed in before or they have since signed out.")
//                } else {
//                    print("\(error.localizedDescription)")
//                }
//                return
//            }
//        print(user.profile.email as Any)
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
//                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
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
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//
//
//        if let error = error {
//                    let alert = UIAlertController(title: "authError", message: error.localizedDescription, preferredStyle: .alert)
//
//                    let okayAction = UIAlertAction(title: "OK", style: .default){
//                        (action) in
//                        print(action)
//                    }
//                    alert.addAction(okayAction)
//                    self.present(alert, animated: true, completion: nil)
//                    print(error.localizedDescription)
//           return
//         }
//         guard let email = user.profile.email else { return }
//
//        Auth.auth().fetchSignInMethods(forEmail: email) { FIREmailAuthProvider, Error in
//            if let e = Error{
//                print(e)
//            }
//            if let providers = FIREmailAuthProvider {
//                if providers.count > 0 {
//                    // Get credential object using Google ID token and Google access token
//                    guard let authentication = user.authentication else {
//                        return
//                    }
//                    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                                   accessToken: authentication.accessToken)
//
//                    // Authenticate with Firebase using the credential object
//                    Auth.auth().signIn(with: credential) { (authResult, error) in
//                        if let error = error {
//                            let alert = UIAlertController(title: "authError", message: error.localizedDescription, preferredStyle: .alert)
//
//                            let okayAction = UIAlertAction(title: "OK", style: .default){
//                                (action) in
//                                print(action)
//                            }
//                            alert.addAction(okayAction)
//                            self.present(alert, animated: true, completion: nil)
//                            print(error.localizedDescription)
//                        } else{
//                            self.performSegue(withIdentifier: K.loginSegue, sender: self)
//                            print("user exist")
//                        }
//
//
//                    }
//                }
//            } else{
//                let alert = UIAlertController(title: "authError", message: "User does not Exists in our database. Please join Us", preferredStyle: .alert)
//
//                let okayAction = UIAlertAction(title: "OK", style: .default){
//                    (action) in
//                    print(action)
//                }
//                alert.addAction(okayAction)
//                self.present(alert, animated: true, completion: nil)
//                  print("user does not exist")
//
//            }
//        }
//    }
//}


//Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//    if let e = error {
//        let alert = UIAlertController(title: "authError", message: e.localizedDescription, preferredStyle: .alert)
//
//        let okayAction = UIAlertAction(title: "OK", style: .default){
//            (action) in
//            print(action)
//        }
//        alert.addAction(okayAction)
//        self.present(alert, animated: true, completion: nil)
//        print(e.localizedDescription)
//    } else {
////                    self.activitySpinner.isHidden = false
//        self.activitySpinner.startAnimating()
//        self.performSegue(withIdentifier: K.loginSegue, sender: self)
//
//    }
//}


//        let auth = Auth.auth()
//
//        if let email = emailTextField.text{
//            auth.sendPasswordReset(withEmail: email) { (error) in
//                if let e = error{
//                    let alert = UIAlertController(title: "authError", message: e.localizedDescription, preferredStyle: .alert)
//
//                    let okayAction = UIAlertAction(title: "OK", style: .default){
//                        (action) in
//                        print(action)
//                    }
//                    alert.addAction(okayAction)
//                    return
//                } else {
//                    let alert = UIAlertController(title: "authError", message: "A password reset has been sent to: \(email)", preferredStyle: .alert)
//
//                    let okayAction = UIAlertAction(title: "OK", style: .default){
//                        (action) in
//                        print(action)
//                    }
//                    alert.addAction(okayAction)
//                }
//            }
//        } else{
//            let alert = UIAlertController(title: "authError", message: "Please input your email", preferredStyle: .alert)
//
//            let okayAction = UIAlertAction(title: "OK", style: .default){
//                (action) in
//                print(action)
//            }
//            alert.addAction(okayAction)
//            return
        }
