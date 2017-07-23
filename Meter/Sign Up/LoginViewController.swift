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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func continueFacebookClicked(_ sender: Any) {
        facebookParseLogin()
//        facebookFirebaseLogin()
    }
    
    var progressHUD = MBProgressHUD()
    //
    //    func facebookLogin() {
    //        let permissions = ["email","user_birthday"]
    //        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    //        progressHUD.mode = .indeterminate
    //        progressHUD.labelText = "Logging in with Facebook"
    //        progressHUD.color = UIColor(white: 1.0, alpha: 1.0)
    //        progressHUD.labelColor = UIColor.darkGray
    //        progressHUD.detailsLabelText = ""
    //        progressHUD.detailsLabelColor = UIColor.darkGray
    //        progressHUD.activityIndicatorColor = UIColor.darkGray
    //        progressHUD.dimBackground = true
    //        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
    //
    //            if let user = user {
    //                if user.isNew {
    //                    self.progressHUD.labelText = "Logging in with Facebook"
    //                    self.progressHUD.detailsLabelText = "Login & Signup Successful"
    //                    self.delay(1.0, closure: {
    //                        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    //                    })
    //                    print("User signed up and logged in through Facebook!")
    //                    //populate user email
    //                    let params = ["fields":"name, email, first_name, last_name, birthday, gender"]
    //                    let request = FBSDKGraphRequest(graphPath: "me", parameters: params)
    //                    request?.start(completionHandler: { (connection, result, error) -> Void in
    //                        if ((error) != nil)
    //                        {
    //                            // Process error
    //                            print("Error: \(error)")
    //                        }else {
    //                            let userData = result as! NSDictionary
    //                            user["name"] = userData.value(forKey: "name") as? String
    //                            user["email"] = userData.value(forKey: "email") as? String
    //                            print(userData)
    //                            user.saveInBackground()
    //                            let customer = PFObject(className: "Customer")
    //                            customer["user"] = user
    //                            //                            customer["fullName"] = user["name"]
    //                            customer["firstName"] = userData.value(forKey: "first_name") as? String
    //                            customer["gender"] = userData.value(forKey: "gender") as? String
    //                            customer["lastName"] = userData.value(forKey: "last_name") as? String
    //                            customer["birthday"] = userData.value(forKey: "birthday") as? String
    //                            customer["avatar"] = "https://graph.facebook.com/\(userData.value(forKey: "id") as? String)/picture?type=large"
    //                            customer.saveInBackground()
    //                        }
    //                        self.checkForUserLogin()
    //                    })
    //                } else {
    //                    print("User logged in through Facebook!")
    //
    //                    self.progressHUD.labelText = "Logging in with Facebook"
    //                    self.progressHUD.detailsLabelText = "Login Successful"
    //                    self.checkForUserLogin()
    //                }
    //            } else {
    //                self.progressHUD.labelText = "Logging in with Facebook"
    //                self.progressHUD.detailsLabelText = "Login Cancled"
    //                self.delay(1.0, closure: {
    //                    MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    //                })
    //                print("Uh oh. The user cancelled the Facebook login.")
    //            }
    //        }
    //
    //    }
    //
    
    func facebookParseLogin(){
        let token = FBSDKAccessToken.current()
        PFFacebookUtils.logInInBackground(withReadPermissions: ["email", "public_profile",]) { (user, error) in
            if error == nil{
                print("Logged in successfully \(user)")
            }else{
                print("Error logging in \(error)")
            }
        }
//        PFFacebookUtils.logInInBackground(with: FBSDKAccessToken.current()) { (user, error) in
//            print("User logged in ")
//            if error == nil{
//                print(user)
//            }else{
//                print("Error loggin in \(error)")
//            }
//        }
        
        
    }
    
    
    func facebookFirebaseLogin(){
//
//        let loginManager = FBSDKLoginManager()
//        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
//            if let error = error {
//                print("Facebook Login Error")
//                print(error.localizedDescription)
//                return
//            }else if (result?.isCancelled)!{
//                print("Login Cancled")
//            }else{
//                print("Facebook Login Successful")
//                print("PFUser - \(PFUser.current())")
//                let fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, email"])
//                fbRequest?.start(completionHandler: { (connection, result, error) in
//                    print(result)
//                    let email = (result as! [String:String]) ["email"]!
//                    let username = email
//                    let name = (result as! [String:String]) ["name"]!
//                    let password = "\((result as! [String:String]) ["id"]!)"
//                    //                    let password = FBSDKAccessToken.current().tokenString
//                    print("Password - \(password)")
//                    PFUser.logInWithUsername(inBackground: username  , password: password, block: { (user, error) in
//                        print("RESULTS")
//                        if let error = error{
//                            let newUser = PFUser()
//                            newUser.username = username
//                            newUser.email = email
//                            newUser.setValue(name, forKey: "name")
//                            newUser.password = password
//                            newUser.signUpInBackground(block: { (succeededSignUp, error) in
//                                if let error = error{
//                                    print("Sign up error - \(error)")
//                                }else{
//                                    print("Sign up complete - \(succeededSignUp)")
//                                }
//                            })
//                            self.getProfilePicture()
//                            print(error)
//                        }else{
//                            self.getProfilePicture()
//                            print("Successfully logged into Facebook")
//                            print(user)
//                        }
//                    })
//                })
//
//                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//                Auth.auth().signIn(with: credential, completion: { (user, error) in
//                    if let error = error{
//                        print("Error login into Firebase")
//                        print(error.localizedDescription)
//                    }else{
//                        print("Successfully logged into Firebase")
//                        self.performSegue(withIdentifier: "MainMenuSegue", sender: self)
//                        print(user)
//
//
//                    }
//                })
//            }
//
//        }
    }
    
    func getProfilePicture(){
        if let currentUser = PFUser.current() {
            DispatchQueue.global().async {
                do{
                        try currentUser.fetchIfNeeded()
                }catch{
                    print("Failed to fetch current user \(error.localizedDescription)")
                }
            }
            if currentUser["profilePicture"] == nil{
                let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
                pictureRequest?.start(completionHandler: { (connection, result, error) in
                    if error == nil, let resultDict = result as? [String: Any], let innerDict = resultDict["data"] as? [String:Any],  let imageURLStr = innerDict["url"] as? String, let imageURL = URL(string:imageURLStr){
                        do {
                            let imageData = try Data(contentsOf: imageURL)
                            if let imagePFFile = PFFile(data: imageData){
                                currentUser["profilePicture"] = imagePFFile
                                currentUser.saveInBackground()
                            }
                        }catch{
                            print("Error retrieving Profile Picture \(error)")
                        }
                    
                        print("\(result)")
                    } else {
                        print("\(error)")
                    }
                })
            }
            
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if let registerVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as? SignUpViewController{
            self.navigationController?.setViewControllers([registerVC], animated: true)
            
        }
    }
    
}
