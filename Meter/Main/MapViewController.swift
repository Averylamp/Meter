//
//  MapViewController.swift
//  Meter
//
//  Created by Avery Lamp on 5/21/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces
import MapKit

protocol  MapDelegate {
    func pinClicked(spot:Spot)
    func pinDeselected(spot:Spot)
    
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var delegate: MapDelegate?
    @IBOutlet weak var centerToLocationButton: UIButton!
    @IBOutlet weak var textInputContainerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationAuthorization()
        self.searchTextField.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        let span2 = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.8, -74.005), 8000, 8000)
        self.mapView.setRegion(span2, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(MapViewController.saveLastReportedLocation), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveLastReportedLocation()
    }
    
    func saveLastReportedLocation(){
        let coord = locationManager.location?.coordinate
        if let coord = coord, let currentUser = PFUser.current(){
            currentUser["lastReportedLocation"] = PFGeoPoint(latitude: coord.latitude, longitude: coord.longitude)
            GeocodingHelper.sharedInstance.addressFrom(coordinate: coord, completion: { (_, address) in
                currentUser["lastReportedLocationAddress"] = address
                DispatchQueue.global().async {
                    do{
                        try currentUser.save()
                    }catch{
                        print("Unable to save")
                    }
                }
            })
        }
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
    
    var spotObjects = [Spot]()
    var spotPFObjects = [PFObject]()
    
    
    var lastSearchedLocation = CLLocationCoordinate2D()
    func loadSpotsFromLocation(coordinate: CLLocationCoordinate2D){
        print("Loading spots from new location")
        lastSearchedLocation = coordinate
        let query = PFQuery(className: "Spot")
        let point = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        query.whereKey("location", nearGeoPoint: point)
        query.findObjectsInBackground(block: { (objects, error) in
            if let error = error{
                print("Error finding spots - \(error)")
            }else{
                print("New location query returned")
                if let objects = objects{
                    print("Spot objects returned")
                    self.spotPFObjects = objects
                    self.spotObjects = [Spot]()
                    var count = 1
                    for pfSpot in self.spotPFObjects{
                        let newSpot = Spot()
                        if let spotCoordinate = pfSpot["location"] as? PFGeoPoint{
                            newSpot.coordinate = CLLocationCoordinate2DMake(spotCoordinate.latitude, spotCoordinate.longitude)
                        }
                        newSpot.pfObject = pfSpot
                        newSpot.number = count
                        count += 1
                        if let spotName = pfSpot["name"] as? String{
                            newSpot.name = spotName
                        }
                        self.spotObjects.append(newSpot)
                    }
                    DispatchQueue.main.async {
                        self.displayCoordinates()
                    }
                }
            }
        })
    }
    
    func displayCoordinates(){
        var count = 1
        self.mapView.removeAnnotations(self.mapView.annotations)
        for spot in spotObjects{
            let annotation = SpotAnnotation()
            annotation.spot = spot
            annotation.coordinate = spot.coordinate
            annotation.title = "Spot \(count)"
            count += 1
            self.mapView.addAnnotation(annotation)
        }
        
    }
    @IBAction func centerToLocationClicked(_ sender: Any) {
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
    
    var firstLocationUpdate = true
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NavigationNotifications.toggleMenu), object: nil)
    }
    
    
}

//MARK: - Location Manager Delegate
extension MapViewController: CLLocationManagerDelegate{
    
}

// MARK: - Map View Delegtes
extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if firstLocationUpdate{
            print("First Location Updating")
            firstLocationUpdate = false
            let span = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1800, 1800)
            self.mapView.setRegion(span, animated: true)
            self.loadSpotsFromLocation(coordinate: userLocation.coordinate)
            self.saveLastReportedLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKind(of: MKUserLocation.self)){
            return nil
        }
        if annotation as! _OptionalNilComparisonType != mapView.userLocation as MKAnnotation{
            let spotIdentifier = "SpotAnnotation"
            var spotAnnotation: SpotAnnotationView? =  mapView.dequeueReusableAnnotationView(withIdentifier: spotIdentifier) as? SpotAnnotationView
            if let spotAnnotation = spotAnnotation{
                spotAnnotation.annotation = annotation
                
            }else{
                spotAnnotation = SpotAnnotationView(annotation: annotation, reuseIdentifier: spotIdentifier)
            }
            if let annotation = annotation as? SpotAnnotation, let spotAnnotation = spotAnnotation {
                spotAnnotation.subviews.forEach{ $0.removeFromSuperview() }
                spotAnnotation.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                spotAnnotation.pinImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                spotAnnotation.pinImage?.image = #imageLiteral(resourceName: "Map_Pin")
                spotAnnotation.pinImage?.contentMode = .scaleAspectFit
                spotAnnotation.priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 25 ))
                spotAnnotation.priceLabel?.textAlignment  = .center
                if let pfObj =  annotation.spot?.pfObject, let spotPrice = (pfObj["dailyPrice"] as? NSNumber){
                    spotAnnotation.priceLabel?.text = "\(spotPrice.intValue)"
                }else{
                    spotAnnotation.priceLabel?.text = "\(0)"
                }
                spotAnnotation.priceLabel?.font = UIFont(name: "Avenir", size: 16)
                spotAnnotation.pinImage?.addSubview(spotAnnotation.priceLabel!)
                spotAnnotation.priceLabel?.center = CGPoint(x: (spotAnnotation.pinImage?.center.x)!, y: (spotAnnotation.pinImage?.center.y)! - 7)
                spotAnnotation.addSubview(spotAnnotation.pinImage!)
                //                spotAnnotation?.animatesDrop = true
            }
            return spotAnnotation
        }else{
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        var delay = 0.0
        for annotationView in views{
            let endLocation = annotationView.center
            //            let startLocation = CGPoint(x: annotationView.center.x, y: -100)// Downwards falling animation
            let startLocation = CGPoint(x: annotationView.center.x, y: annotationView.center.y)
            annotationView.center = startLocation
            annotationView.alpha = 0.0
            UIView.animate(withDuration: 0.6, delay: delay, options: .curveEaseOut, animations: {
                annotationView.center = endLocation
                annotationView.alpha = 1.0
            }, completion: nil)
            delay += 0.1
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let delegate = delegate{
            if let spotAnnotation = view.annotation as? SpotAnnotation, let spotAnnotationView = view as? SpotAnnotationView{
                spotAnnotationView.pinImage?.image = #imageLiteral(resourceName: "BluePin")
                delegate.pinClicked(spot: spotAnnotation.spot!)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let delegate = delegate{
            if let spotAnnotation = view.annotation as? SpotAnnotation, let spotAnnotationView = view as? SpotAnnotationView{
                spotAnnotationView.pinImage?.image = #imageLiteral(resourceName: "Map_Pin")
                delegate.pinDeselected(spot: spotAnnotation.spot!)
            }
        }
    }
    
    func highlightSpot(spot:PFObject){
        
        mapView.annotations.forEach{
            if let spotAnnotation = $0 as? SpotAnnotation{
                if let spotAnnotationView = mapView.view(for: spotAnnotation) as? SpotAnnotationView{
                    if let pfObj = spotAnnotation.spot?.pfObject, pfObj == spot{
                        spotAnnotationView.pinImage?.image = #imageLiteral(resourceName: "BluePin")
                    }else{
                        spotAnnotationView.pinImage?.image = #imageLiteral(resourceName: "Map_Pin")
                    }
                }
            }
        }
    }
}

//MARK: - Text Field Delegate
extension MapViewController: UITextFieldDelegate, GMSAutocompleteViewControllerDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let searchAddress = textField.text{
            GeocodingHelper.sharedInstance.coordinateFrom(address: searchAddress, completion: { (coordinate, fullAddress) in
                if let coordinate = coordinate{
                    self.loadSpotsFromLocation(coordinate: coordinate)
                    self.zoomToCoordinate(coordinate: coordinate, width: 1200, animationTime: 1.0)
                    self.searchTextField.text = fullAddress
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
        self.searchTextField.text = place.formattedAddress
        zoomToCoordinate(coordinate: place.coordinate, width: 1200)
        self.loadSpotsFromLocation(coordinate: place.coordinate)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}



