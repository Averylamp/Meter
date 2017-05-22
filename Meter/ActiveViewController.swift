//
//  ActiveViewController.swift
//  FlightBites
//
//  Created by Avery Lamp on 5/24/16.
//  Copyright © 2016 David Jenkins. All rights reserved.
//

import UIKit

protocol ActiveViewControllerDelegate {
    func toggleLeftPanel()
    func collapseSidePanels()
}

class ActiveViewController: UIViewController {
    
    
    var delegate: ActiveViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ActiveViewController: SidePanelViewControllerDelegate{
    func newPageSelected(_ index: Int) {
        print("Page \(index) Selected")
    }
}
