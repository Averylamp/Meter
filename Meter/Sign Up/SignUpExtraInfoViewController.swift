//
//  SignUpExtraInfoViewController.swift
//  Meter
//
//  Created by Avery Lamp on 8/13/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
import SCLAlertView
import Alamofire
import SwiftyJSON

class SignUpExtraInfoViewController: UIViewController {

    var user: PFUser? = nil
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.loadPreviousValues()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpExtraInfoViewController.dismissKeyboards))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func dismissKeyboards(){
        if self.firstNameTextField.isFirstResponder{
            self.firstNameTextField.resignFirstResponder()
        }
        if self.lastNameTextField.isFirstResponder{
            self.lastNameTextField.resignFirstResponder()
        }
        if self.phoneNumberTextField.isFirstResponder{
            self.phoneNumberTextField.resignFirstResponder()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPreviousValues()
    }
    
    func loadPreviousValues(){
        if let user = user{
            if let firstName = user[UserKeys.FirstName] as? String{
                firstNameTextField.text = firstName
            }
            if let lastName = user[UserKeys.LastName] as? String{
                lastNameTextField.text = lastName
            }
            if let phoneNumber = user[UserKeys.PhoneNumber] as? String{
                phoneNumberTextField.text = phoneNumber
            }
        }
    }
    
    func updateValues(){
        if let user = user{
            var changed = false
            if let firstName = firstNameTextField.text, firstName != "", user[UserKeys.FirstName] as? String != firstName{
                user[UserKeys.FirstName] = firstName
                changed = true
            }
            if let lastName = lastNameTextField.text, lastName != "", user[UserKeys.LastName] as? String != lastName{
                user[UserKeys.LastName] = lastName
                changed = true
            }
            if let phoneNumber = phoneNumberTextField.text, phoneNumber != "", user[UserKeys.PhoneNumber] as? String != phoneNumber{
                user[UserKeys.PhoneNumber] = phoneNumber
                changed = true
            }
            if let firstName = firstNameTextField.text, firstName != "", let lastName = lastNameTextField.text, lastName != "", user[UserKeys.Name] as? String != "\(firstName) \(lastName)" {
                user[UserKeys.Name] = "\(firstName) \(lastName)"
                changed = true
            }
            if changed{
                user.saveInBackground()
            }
        }
    }

    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        self.updateValues()
        if validateFields(){
            print("Fields checked out okay")
        }
    }
    
    func validateFields() -> Bool{
        if firstNameTextField.text == ""{
            self.showAlert(alert: "Please fill out your first name", alertTitle: "First Name Missing")
            return false
        }
        if lastNameTextField.text == ""{
            self.showAlert(alert: "Please fill out your last name", alertTitle: "Last Name Missing")
            return false
        }
        if phoneNumberTextField.text == ""{
            self.showAlert(alert: "Please fill out your phone number", alertTitle: "Phone Number Missing")
            return false
        }else{
            let parameters = ["api_key": "ZG9ZjlvdmFNM6j2N6QDxHVWEDddYPeZv",
                              "via":"sms",
                              "country_code":"1",
                              "phone_number":self.phoneNumberTextField.text!,
                              "code_length":"4"]
            Alamofire.request("https://api.authy.com/protected/json/phones/verification/start", method: .post, parameters: parameters).responseJSON{ (response) in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    if let sentMessage = json["success"].bool {
                        if sentMessage{
                            DispatchQueue.main.async {
                                if let phoneConfirmationVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpPhoneConfirmationVC") as? SignUpPhoneConfirmationViewController{
                                    phoneConfirmationVC.user = self.user
                                    self.navigationController?.pushViewController(phoneConfirmationVC, animated: true)
                                }
                            }
                        }else{
                            self.showAlert(alert: "Failed to send confirmation code to \(self.phoneNumberTextField.text!)", alertTitle: "Invalid Phone Number")
                        }
                    }
                    print("Sent SMS \(json)")
                case .failure(let error):
                    print("Error sending Text message\(error)")
                }
            }
        }
        return true
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
}

extension SignUpExtraInfoViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateValues()
        if let nextResponder = self.view.viewWithTag(textField.tag + 1) as? UITextField{
            nextResponder.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
            UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin.y = 0
            })
            self.continueButtonClicked(UIButton())
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            if textField.tag == 11{
                self.view.frame.origin.y = -80
            }else if textField.tag == 12{
                self.view.frame.origin.y = -160
            }else{
                self.view.frame.origin.y = 0
            }
        })
    }
}
