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
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
