//
//  GeocodingHelper.swift
//  Meter
//
//  Created by Avery Lamp on 7/8/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class GeocodingHelper: NSObject {
    static let sharedInstance = GeocodingHelper()
    var geocodingKey:String{
        get {
            if let url = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist"){
                do {
                    let data = try Data(contentsOf:url)
                    let swiftDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                    if let key = swiftDictionary["GEOCODING_API_KEY"] as? String{
                        return key
                    }
                } catch {
                    print(error)
                }
            }
            print("******** Unable to find key!!!")
            return ""
        }
    }
    override private init(){
        super.init()
    }
    
    func coordinateFrom(address:String, closestTo: CLLocationCoordinate2D? = nil, completion: @escaping (CLLocationCoordinate2D?, String)->Void){
        //        https://maps.googleapis.com/maps/api/geocode/json?address=MIT&key=AIzaSyATMSL39wng4rV6yd0SnCyE_VZDMA6gw_I
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?", method: .get, parameters:["address":address, "key":geocodingKey], headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let resultsArr = json["results"].array, resultsArr.count > 0{
                    if closestTo == nil{
                        if let coordinatesDict = resultsArr.first!["geometry"]["location"].dictionary, let lat = coordinatesDict["lat"]?.number, let long = coordinatesDict["lng"]?.number, let fullAddress = json["results"][0]["formatted_address"].string{
                            let coord = CLLocationCoordinate2DMake(lat.doubleValue, long.doubleValue)
                            completion(coord, fullAddress)
                            print(coordinatesDict)
                        }
                    }else{
                        var closestDict: [String:JSON] = resultsArr.first!["geometry"]["location"].dictionary!
                        var closestCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (closestDict["lat"]?.numberValue.doubleValue)!, longitude: (closestDict["lng"]?.numberValue.doubleValue)!)
                        for item in resultsArr{
                            if let coordinatesDict = item["geometry"]["location"].dictionary, let lat = coordinatesDict["lat"]?.number, let long = coordinatesDict["lng"]?.number, let fullAddress = json["results"][0]["formatted_address"].string{
                                let coord = CLLocationCoordinate2DMake(lat.doubleValue, long.doubleValue)
                                if coord.distanceFrom(coordinate: closestTo!) < closestCoord.distanceFrom(coordinate: closestTo!){
                                    closestCoord = coord
                                    closestDict = coordinatesDict
                                }
                            }
                        }
                        let fullAddress = closestDict["formatted_address"]?.stringValue
                        completion(closestCoord, fullAddress!)
                    }
                }else{
                    completion(nil, "")
                }
            case .failure(let error):
                print(error)
                completion(nil, "")
            }
        }
    }
    
    func addressFrom(coordinate:CLLocationCoordinate2D, completion: @escaping (CLLocationCoordinate2D?, String)->Void){
        //        https://maps.googleapis.com/maps/api/geocode/json?address=MIT&key=AIzaSyATMSL39wng4rV6yd0SnCyE_VZDMA6gw_I
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?", method: .get, parameters:["latlng":"\(coordinate.latitude),\(coordinate.longitude)", "key":geocodingKey], headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let coordinatesDict = json["results"][0]["geometry"]["location"].dictionary, let lat = coordinatesDict["lat"]?.number, let long = coordinatesDict["lng"]?.number, let fullAddress = json["results"][0]["formatted_address"].string{
                    
                    let coord = CLLocationCoordinate2DMake(lat.doubleValue, long.doubleValue)
                    completion(coord, fullAddress)
                    print(coordinatesDict)
                }else{
                    completion(nil, "")
                }
            case .failure(let error):
                print(error)
                completion(nil, "")
            }
        }
    }
    
}
