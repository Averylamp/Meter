//
//  LoginViewController.swift
//  Meter
//
//  Created by Avery Lamp on 3/18/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
import MBProgressHUD
import Parse


class LoginViewController: UIViewController {
    enum State {
        case Login
        case Signup
    }
    
    var state: State = .Signup
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var pinTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var switchStateButton: UIButton!
    @IBOutlet weak var switchStateSubtitleLabel: UILabel!
    
    @IBOutlet weak var loginSignupButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stateChanged()
//        checkForLogin()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboards))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.emailTextField.delegate = self        
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        facebookLoginButton.layer.borderColor = Constants.Colors.blueHighlight.cgColor
    }
    
    func dismissKeyboards(){
        if self.emailTextField.isFirstResponder{
            self.emailTextField.resignFirstResponder()
        }
        if self.passwordTextField.isFirstResponder{
            self.passwordTextField.resignFirstResponder()
        }
        if self.confirmPasswordTextField.isFirstResponder{
            self.confirmPasswordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func continueFacebookClicked(_ sender: Any) {
        facebookParseLogin()
    }
    
    func checkForLogin(){
        if  PFUser.current() != nil, FBSDKAccessToken.current() != nil{
            print("Already logged in")
            self.goToMainVC()
        }
    }
    
    func facebookParseLogin(){
        PFFacebookUtils.logInInBackground(withReadPermissions: ["email", "public_profile", "user_location"]) { (user, error) in
            if error == nil, let user = user{
                if user.isNew{
                    print("----- NEW USER -----")
                }
                print("Logged in successfully \(user)")
                let fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, email, picture.height(500), age_range, gender, first_name, last_name, location"])
                fbRequest?.start(completionHandler: { (connection, result, error) in
                    if error == nil{
                        if let result = result as? [String:Any]{
                            print(result)
                            if user["profilePicture"] as? PFFile != nil{
                                self.goToMainVC()
                                return
                            }
                            if let email = result["email"] as? String{
                                user.email = email
                                user.username = email
                            }
                            if let name = result["name"] as? String{
                                user["name"] = name
                            }
                            if let firstName = result["first_name"] as? String{
                                user["firstName"] = firstName
                            }
                            if let lastName = result["last_name"] as? String{
                                user["lastName"] = lastName
                            }
                            if let gender = result["gender"] as? String{
                                user["gender"] = gender
                            }
                            if let ageRange = result["age_range"] as? [String:Any], let maxAge = ageRange["max"] as? Int,let minAge = ageRange["min"] as? Int{
                                user["ageRange"] = [minAge,maxAge]
                            }
                            if let location = result["location"] as? [String:Any], let locationName = location["name"] as? String{
                                user["facebookLocation"] = locationName
                            }
                            if let resultDict = result["picture"] as? [String: Any], let innerDict = resultDict["data"] as? [String:Any],  let imageURLStr = innerDict["url"] as? String, let imageURL = URL(string:imageURLStr){
                                DispatchQueue.global().async {
                                    do {
                                        let imageData = try Data(contentsOf: imageURL)
                                        if let imagePFFile = PFFile(data: imageData){
                                            user["profilePicture"] = imagePFFile
                                            user.saveInBackground()
                                            self.delay(0.0, closure: {
                                                self.goToMainVC()
                                            })
                                        }
                                    }catch{
                                        print("Error retrieving Profile Picture \(error)")
                                    }
                                }
                            } else {
                                print("Unable to get profile picture")
                            }
                            user.saveInBackground()
                            
                        }
                    }else{
                        print("Error getting info \(error)")
                    }
                    
                })
            }else{
                print("Error logging in \(error)")
            }
        }
        
    }
    
    func goToMainVC(){
        self.performSegue(withIdentifier: "LoginToMainVCSegue", sender: self)
    }
    
    func stateChanged(){
        if self.state == .Signup{
            self.switchStateButton.setTitle("Log In", for: .normal)
            self.loginSignupButton.setTitle("SIGN UP", for: .normal)
            UIView.transition(with: self.switchStateSubtitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.switchStateSubtitleLabel.text = "Already a member"
            }, completion: nil)
            UIView.transition(with: self.titleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.titleLabel.text = "Sign up for Meter"
            }, completion: nil)
            UIView.animate(withDuration: 0.4, animations: {
                self.confirmPasswordFieldHeightConstraint.constant = 80
                self.pinTopLayoutConstraint.constant = 10
                self.view.layoutIfNeeded()
            })
        }else{
            self.switchStateButton.setTitle("Sign Up", for: .normal)
            self.loginSignupButton.setTitle("LOG IN", for: .normal)
            UIView.transition(with: self.switchStateSubtitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.switchStateSubtitleLabel.text = "Not a member"
            }, completion: nil)
            UIView.transition(with: self.titleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.titleLabel.text = "Log in to Meter"
            }, completion: nil)
            UIView.animate(withDuration: 0.4, animations: {
                self.confirmPasswordFieldHeightConstraint.constant = 0
                self.pinTopLayoutConstraint.constant = 50
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func toggleStateClicked(_ sender: Any) {
        if self.state == .Login{
            self.state = .Signup
        }else{
            self.state = .Login
        }
        self.stateChanged()
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        print("Login/Signup Clicked")
        switch self.state {
        case .Login:
            loginUser()
        case .Signup:
            signUpUser()
        default:
            break
        }
    }
    
    func signUpUser(){
        let validation = self.validateSignup()
        if validation.0 {
            let user = PFUser()
            user.username = self.emailTextField.text!
            user.email = self.emailTextField.text!
            user.password = self.passwordTextField.text!
            user.signUpInBackground(block: { (success, error) in
                if let error = error {
                    
                    let errorString = error.localizedDescription
                    self.showError(error: errorString)
                }else{
                    self.continueSignUp()
                }
            })
        }else{
            showError(error: validation.1)
        }
    }
    
    func continueSignUp(){
        if let extraInfoVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpExtraInfoVC") as? SignUpExtraInfoViewController{
            
            self.navigationController?.pushViewController(extraInfoVC, animated: true)
            
        }
        
    }
    
    func validateSignup() -> (Bool, String){
        
        
        
        return (true, "")
    }
    
    func showError(error:String){
        print("Error Recieved \n\(error)")
        
    }
    
    func loginUser(){
        
    }
    
    @IBAction func skipLoginClicked(_ sender: Any) {
        self.goToMainVC()
    }
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = self.view.viewWithTag(textField.tag + 1) as? UITextField{
            if self.state == .Login && nextResponder == self.confirmPasswordTextField{
                textField.resignFirstResponder()
                self.actionButtonClicked(self.loginSignupButton)
            }else{
                nextResponder.becomeFirstResponder()
            }
        }else{
            textField.resignFirstResponder()
            self.actionButtonClicked(self.loginSignupButton)
        }
        return true
    }
    
    
    
}
