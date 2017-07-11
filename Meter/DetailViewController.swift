//
//  DetailViewController.swift
//  Meter
//
//  Created by Avery Lamp on 6/3/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse

protocol  DetailDelegate {
    func spotHighlighted(spot:PFObject)
}


class DetailViewController: UIViewController{
    
    var delegate: DetailDelegate?
    var currentHighlightedPreviewView = SpotPreviewView()
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    var currentSpots = [PFObject]()
    var currentPreviewViews = [SpotPreviewView]()
    let imageBounceStartScale:CGFloat = 0.93
    var searchLocation = CLLocationCoordinate2D()
    let previewViewWidth:CGFloat = 280
    
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
        currentPreviewViews = [SpotPreviewView]()
        self.currentSpots = spots
        for spot in spots{
            let previewView = SpotPreviewView()
            currentPreviewViews.append(previewView)
            previewView.overlayButton.addTarget(self, action: #selector(DetailViewController.previewViewClicked(sender:)), for: .touchUpInside)
            previewView.alpha = 0.0
            if lastDetailView == nil{
                previewView.frame = CGRect(x: 0, y: 0, width: previewViewWidth, height: self.view.frame.height)
            }else{
                previewView.frame = CGRect(x: lastDetailView!.frame.origin.x  + lastDetailView!.frame.width, y: 0, width: previewViewWidth, height: self.view.frame.height)
            }
            scrollView.addSubview(previewView)
            scrollView.contentSize = CGSize(width: previewView.frame.width + previewView.frame.origin.x, height: previewView.frame.height)
            lastDetailView = previewView
            previewView.tag = count
            previewView.overlayButton.tag = count
            if count == 0{
                previewView.pinIconImageView.image = #imageLiteral(resourceName: "BluePin")
                
            }
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
            
            if let spotCoordinate = spot["location"] as? PFGeoPoint{
                let coord = CLLocationCoordinate2DMake(spotCoordinate.latitude, spotCoordinate.longitude)
                let milesDistance = coord.distanceFrom(coordinate: self.searchLocation)
                previewView.distanceLabel.text = "\(milesDistance) miles away"
            }
            
            if let spotPicture = spot["spotPicture"] as? PFFile{
                spotPicture.getDataInBackground(block: { (data, error) in
                    DispatchQueue.main.async {
                        previewView.pictureActivityIndicator.stopAnimating()
                    }
                    if error == nil{
                        let image = UIImage(data: data!)
                        previewView.detailImageView.image = image
                        previewView.detailImageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.4, animations: {
                                previewView.detailImageView.alpha = 1.0
                                previewView.detailImageView.transform = CGAffineTransform(scaleX: self.imageBounceStartScale, y: self.imageBounceStartScale)
                            })
                        }
                    }else{
                        DispatchQueue.main.async {
                            previewView.detailImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                            UIView.animate(withDuration: 0.4, animations: {
                                previewView.detailImageView.alpha = 1.0
                                previewView.detailImageView.transform = CGAffineTransform.identity
                            })
                        }
                        print("Error getting spot picture \(error?.localizedDescription)")
                    }
                })
            }
            
        }
        scrollViewDidScroll(self.scrollView)
        currentPreviewViews.reverse()
        self.scrollView.subviews.forEach{subview in
            UIView.animate(withDuration: 0.2, animations: {
                subview.alpha = 1.0
            })
        }
        
    }
    
    func previewViewClicked(sender:UIButton){
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SpotDetailVC") as? SpotDetailViewController {
            detailVC.view.frame = UIScreen.main.bounds
            let currentSpot = self.currentSpots[sender.tag]
            if let spotName = currentSpot["spotName"] as? String{
                detailVC.spotTitleLabel.text = spotName
            }
            if let shortDescription = currentSpot["shortDescription"] as? String{
                detailVC.shortDescriptionLabel.text = shortDescription
            }
            if let longDescription = currentSpot["longDescription"] as? String{
                detailVC.longDescriptionLabel.text = longDescription
            }
            if let address = currentSpot["fullAddress"] as? String{
                detailVC.addressLabel.text = address
            }
            if let spotType = currentSpot["spotType"] as? String{
                detailVC.spotTypeLabel.text = "Type: \(spotType)"
            }
            if let restrictions = currentSpot["spotRestrictions"] as? String{
                detailVC.restrictionsLabel.text = "Restrictions: \(restrictions)"
            }
            if let averageRating = currentSpot["averageRating"] as? NSNumber{
                detailVC.setRating(rating: averageRating.doubleValue)
            }
            if let numberOfRatings = currentSpot["numberOfRatings"] as? NSNumber{
                if numberOfRatings.intValue != 1{
                    detailVC.ratingsLabel.text = "\(numberOfRatings.intValue) ratings"
                }else{
                    detailVC.ratingsLabel.text = "\(numberOfRatings.intValue) rating"
                }
            }
            if let dailyPrice = currentSpot["dailyPrice"] as? NSNumber{
                detailVC.dailyPriceLabel.text = "$\(dailyPrice.intValue)"
            }
            if let weeklyPrice = currentSpot["weeklyPrice"] as? NSNumber{
                detailVC.weeklyPriceLabel.text = "$\(weeklyPrice.intValue)"
            }
            if let monthlyPrice = currentSpot["monthlyPrice"] as? NSNumber{
                detailVC.monthlyPriceLabel.text = "$\(monthlyPrice.intValue)"
            }
            if let spotCoordinate = currentSpot["location"] as? PFGeoPoint {
                let coord = CLLocationCoordinate2D(latitude: spotCoordinate.latitude, longitude: spotCoordinate.longitude)
                detailVC.distanceLabel.text = "\(coord.distanceFrom(coordinate: self.searchLocation)) miles away"
            }
            
            var count = 0
            if let mapPicture = currentSpot["mapPicture"] as? PFFile{
                count += 1
                mapPicture.getDataInBackground(block: { (data, error) in
                    count -= 1
                    if error == nil{
                        let image = UIImage(data: data!)
                        detailVC.spotImages.append(image!)
                        detailVC.imageOrder.append("map")
                    }else{
                        print("Error getting spot picture \(error?.localizedDescription ?? "")")
                    }
                    if count == 0{
                        detailVC.setupDetailImages()
                    }
                })
            }
            if let spotPicture = currentSpot["spotPicture"] as? PFFile{
                count += 1
                spotPicture.getDataInBackground(block: { (data, error) in
                    count -= 1
                    if error == nil{
                        let image = UIImage(data: data!)
                        detailVC.spotImages.append(image!)
                        detailVC.imageOrder.append("spot")
                    }else{
                        print("Error getting spot picture \(error?.localizedDescription ?? "")")
                    }
                    if count == 0{
                        detailVC.setupDetailImages()
                    }
                })
            }
            if let entrancePicture = currentSpot["entrancePicture"] as? PFFile{
                count += 1
                entrancePicture.getDataInBackground(block: { (data, error) in
                    count -= 1
                    if error == nil{
                        let image = UIImage(data: data!)
                        detailVC.spotImages.append(image!)
                        detailVC.imageOrder.append("entrance")
                    }else{
                        print("Error getting spot picture \(error?.localizedDescription ?? "")")
                    }
                    if count == 0{
                        detailVC.setupDetailImages()
                    }
                })
            }
            if let additionalPicture = currentSpot["additionalPicture"] as? PFFile{
                count += 1
                additionalPicture.getDataInBackground(block: { (data, error) in
                    count -= 1
                    if error == nil{
                        let image = UIImage(data: data!)
                        detailVC.spotImages.append(image!)
                        detailVC.imageOrder.append("additional")
                    }else{
                        print("Error getting spot picture \(error?.localizedDescription ?? "")")
                    }
                    if count == 0{
                        detailVC.setupDetailImages()
                    }
                })
            }
            
            detailVC.fitLabelHeights()
            self.present(detailVC, animated: true, completion: nil)
            
        }
        
        
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCenter = scrollView.contentOffset.x + scrollView.frame.width / 2.0
        if checkIfInCenter(center: currentCenter, view: currentHighlightedPreviewView) == false{
            let currentIndex = currentHighlightedPreviewView.tag
            let animationDuration = 0.6
            for previewView in self.currentPreviewViews{
                if checkIfInCenter(center: currentCenter, view: previewView){
                    currentHighlightedPreviewView = previewView
                    delay(animationDuration / 3, closure: {
                        previewView.superview?.bringSubview(toFront: previewView)
                    })
                    
                    if previewView.layer.shadowOpacity == 0.0{
                        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
                        shadowAnimation.fromValue = 0.0
                        shadowAnimation.toValue = 0.6
                        shadowAnimation.beginTime = CACurrentMediaTime() + animationDuration / 3
                        shadowAnimation.duration = animationDuration * 2 / 3.0
                        previewView.layer.add(shadowAnimation, forKey: "shadowOpacity")
                        delay(animationDuration / 3, closure: {
                            previewView.layer.shadowOpacity = 0.6
                        })
                    }
                    
                    if previewView.detailImageView.transform != CGAffineTransform.identity {
                        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                            previewView.detailImageView.transform = CGAffineTransform.identity
                        }, completion: nil)
                    }
                    
                    UIView.animate(withDuration: animationDuration / 2, animations: {
                        previewView.pinIconImageView.alpha = 0.0
                    }, completion: { (finished) in
                        self.currentHighlightedPreviewView.pinIconImageView.image = #imageLiteral(resourceName: "BluePin")
                        UIView.animate(withDuration: animationDuration / 2, animations: {
                            previewView.pinIconImageView.alpha = 1.0
                        }, completion: nil)
                    })
                    if let delegate = delegate {
                        delegate.spotHighlighted(spot: self.currentSpots[previewView.tag])
                    }
                }else{
                    if previewView.layer.shadowOpacity == 0.6{
                        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
                        shadowAnimation.fromValue = 0.6
                        shadowAnimation.toValue = 0.0
                        shadowAnimation.duration = animationDuration / 3
                        previewView.layer.add(shadowAnimation, forKey: "shadowOpacity")
                        previewView.layer.shadowOpacity = 0.0
                    }
                    if previewView.pinIconImageView.image == #imageLiteral(resourceName: "BluePin"){
                        UIView.animate(withDuration: animationDuration / 3, animations: {
                            previewView.pinIconImageView.alpha = 0.0
                        }, completion: { (finished) in
                            previewView.pinIconImageView.image = #imageLiteral(resourceName: "Map_Pin")
                            UIView.animate(withDuration: animationDuration / 3, animations: {
                                previewView.pinIconImageView.alpha = 1.0
                            }, completion: nil)
                        })
                    }
                    if previewView.detailImageView.transform != CGAffineTransform(scaleX: imageBounceStartScale, y: imageBounceStartScale){
                        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                            previewView.detailImageView.transform = CGAffineTransform(scaleX: self.imageBounceStartScale, y: self.imageBounceStartScale)
                        }, completion: nil)
                    }
                }
            }
            //TODO: - May be skipping a frame due to calculations.  Do smarter search for changed view to fix
            
        }
    }
    
    func checkIfInCenter(center:CGFloat, view: UIView)-> Bool{
        return view.frame.origin.x < center && center < view.frame.origin.x  + view.frame.width
    }
    
}
