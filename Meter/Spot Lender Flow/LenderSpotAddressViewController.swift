//
//  LenderSpotAddressViewController.swift
//  Meter
//
//  Created by Avery Lamp on 7/12/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces

class LenderSpotAddressViewController: UIViewController {

    var spotPFObject: PFObject? = nil
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var firstLocationUpdate = true
    var currentPlace: GMSPlace? = nil
    
    
    @IBOutlet weak var continueButtonHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocationAuthorization()
        textField.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
    }
    
    func setupLocationAuthorization(){
        if CLLocationManager.locationServicesEnabled(){
            print("Location services active")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func centerLocationClicked(_ sender: Any) {
        centerToCurrentLocation()
    }
    
    func checkForContinue(){
        if let currentPlace = currentPlace {
            spotPFObject!["fullAddress"] = currentPlace.formattedAddress
            spotPFObject!["location"] = PFGeoPoint(latitude: currentPlace.coordinate.latitude, longitude: currentPlace.coordinate.longitude)
            UIView.animate(withDuration: 0.5, animations: {
                self.continueButtonHeightConstraint.constant = 40
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func centerToCurrentLocation() {
        if let currentLocation = locationManager.location?.coordinate{
            self.zoomToCoordinate(coordinate: currentLocation, width: 1500, animationTime: 1.0)
        }
    }
    
    func zoomToCoordinate(coordinate:CLLocationCoordinate2D, width: CLLocationDistance, animationTime: Double = 0.6){
        let span = MKCoordinateRegionMakeWithDistance(coordinate, width, width)
        UIView.animate(withDuration: animationTime) {
            self.mapView.setRegion(span, animated: true)
        }
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        if let currentPlace = currentPlace {
            spotPFObject!["fullAddress"] = currentPlace.formattedAddress
            spotPFObject!["location"] = PFGeoPoint(latitude: currentPlace.coordinate.latitude, longitude: currentPlace.coordinate.longitude)
            if let coordinateVC = UIStoryboard(name: "LendSpot", bundle: nil).instantiateViewController(withIdentifier: "SpotCoordinateVC") as? LenderSpotCoordinateViewController{
                coordinateVC.spotPFObject = self.spotPFObject
                self.navigationController?.pushViewController(coordinateVC, animated: true)
            }
        }
        
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension LenderSpotAddressViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if firstLocationUpdate{
            print("First Location Updating")
            firstLocationUpdate = false
            let span = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1800, 1800)
            self.mapView.setRegion(span, animated: true)
        }
    }
}

extension LenderSpotAddressViewController: UITextFieldDelegate, GMSAutocompleteViewControllerDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let searchAddress = textField.text{
            GeocodingHelper.sharedInstance.coordinateFrom(address: searchAddress, completion: { (coordinate, fullAddress) in
                if let coordinate = coordinate{
                    self.zoomToCoordinate(coordinate: coordinate, width: 1200, animationTime: 1.0)
                    self.textField.text = fullAddress
                }
            })
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        let currentLocation = self.mapView.centerCoordinate
        let bounds = GMSCoordinateBounds(coordinate: currentLocation.transform(using: 50000, longitudinalMeters: 50000), coordinate: currentLocation.transform(using: -50000, longitudinalMeters: -50000))
        print("Bounds \(bounds.isValid) \(bounds.northEast) \(bounds.southWest)")
        autocompleteController.autocompleteBounds = bounds
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.textField.text = place.formattedAddress
        self.zoomToCoordinate(coordinate: place.coordinate, width: 1200)
        self.currentPlace = place
        mapView.removeAnnotations(mapView.annotations)
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = place.coordinate
        pinAnnotation.title = "Your spot address"
        self.mapView.addAnnotation(pinAnnotation)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
        
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
