//
//  SettingsViewController.swift
//  Meter
//
//  Created by Avery Lamp on 7/17/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var signOutButton: UIButton!
    
    @IBAction func signOutButtonClicked(_ sender: Any) {
        if PFUser.current() != nil{
            PFUser.logOut()
            NotificationCenter.default.post(name: ReturnToLoginNotificationName, object: nil)
            
        }
    }
    
}
