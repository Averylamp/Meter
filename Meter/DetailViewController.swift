//
//  DetailViewController.swift
//  Meter
//
//  Created by Avery Lamp on 6/3/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, MapDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    //MARK: - Map Delegate
    func pinClicked(spot: Spot) {
        print("Spot - \(spot.name), \(spot.number)")
    }
    
    func pinDeselected(spot:Spot){
        print("Deselected Spot - \(spot.name), \(spot.number)")
    }
    
    
}
