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

class LoginViewController: UIViewController {
    enum State {
        case Login
        case Signup
    }
    
    var state: State = .Login
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        checkForLogin()
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
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if let registerVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as? SignUpViewController{
            self.navigationController?.setViewControllers([registerVC], animated: true)
        }
    }
    
}
