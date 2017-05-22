//
//  MainViewController.swift
//  Meter
//
//  Created by Avery Lamp on 5/21/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var detailView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailView.layer.shadowOpacity = 0.8
        self.detailView.layer.shadowRadius = 7
        self.detailView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Do any additional setup after loading the view.
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
