//
//  HelperFunctions.swift
//  Meter
//
//  Created by Avery Lamp on 7/10/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class HelperFunctions: NSObject {

}


extension UIViewController{
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}

extension UILabel{
    
    func heightForLabel()-> CGFloat{
        let originalNumberOfLines = self.numberOfLines
        self.numberOfLines = 0
        let requiredSize = self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        self.numberOfLines = originalNumberOfLines
        return requiredSize.height
    }
    
}

extension CLLocationCoordinate2D{
    
    func distanceFrom(coordinate: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let meterDistance = location1.distance(from: location2)
        let milesDistance = meterDistance / 1610.0
        let roundedMilesDistance = round(milesDistance * 100) / 100.0
        return roundedMilesDistance
    }
    
    func transform(using latitudinalMeters: CLLocationDistance, longitudinalMeters: CLLocationDistance) -> CLLocationCoordinate2D {
        let region = MKCoordinateRegionMakeWithDistance(self, latitudinalMeters, longitudinalMeters)
        return CLLocationCoordinate2D(latitude: latitude + region.span.latitudeDelta, longitude: longitude + region.span.longitudeDelta)
    }
}
