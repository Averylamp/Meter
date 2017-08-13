//
//  SignUpCompletedViewController.swift
//  Meter
//
//  Created by Avery Lamp on 8/13/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class SignUpCompletedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func getStartedClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "MainVCSegue", sender: nil)
        
    }
}
