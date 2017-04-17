//
//  LoginViewController.swift
//  Meter
//
//  Created by Avery Lamp on 3/18/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @IBAction func continueFacebookClicked(_ sender: Any) {
        facebookLogin()
    }
    
    func facebookLogin(){
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if let error = error {
                print("Facebook Login Error")
                print(error.localizedDescription)
                return
            }else if (result?.isCancelled)!{
                print("Login Cancled")
            }else{
                print("Facebook Login Successful")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                    if let error = error{
                        print("Error login into Firebase")
                        print(error.localizedDescription)
                    }else{
                        print("Successfully logged into Firebase")
                        print(user)
                        
                    }
                })
            }
            
        }
    }

    
}
