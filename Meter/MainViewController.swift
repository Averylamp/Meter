//
//  MainViewController.swift
//  Meter
//
//  Created by Avery Lamp on 5/21/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var mapVC: MapViewController?
    var detailVC: DetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    
    func setDelegates(){
        if let mapVC = mapVC, let detailVC = detailVC{
            mapVC.delegate = detailVC
        }
        
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapVC"{
            if let embededMapVC = segue.destination as? MapViewController{
                mapVC = embededMapVC
                setDelegates()
            }
        }
        if segue.identifier == "DetailVC"{
            if let embededDetailVC = segue.destination as? DetailViewController{
                detailVC = embededDetailVC
                setDelegates()
            }
        }
        
    }
    

}
