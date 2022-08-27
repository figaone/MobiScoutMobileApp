//
//  TermsOfUse.swift
//  WellnessScout
//
//  Created by Sharma, Anuj [CCE E] on 11/3/21.
//

import UIKit

class TermsOfUseViewController: UIViewController{
    let sessionManager  = AmplifySessionManager()
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = true // or false to disable rotation
    }
    
    @IBAction func acceptAgreementPressed(_ sender: Any) {
        sessionManager.showSignUp()
    }
    @IBAction func declineButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "LogInView")
        secondVC.modalPresentationStyle = .fullScreen
        self.show(secondVC, sender: self)
    }
   
}
