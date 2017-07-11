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
        
    }
    
    func fitLabelHeights(){
        shortDescriptionHeightConstraint.constant = shortDescriptionLabel.heightForLabel() + 6
        longDescriptionHeightConstraint.constant = longDescriptionLabel.heightForLabel() + 6
        self.view.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: longDescriptionLabel.frame.origin.y + longDescriptionLabel.frame.height)
        self.contentViewHeightConstraint.constant = longDescriptionLabel.frame.origin.y + longDescriptionLabel.frame.height
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
    
    func setupDetailImages(){
        self.imagesScrollView.subviews.forEach{$0.removeFromSuperview()}
        let imageOrder = ["spot", "map", "entrance", "additional"]
        var count:CGFloat = 0
        for imageType in imageOrder{
            if let imageIndex = self.imageOrder.index(of: imageType){
                let image = self.spotImages[imageIndex]
                let imageView = UIImageView(frame:CGRect(x: count * self.imagesScrollView.frame.width + 15, y: 10, width: self.imagesScrollView.frame.width - 30, height: self.imagesScrollView.frame.height - 30))
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 8
                let shadowView = UIView(frame: imageView.frame)
                shadowView.backgroundColor = UIColor.white
                shadowView.layer.cornerRadius = imageView.layer.cornerRadius
                shadowView.layer.shadowRadius = 6
                shadowView.layer.shadowOpacity = 0.5
                shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
                self.imagesScrollView.addSubview(shadowView)
                self.imagesScrollView.addSubview(imageView)
                count += 1
            }
        }
        
            
        self.imagesScrollView.contentSize = CGSize(width: self.imagesScrollView.frame.width * count, height:  self.imagesScrollView.frame.height)
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

