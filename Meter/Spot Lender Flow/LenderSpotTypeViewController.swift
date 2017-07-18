//
//  LenderSpotTypeViewController.swift
//  Meter
//
//  Created by Avery Lamp on 7/12/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse

class LenderSpotTypeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    let spotTypes:[String] = ["Driveway", "Curbside", "Garage", "Parking Lot", "Alley", "Tandem"]
    @IBAction func learnMoreClicked(_ sender: Any) {
        
    }
    
    
}

extension LenderSpotTypeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SpotTypeCell", for: indexPath) as? SpotTypeTableViewCell{
            cell.typeLabel.text = spotTypes[indexPath.row]
            cell.tag = indexPath.row
            return cell
        }else{
            print("Error creating Spot Type Cell")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spotPFObject = PFObject(className: "Spot")
        spotPFObject.add(spotTypes[indexPath.row], forKey: "spotType")
        if let spotAddressVC = UIStoryboard(name: "LendSpot", bundle: nil).instantiateViewController(withIdentifier: "LendSpotAddressVC") as? LenderSpotAddressViewController{
            spotAddressVC.spotPFObejct = spotPFObject
            self.navigationController?.pushViewController(spotAddressVC, animated: true )
        }
    }
    
}
