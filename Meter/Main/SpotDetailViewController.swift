//
//  SpotDetailViewController.swift
//  Meter
//
//  Created by Avery Lamp on 7/9/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class SpotDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var spotTypeLabel: UILabel!
    @IBOutlet weak var restrictionsLabel: UILabel!
    
    @IBOutlet var starImageViews: [UIImageView]!
    
    @IBOutlet weak var ownerButton: UIButton!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var shortDescriptionHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var dailyPriceLabel: UILabel!
    @IBOutlet weak var weeklyPriceLabel: UILabel!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet weak var longDescriptionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spotTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!
    
    var spotImages = [UIImage]()
    var imageOrder = [String]()
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagesScrollView.delegate = self
    }
    
    func fitLabelHeights(){
        shortDescriptionHeightConstraint.constant = shortDescriptionLabel.heightForLabel() + 6
        longDescriptionHeightConstraint.constant = longDescriptionLabel.heightForLabel() + 6
        self.view.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: longDescriptionLabel.frame.origin.y + longDescriptionLabel.frame.height + 10)
        self.contentViewHeightConstraint.constant = longDescriptionLabel.frame.origin.y + longDescriptionLabel.frame.height + 10
        self.view.layoutIfNeeded()
    }
    
    func setRating(rating:Double){
        let roundedRating = (rating*2).rounded() / 2.0
        for starImage in starImageViews{
            if Double(starImage.tag) <= roundedRating{
                starImage.image = #imageLiteral(resourceName: "star_filled")
            }else if Double(starImage.tag) <= roundedRating + 0.5{
                starImage.image = #imageLiteral(resourceName: "star_half_filled")
            }else{
                starImage.image = #imageLiteral(resourceName: "star_unfilled")
            }
        }
    }
    
    var imageScrollViewPageIndicatorViews = [UIView]()
    var lastImageScrollViewPage:Int = 0
    func setupDetailImages(){
        self.imagesScrollView.subviews.forEach{$0.removeFromSuperview()}
        let imageOrder = ["spot", "entrance", "additional", "map"]
        var count:CGFloat = 0
        for imageType in imageOrder{
            if let imageIndex = self.imageOrder.index(of: imageType){
                let image = self.spotImages[imageIndex]
                let imageView = UIImageView(frame:CGRect(x: count * self.imagesScrollView.frame.width , y: 0, width: self.imagesScrollView.frame.width, height: self.imagesScrollView.frame.height - 30))
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
//                imageView.layer.cornerRadius = 8
                let shadowView = UIView(frame: imageView.frame)
                shadowView.backgroundColor = UIColor.white
                shadowView.layer.cornerRadius = imageView.layer.cornerRadius
                shadowView.layer.shadowRadius = 4
                shadowView.layer.shadowOpacity = 0.3
                shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
//                self.imagesScrollView.addSubview(shadowView)
                self.imagesScrollView.addSubview(imageView)
                count += 1
            }
        }
        
        self.imagesScrollView.contentSize = CGSize(width: self.imagesScrollView.frame.width * count, height:  self.imagesScrollView.frame.height)
        
        imageScrollViewPageIndicatorViews = [UIView]()
        for i in 0..<Int(count){
            let distanceBetweenCenters: CGFloat = 16
            let pageIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            pageIndicatorView.layer.cornerRadius = 5
            pageIndicatorView.backgroundColor = Constants.Colors.grayHighlight
            pageIndicatorView.tag = i
            if i == 0{
                pageIndicatorView.backgroundColor = Constants.Colors.blueHighlight
                pageIndicatorView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            pageIndicatorView.center.y = self.imagesScrollView.frame.height + self.imagesScrollView.frame.origin.y - 16
            if Int(count) % 2 == 0{
                pageIndicatorView.center.x = self.view.frame.width / 2.0 + CGFloat(i - ((Int(count) - 1) / 2)) * distanceBetweenCenters - distanceBetweenCenters / 2.0
            }else{
                pageIndicatorView.center.x = self.view.frame.width / 2.0 + CGFloat(i - ((Int(count) - 1) / 2)) * distanceBetweenCenters
            }
            self.scrollView.addSubview(pageIndicatorView)
            self.imageScrollViewPageIndicatorViews.append(pageIndicatorView)
        }
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ownerButtonClicked(_ sender: Any) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.AccountSelected), object: self))
    }
    
}

extension SpotDetailViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let imageScrollViewPage = Int((imagesScrollView.contentOffset.x + imagesScrollView.frame.width / 2.0) / imagesScrollView.frame.width)
        if imageScrollViewPage != lastImageScrollViewPage{
            lastImageScrollViewPage = imageScrollViewPage
            UIView.animate(withDuration: 0.4, animations: {
                self.imageScrollViewPageIndicatorViews.forEach{
                    if $0.tag == imageScrollViewPage{
                        $0.backgroundColor = Constants.Colors.blueHighlight
                        $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }else{
                        $0.backgroundColor = Constants.Colors.grayHighlight
                        $0.transform = CGAffineTransform.identity
                    }
                }
            })
        }
    }
    
}


