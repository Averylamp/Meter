//
//  SignUpPhoneConfirmationViewController.swift
//  Meter
//
//  Created by Avery Lamp on 8/13/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import SwiftyJSON
import SCLAlertView
import FaveButton


class SignUpPhoneConfirmationViewController: UIViewController {
    
    @IBOutlet weak var checkMark: FaveButton!
    
    @IBOutlet weak var confirmationTextField: UITextField!
    
    var user: PFUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmationTextField.delegate = self
        self.confirmationTextField.addTarget(self, action: #selector(SignUpPhoneConfirmationViewController.confirmPhoneNumber), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpPhoneConfirmationViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboard(){
        if confirmationTextField.isFirstResponder {
            confirmationTextField.resignFirstResponder()
        }
    }
    
    var confirmingPhoneNumber = false
    
    func confirmPhoneNumber(){
        let confirmationCode = confirmationTextField.text!
        if confirmationCode.characters.count == 4, let user = user, let phoneNumber = user[UserKeys.PhoneNumber] as? String, confirmingPhoneNumber == false{
            confirmingPhoneNumber = true
            let parameters = ["api_key": "ZG9ZjlvdmFNM6j2N6QDxHVWEDddYPeZv",
                              "country_code":"1",
                              "phone_number": phoneNumber,
                              "verification_code":confirmationCode]
            Alamofire.request("https://api.authy.com/protected/json/phones/verification/check", method: .get, parameters: parameters ).responseJSON{ (response) in
                self.confirmingPhoneNumber = false
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    if let sentMessage = json["success"].bool {
                        if sentMessage{
                            user[UserKeys.PhoneVerified] = true
                            user.saveInBackground()
                            DispatchQueue.main.async {
                                self.checkMark.isSelected = true
                                self.delay(2.0, closure: {
                                    if let completedVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpCompletedVC") as? SignUpCompletedViewController{
                                        self.navigationController?.pushViewController(completedVC, animated: true)
                                    }
                                })
                                
                            }
                        }else{
                            if let errorMessage = json["message"].string{
                                self.showAlert(alert: errorMessage, alertTitle: "Verification Failed")
                            }
                        }
                    }
                    print("Sent SMS \(json)")
                case .failure(let error):
                    print("Error sending Text message\(error)")
                }
            }
        }
    }
    
    func showAlert(alert:String, alertTitle: String = "Field Missing"){
        print("Alert Recieved \n\(alert)")
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Avenir-Medium", size: 20)!,
            kTextFont: UIFont(name: "Avenir-Roman", size: 14)!,
            kButtonFont: UIFont(name: "Avenir-Heavy", size: 14)!,
            showCloseButton: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showNotice(alertTitle, subTitle: alert)
    }
    
    func finishedSignUp(){
        if let allSetVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpCompletedVC") as? SignUpCompletedViewController{
            self.user?.saveInBackground()
            self.navigationController?.pushViewController(allSetVC, animated: true)
        }
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignUpPhoneConfirmationViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullCode = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        print(fullCode)
        if fullCode.characters.count > 4{
            return false
        }
        return true
    }
    
}
