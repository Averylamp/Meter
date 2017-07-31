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
    
    
    @IBOutlet weak var filterHighlightView: UIView!
    @IBOutlet weak var allFilterButton: UIButton!
    @IBOutlet weak var dailyFilterButton: UIButton!
    @IBOutlet weak var weeklyFilterButton: UIButton!
    @IBOutlet weak var monthlyFilterButton: UIButton!
    
    @IBOutlet var allFilterButtons: [UIButton]!
    
    @IBOutlet weak var calendarLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    var currentSpots = [PFObject]()
    var currentPreviewViews = [SpotPreviewView]()
    let imageBounceStartScale:CGFloat = 0.9
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
            previewView.layer.shadowOpacity = 0.2
            previewView.layer.shadowRadius = 3
            previewView.layer.shadowOffset = CGSize(width: 0, height: 0)
            if lastDetailView == nil{
                previewView.frame = CGRect(x: 0, y: 0, width: previewViewWidth, height: self.scrollView.frame.height)
            }else{
                previewView.frame = CGRect(x: lastDetailView!.frame.origin.x  + lastDetailView!.frame.width, y: 0, width: previewViewWidth, height: self.scrollView.frame.height)
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
            if let spotTitle = spot[SpotKeys.Name] as? String{
                previewView.spotTitleLabel.text = spotTitle
            }
            if let monthlyRate = spot[SpotKeys.MonthlyPrice] as? NSNumber{
                previewView.monthlyRateLabel.text = "Monthly Rate: $\(monthlyRate.intValue)"
            }
            if let dailyRate = spot[SpotKeys.DailyPrice] as? NSNumber{
                if dailyRate.doubleValue == floor(dailyRate.doubleValue){
                    previewView.dailyRateLabel.text = "Daily Rate: $\(dailyRate.intValue)"
                }else{
                    previewView.dailyRateLabel.text = String(format: "Daily Rate: $%.2f", dailyRate.doubleValue)
                }
                previewView.spotNumberLabel.text = "\(dailyRate.intValue)"
            }
            if let averageRating = spot[SpotKeys.AverageRating] as? NSNumber{
                previewView.setRating(rating: averageRating.doubleValue)
            }
            if let numberOfRatings = spot[SpotKeys.NumberOfRatings] as? NSNumber{
                if numberOfRatings.intValue != 1{
                    previewView.ratingLabel.text = "\(numberOfRatings.intValue) ratings"
                }else{
                    previewView.ratingLabel.text = "\(numberOfRatings.intValue) rating"
                }
            }
            
            if let spotCoordinate = spot[SpotKeys.Location] as? PFGeoPoint{
                let coord = CLLocationCoordinate2DMake(spotCoordinate.latitude, spotCoordinate.longitude)
                let milesDistance = coord.distanceFrom(coordinate: self.searchLocation)
                previewView.distanceLabel.text = "\(milesDistance) miles away"
            }
            
            if let spotPicture = spot[SpotKeys.SpotPicture] as? PFFile{
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
            if let spotName = currentSpot[SpotKeys.Name] as? String{
                detailVC.spotTitleLabel.text = spotName
            }
            if let shortDescription = currentSpot[SpotKeys.ShortDescription] as? String{
                detailVC.shortDescriptionLabel.text = shortDescription
            }
            if let longDescription = currentSpot[SpotKeys.LongDescription] as? String{
                detailVC.longDescriptionLabel.text = longDescription
            }
            if let address = currentSpot[SpotKeys.FullAddress] as? String{
                detailVC.addressLabel.text = address
            }
            if let spotType = currentSpot[SpotKeys.SpotType] as? String{
                detailVC.spotTypeLabel.text = "Type: \(spotType)"
            }
            if let restrictions = currentSpot[SpotKeys.Restrictions] as? String{
                detailVC.restrictionsLabel.text = "Restrictions: \(restrictions)"
            }
            if let averageRating = currentSpot[SpotKeys.AverageRating] as? NSNumber{
                detailVC.setRating(rating: averageRating.doubleValue)
            }
            if let numberOfRatings = currentSpot[SpotKeys.NumberOfRatings] as? NSNumber{
                if numberOfRatings.intValue != 1{
                    detailVC.ratingsLabel.text = "\(numberOfRatings.intValue) ratings"
                }else{
                    detailVC.ratingsLabel.text = "\(numberOfRatings.intValue) rating"
                }
            }
            if let dailyPrice = currentSpot[SpotKeys.DailyPrice] as? NSNumber{
                detailVC.dailyPriceLabel.text = "$\(dailyPrice.intValue)"
            }
            if let weeklyPrice = currentSpot["weeklyPrice"] as? NSNumber{
                detailVC.weeklyPriceLabel.text = "$\(weeklyPrice.intValue)"
            }
            if let monthlyPrice = currentSpot[SpotKeys.MonthlyPrice] as? NSNumber{
                detailVC.monthlyPriceLabel.text = "$\(monthlyPrice.intValue)"
            }
            if let spotCoordinate = currentSpot[SpotKeys.Location] as? PFGeoPoint {
                let coord = CLLocationCoordinate2D(latitude: spotCoordinate.latitude, longitude: spotCoordinate.longitude)
                detailVC.distanceLabel.text = "\(coord.distanceFrom(coordinate: self.searchLocation)) miles away"
            }
            
            var count = 0
            if let mapPicture = currentSpot[SpotKeys.MapPicture] as? PFFile{
                count += 1
                mapPicture.getDataInBackground(block: { (data, error) in
                    count -= 1
                    if error == nil{
                        detailVC.spotImages.append(UIImage(data: data!)!)
                        detailVC.imageOrder.append("map")
                    }else{
                        print("Error getting spot picture \(error?.localizedDescription ?? "")")
                    }
                    if count == 0{
                        detailVC.setupDetailImages()
                    }
                })
            }
            if let spotPicture = currentSpot[SpotKeys.SpotPicture] as? PFFile{
                count += 1
                spotPicture.getDataInBackground(block: { (data, error) in
                    count -= 1
                    if error == nil{
                        detailVC.spotImages.append(UIImage(data: data!)!)
                        detailVC.imageOrder.append("spot")
                    }else{
                        print("Error getting spot picture \(error?.localizedDescription ?? "")")
                    }
                    if count == 0{
                        detailVC.setupDetailImages()
                    }
                })
            }
            if let entrancePicture = currentSpot[SpotKeys.EntrancePicture] as? PFFile{
                count += 1
                entrancePicture.getDataInBackground(block: { (data, error) in
                    count -= 1
                    if error == nil{
                        detailVC.spotImages.append(UIImage(data: data!)!)
                        detailVC.imageOrder.append("entrance")
                    }else{
                        print("Error getting spot picture \(error?.localizedDescription ?? "")")
                    }
                    if count == 0{
                        detailVC.setupDetailImages()
                    }
                })
            }
            if let additionalPicture = currentSpot[SpotKeys.AdditionalPicture] as? PFFile{
                count += 1
                additionalPicture.getDataInBackground(block: { (data, error) in
                    count -= 1
                    if error == nil{
                        detailVC.spotImages.append(UIImage(data: data!)!)
                        detailVC.imageOrder.append("additional")
                    }else{
                        print("Error getting spot picture \(error?.localizedDescription ?? "")")
                    }
                    if count == 0{
                        detailVC.setupDetailImages()
                    }
                })
            }
            if let spotOwner = currentSpot[SpotKeys.Owner] as? PFUser{
                DispatchQueue.global().async {
                    do {
                        try spotOwner.fetchIfNeeded()
                        DispatchQueue.main.async {
                            if let ownerName = spotOwner["name"] as? String{
                                let firstName = ownerName.characters.split{ $0 == " "}.map(String.init).first!
                                detailVC.ownerLabel.text = "Hosted by \(firstName)"
                            }
                            if let proPic = spotOwner["profilePicture"] as? PFFile{
                                proPic.getDataInBackground(block: { (data, error) in
                                    if error == nil{
                                        detailVC.ownerImage.image = UIImage(data: data!)
                                    }else{
                                        print("Error getting profile picture \(error?.localizedDescription ?? "")")
                                    }
                                })
                            }
                        }
                    }catch{
                        print("Spot Owner Fetch Failed \(error.localizedDescription)")
                    }
                }
            }
            detailVC.fitLabelHeights()
            self.navigationController?.pushViewController(detailVC, animated: true)
//            self.present(detailVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Handle filter Button Animations
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4) {
            sender.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
            sender.setTitleColor(Constants.Colors.blueHighlight, for: .normal)
            self.filterHighlightView.center.x = sender.center.x
            self.allFilterButtons.forEach{
                if $0 != sender{
                    $0.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
                    $0.setTitleColor(UIColor.gray, for: .normal)
                }
            }
            
            
            
        }
    }
    
    
    @IBAction func calendarButtonClicked(_ sender: Any) {
    }
    
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCenter = scrollView.contentOffset.x + scrollView.frame.width / 2.0
        if checkIfInCenter(center: currentCenter, view: currentHighlightedPreviewView) == false{
            let currentIndex = currentHighlightedPreviewView.tag
            let animationDuration = 0.6
            let shadowOpacityLow: Float = 0.2
            let shadowOpacityHigh: Float = 0.4
            for previewView in self.currentPreviewViews{
                if checkIfInCenter(center: currentCenter, view: previewView){
                    currentHighlightedPreviewView = previewView
                    delay(animationDuration / 3, closure: {
                        previewView.superview?.bringSubview(toFront: previewView)
                    })
                    
                    if previewView.layer.shadowOpacity == shadowOpacityLow{
                        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
                        shadowAnimation.fromValue = shadowOpacityLow
                        shadowAnimation.toValue = shadowOpacityHigh
                        shadowAnimation.beginTime = CACurrentMediaTime() + animationDuration / 3
                        shadowAnimation.duration = animationDuration * 2 / 3.0
                        previewView.layer.add(shadowAnimation, forKey: "shadowOpacity")
                        delay(animationDuration / 3, closure: {
                            previewView.layer.shadowOpacity = shadowOpacityHigh
                        })
                    }
                    
                    if previewView.detailImageView.transform != CGAffineTransform.identity {
                        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                            previewView.detailImageView.transform = CGAffineTransform.identity
                        }, completion: nil)
                    }
                    
                    self.currentHighlightedPreviewView.pinIconImageView.image = #imageLiteral(resourceName: "BluePin")
                    previewView.pinIconImageView.alpha = 1.0
//                    UIView.animate(withDuration: animationDuration / 2, animations: {
//                        previewView.pinIconImageView.alpha = 0.0
//                    }, completion: { (finished) in
//                        UIView.animate(withDuration: animationDuration / 2, animations: {
//                        }, completion: nil)
//                    })
                    if let delegate = delegate {
                        delegate.spotHighlighted(spot: self.currentSpots[previewView.tag])
                    }
                }else{
                    if previewView.layer.shadowOpacity == shadowOpacityHigh{
                        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
                        shadowAnimation.fromValue = shadowOpacityHigh
                        shadowAnimation.toValue = shadowOpacityLow
                        shadowAnimation.duration = animationDuration / 3
                        previewView.layer.add(shadowAnimation, forKey: "shadowOpacity")
                        previewView.layer.shadowOpacity = shadowOpacityLow
                    }
                    if previewView.pinIconImageView.image == #imageLiteral(resourceName: "BluePin"){
                        previewView.pinIconImageView.image = #imageLiteral(resourceName: "Map_Pin")
//                        UIView.animate(withDuration: animationDuration / 3, animations: {
//                            previewView.pinIconImageView.alpha = 0.0
//                        }, completion: { (finished) in
//                            UIView.animate(withDuration: animationDuration / 3, animations: {
//                                previewView.pinIconImageView.alpha = 1.0
//                            }, completion: nil)
//                        })
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
