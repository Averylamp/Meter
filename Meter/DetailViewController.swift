//
//  DetailViewController.swift
//  Meter
//
//  Created by Avery Lamp on 6/3/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController{
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
    }
    
    func loadSpots(spots: [PFObject]) {
        if scrollView.subviews.count > 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.subviews.forEach{
                    $0.alpha = 0.0
                }
            }, completion: { (finished) in
                self.scrollView.subviews.forEach{ $0.removeFromSuperview() }
                self.loadSpots(spots: spots)
            })
            return
        }
        var lastDetailView : SpotPreviewView? = nil
        var count = 0
        for spot in spots{
            let previewView = SpotPreviewView()
            previewView.alpha = 0.0
            if lastDetailView == nil{
                previewView.frame = CGRect(x: 0, y: 0, width: 300, height: self.view.frame.height)
            }else{
                previewView.frame = CGRect(x: lastDetailView!.frame.origin.x  + lastDetailView!.frame.width, y: 0, width: 250, height: self.view.frame.height)
            }
            scrollView.addSubview(previewView)
            scrollView.contentSize = CGSize(width: previewView.frame.width + previewView.frame.origin.x, height: previewView.frame.height)
            lastDetailView = previewView
            previewView.tag = count
            count += 1
            if let spotTitle = spot["spotName"] as? String{
                previewView.spotTitleLabel.text = spotTitle
            }
            if let monthlyRate = spot["monthlyPrice"] as? NSNumber{
                previewView.monthlyRateLabel.text = "Monthly Rate: $\(monthlyRate.intValue)"
            }
            if let dailyRate = spot["dailyPrice"] as? NSNumber{
                if dailyRate.doubleValue == floor(dailyRate.doubleValue){
                    previewView.dailyRateLabel.text = "Daily Rate: $\(dailyRate.intValue)"
                }else{
                    previewView.dailyRateLabel.text = String(format: "Daily Rate: $%.2f", dailyRate.doubleValue)
                }
                previewView.spotNumberLabel.text = "\(dailyRate.intValue)"
            }
            if let averageRating = spot["averageRating"] as? NSNumber{
                previewView.setRating(rating: averageRating.doubleValue)
            }
            if let numberOfRatings = spot["numberOfRatings"] as? NSNumber{
                if numberOfRatings.intValue != 1{
                    previewView.ratingLabel.text = "\(numberOfRatings.intValue) ratings"
                }else{
                    previewView.ratingLabel.text = "\(numberOfRatings.intValue) rating"
                }
            }
            
        }
        self.scrollView.subviews.forEach{subview in
            UIView.animate(withDuration: 0.2, animations: {
                subview.alpha = 1.0
            })
        }
        
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    
    
}
