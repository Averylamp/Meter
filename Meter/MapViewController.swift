//
//  MapViewController.swift
//  Meter
//
//  Created by Avery Lamp on 5/21/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
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
    
    func loadCoordinates(){
        for _ in 0...50{
            let coord = CLLocationCoordinate2DMake(40.8 + Double(arc4random_uniform(1000)) / 10000.0 - 0.05, -74.005 + Double(arc4random_uniform(1000)) / 10000.0 - 0.05)
            coordinates.append(coord)
        }
    }
    
    func displayCoordinates(){
        var count = 1
        for coord in coordinates{
            let annotation = SpotAnnotation()
            annotation.coordinate = coord
            annotation.title = "Spot \(count)"
            count += 1
            self.mapView.addAnnotation(annotation)
        }
        
        
    }
    
    var coordinates = [CLLocationCoordinate2D]()
    
    
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
            var spotAnnotation =  mapView.dequeueReusableAnnotationView(withIdentifier: spotIdentifier)
            if let spotAnnotation = spotAnnotation{
                spotAnnotation.annotation = annotation

            }else{
                spotAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: spotIdentifier)
            }
            if annotation is SpotAnnotation {
                spotAnnotation?.subviews.forEach{ $0.removeFromSuperview() }
                spotAnnotation?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                let pinImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                pinImage.image = #imageLiteral(resourceName: "Map_Pin")
                pinImage.contentMode = .scaleAspectFit
                spotAnnotation?.addSubview(pinImage)
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
    
    


}
