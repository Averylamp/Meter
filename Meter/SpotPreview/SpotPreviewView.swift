//
//  SpotPreviewView.swift
//  Meter
//
//  Created by Avery Lamp on 7/9/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
@IBDesignable

class SpotPreviewView: UIView {

    @IBOutlet var starImageViews: [UIImageView]!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var spotNumberLabel: UILabel!
    @IBOutlet weak var pinIconImageView: UIImageView!
    @IBOutlet weak var spotTitleLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    var contentView : UIView!
    
    @IBOutlet weak var restrictionsLabel: UILabel!
    @IBOutlet weak var dailyRateLabel: UILabel!
    @IBOutlet weak var monthlyRateLabel: UILabel!
    
    
    let nibName = "SpotPreviewView"
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
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

}
