//
//  LenderSpotCoordinateViewController.swift
//  Meter
//
//  Created by Avery Lamp on 7/12/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
import MapKit

class LenderSpotCoordinateViewController: UIViewController {
    
    var spotPFObject: PFObject? = nil
    var addressLocation: CLLocationCoordinate2D? = nil
    var fullAddressText: String? = ""
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapTypeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.mapType = .satellite
        self.addressLabel.text = fullAddressText
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
    }
    
    func zoomToCoordinate(coordinate:CLLocationCoordinate2D, width: CLLocationDistance, animationTime: Double = 0.6){
        let span = MKCoordinateRegionMakeWithDistance(coordinate, width, width)
        UIView.animate(withDuration: animationTime) {
            self.mapView.setRegion(span, animated: true)
        }
    }
    
    @IBAction func centerButtonClicked(_ sender: Any) {
        if let addressLocation = addressLocation{
            zoomToCoordinate(coordinate: addressLocation, width: 200)
        }
    }
    
    @IBAction func switchMapTypeClicked(_ sender: Any) {
        if self.mapView.mapType == .satellite{
           self.mapView.mapType = .standard
            mapTypeButton.setTitle("Satellite", for: .normal)
        }else{
           self.mapView.mapType = .satellite
            mapTypeButton.setTitle("Normal", for: .normal)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}