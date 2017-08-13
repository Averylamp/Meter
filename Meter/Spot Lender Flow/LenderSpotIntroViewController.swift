//
//  LenderSpotIntroViewController.swift
//  Meter
//
//  Created by Avery Lamp on 8/13/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class LenderSpotIntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NavigationNotifications.toggleMenu), object: nil)
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        if let spotTypeVC = UIStoryboard(name: "LendSpot", bundle: nil).instantiateViewController(withIdentifier: "SpotTypeVC") as? LenderSpotTypeViewController{
            self.navigationController?.pushViewController(spotTypeVC, animated: true )
        }
    }
    
}
