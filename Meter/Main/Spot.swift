//
//  Spot.swift
//  Meter
//
//  Created by Avery Lamp on 6/3/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse

struct SpotKeys {
    static let Name = "spotName"
    static let ShortDescription = "shortDescription"
    static let LongDescription = "longDescription"
    static let Location = "location"
    static let Owner = "spotOwner"
    static let AverageRating = "averageRating"
    static let NumberOfRatings = "numberOfRatings"
    static let Ratings = "ratings"
    static let MonthlyPrice = "monthlyPrice"
    static let AvailableMonthly = "availableMonthly"
    static let WeeklyPrice = "weeklyPrice"
    static let AvailableWeekly = "availableWeekly"
    static let DailyPrice = "dailyPrice"
    static let AvailableDaily = "availableDaily"
    static let HourlyPrice = "hourlyPrice"
    static let AvailableHourly = "availableHourly"
    static let SpotType = "spotType"
    static let FullAddress = "fullAddress"
    static let Restrictions = "spotRestrictions"
    static let ViewCount = "viewCount"
    static let MapPicture = "mapPicture"
    static let SpotPicture = "spotPicture"
    static let EntrancePicture = "entrancePicture"
    static let AdditionalPicture = "additionalPicture"
    static let IsCraigslist = "isCraigslist"
    static let CraigslistPhoneNumber = "craigslistPhoneNumber"
    static let CraigslistEmail = "craigslistEmail"
}

class Spot: NSObject {
    var name:String = ""
    var shortDescription:String = ""
    var longDescription:String = ""
    var owner:String = ""
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var number: Int = 0
    var pfObject: PFObject?
    
    
}
