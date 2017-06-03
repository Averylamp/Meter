//
//  MapViewController.swift
//  Meter
//
//  Created by Avery Lamp on 5/21/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse

protocol  MapDelegate {
    func pinClicked(spot:Spot)
    func pinDeselected(spot:Spot)
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: MapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        let span2 = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.8, -74.005), 8000, 8000)
        self.mapView.setRegion(span2, animated: true)
        // Do any additional setup after loading the view.
        loadCoordinates()
        displayCoordinates()
    }
    
    var spotObjects = [Spot]()
    func loadCoordinates(){
        let query = PFQuery(className: "Spot")
        let geoPoint = PFGeoPoint(latitude: 40.744893, longitude: -73.987398)
        query.whereKey("location", nearGeoPoint: geoPoint)
        do{
            let objects = try query.findObjects()
            print(objects)
        }
        catch{
            print("Failed query")
        }
        
        for i in 0...50{
            let coord = CLLocationCoordinate2DMake(40.8 + Double(arc4random_uniform(1000)) / 10000.0 - 0.05, -74.005 + Double(arc4random_uniform(1000)) / 10000.0 - 0.05)
            
            let spot = Spot()
            spot.coordinate = coord
            spot.number = i
            spot.name = "Spot - \(i)"
            spotObjects.append(spot)
        }
    }
    
    func displayCoordinates(){
        var count = 1
        for spot in spotObjects{
            let annotation = SpotAnnotation()
            annotation.spot = spot
            annotation.coordinate = spot.coordinate
            annotation.title = "Spot \(count)"
            count += 1
            self.mapView.addAnnotation(annotation)
        }
        
        
    }
    
    
    
    // MARK: - Map View Delegtes
    
    var firstUpdate = true
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if firstUpdate{
            firstUpdate = false
            let span = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 400, 400)
            self.mapView.setRegion(span, animated: false)
            let span2 = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 300, 300)
            self.mapView.setRegion(span2, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation as! _OptionalNilComparisonType != mapView.userLocation as MKAnnotation{
            let spotIdentifier = "SpotAnnotation"
            var spotAnnotation: SpotAnnotationView? =  mapView.dequeueReusableAnnotationView(withIdentifier: spotIdentifier) as? SpotAnnotationView
            if let spotAnnotation = spotAnnotation{
                spotAnnotation.annotation = annotation

            }else{
                spotAnnotation = SpotAnnotationView(annotation: annotation, reuseIdentifier: spotIdentifier)
            }
            if annotation is SpotAnnotation, let spotAnnotation = spotAnnotation {
                spotAnnotation.subviews.forEach{ $0.removeFromSuperview() }
                spotAnnotation.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                spotAnnotation.pinImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                spotAnnotation.pinImage?.image = #imageLiteral(resourceName: "Map_Pin")
                spotAnnotation.pinImage?.contentMode = .scaleAspectFit
                spotAnnotation.priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 25 ))
                spotAnnotation.priceLabel?.textAlignment  = .center
                spotAnnotation.priceLabel?.text = "\(arc4random_uniform(20) + 15)"
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
            let startLocation = CGPoint(x: annotationView.center.x, y: -100)
            annotationView.center = startLocation
            UIView.animate(withDuration: 0.6, delay: delay, options: .curveEaseOut, animations: {
                annotationView.center = endLocation
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


}
