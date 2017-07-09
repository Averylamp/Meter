//
//  Spot.swift
//  Meter
//
//  Created by Avery Lamp on 6/3/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
class Spot: NSObject {
    var name:String = ""
    var shortDescription:String = ""
    var longDescription:String = ""
    var owner:String = ""
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var number: Int = 0
    var pfObject: PFObject?
    
    
}
