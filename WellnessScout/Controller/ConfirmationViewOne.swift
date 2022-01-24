//
//  ConfirmationView.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 11/14/21.
//

import Foundation
import UIKit
import SwiftUI
import Amplify

class ConfirmationViewOne: UIViewController, UITextFieldDelegate{
    @EnvironmentObject var sessionManager : AmplifySessionManager
    
    let username = username2
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var newPasswordText: UITextField!
    
    @IBOutlet weak var confirmCodeText: UITextField!
    
    @IBAction func confirmCodeButtonPressed(_ sender: Any) {
        if let username = UserNameLabel.text, let newPass = newPasswordText.text, let confirmcode = confirmCodeText.text{
            confirmResetPassword(username: username, newPassword: newPass , confirmationCode: confirmcode)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNameLabel.text = username
        self.newPasswordText.delegate = self
        self.confirmCodeText.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newPasswordText.resignFirstResponder()
        confirmCodeText.resignFirstResponder()
        return true
    }
    
    func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) {
        Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode
        ) { result in
            switch result {
            case .success:
                print("Password reset confirmed")
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "Password Reset Successful", message: "Password reset confirmed", preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
                        self.navigationController?.popToRootViewController( animated: true)
    //                    print(action)
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true, completion: nil)

                    
                }
            case .failure(let error):
                print("Reset password failed with error \(error)")
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "authError", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default){
                        (action) in
    //                    print(action)
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
}
