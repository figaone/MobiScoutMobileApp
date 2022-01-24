//
//  ConfirmViewController.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 11/23/21.
//

import UIKit
import SwiftUI
import Amplify

class ConfirmViewController: UIViewController, UITextFieldDelegate {
    
    let sessionManager = AmplifySessionManager()
    
    
    
    let username = username1
    @IBOutlet weak var userNameText: UILabel!
    
    @IBOutlet weak var confirmationCodeText: UITextField!
    
    @IBAction func resendConfirmCode(_ sender: Any) {
        resendCode()
    }
    
    @IBAction func confirmButtomPressed(_ sender: Any) {
         
//        sessionManager.confirm(username: username, code: confirmationCodeText.text ?? "" )
           confirm(username: username, code: confirmationCodeText.text ?? "" )
//
//            print(confirmationCodeText.text ?? "")
    }
    //    @IBAction func confirmButtomPressed(_ sender: Any) {
//        confirm(username: username, code: confirmationCodeText.text ?? "" )
//        
//        print(confirmationCodeText.text ?? "")
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
//        confirmationCode = confirmationCodeText.text ?? ""
        userNameText.text = "code sent to:\(username)"
        // Do any additional setup after loading the view.
        self.confirmationCodeText.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmationCodeText.resignFirstResponder()
        return true
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

                        let alert = UIAlertController(title: "Confirmation success", message: "User Succesfully authenticated. Touch ok to navigate to login screen", preferredStyle: .alert)

                        let okayAction = UIAlertAction(title: "OK", style: .default){
                            (action) in
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let secondVC = storyboard.instantiateViewController(identifier: "LogInView")

                                    self?.show(secondVC, sender: self)

//                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let secondVC = storyboard.instantiateViewController(identifier: "LogInView")
//                                    secondVC.modalPresentationStyle = .fullScreen
//                                    self?.show(secondVC, sender: self)


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

}
