//
//  SplashViewController.swift
//  Meter
//
//  Created by Avery Lamp on 4/16/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let images:[UIImage] = [#imageLiteral(resourceName: "IntroPage1Image"), #imageLiteral(resourceName: "IntroPage2Image"), #imageLiteral(resourceName: "IntroPage3Image")]
    
    @IBOutlet weak var pageImageView: UIImageView!
    
    @IBOutlet var indicatorViews: [UIView]!
    let subtext = ["We connect drivers like you to privately owned, unused parking spaces so you can enjoy cheaper more reliable parking", "Meter provides options for monthly and daily parking. Simply select where you would like to park, and choose the duration you would like to book the spot!", "More text that describes how awesome our service is! Maybe something that addresses security or legal concerns"]
    
    let colors = [Constants.Colors.blueHighlight, Constants.Colors.grayHighlight, Constants.Colors.pinkHighlight]
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var meterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(subtext.count), height: self.view.frame.height)
        scrollView.showsHorizontalScrollIndicator = false
        pageImageView.image = images.first
        pageImageView.contentMode = .scaleAspectFit
        
        initializeScrollView()
    }
    
    func initializeScrollView(){
        for i in 0..<subtext.count{
            let textLabel = UILabel(frame: CGRect(x: 0, y: self.meterLabel.frame.origin.y + self.meterLabel.frame.height + 10, width: self.view.frame.width * 0.7, height: self.indicatorView.frame.origin.y - (self.meterLabel.frame.origin.y + self.meterLabel.frame.height + 10)))
            textLabel.textAlignment = .center
            textLabel.numberOfLines = 0
            textLabel.font = UIFont(name: "Avenir-Light", size: 16)
            textLabel.text = subtext[i]
            self.scrollView.addSubview(textLabel)
            textLabel.center.x = self.view.center.x + self.view.frame.width * CGFloat(i)
            print("here \(textLabel.frame)")
        }
        indicatorViews.forEach {
            if $0.tag != 0{
                $0.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1.0)
            }else{
                $0.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
            }
            ($0 as! UIButton).addTarget(self, action: #selector(SplashViewController.indicatorClicked(sender:)), for: .touchUpInside)
        }
        
    }
    
    var currentPage = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width;
        let page = Int((scrollView.contentOffset.x + (0.5 * width)) / width);
        if page != currentPage{
            animatePageChange(page: page)
            currentPage = page
        }
        
    }
    
    func indicatorClicked(sender:UIView){
        let nextPage = CGRect(x: self.view.frame.width * CGFloat(sender.tag), y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.scrollRectToVisible(nextPage, animated: true)
    }
    
    func animatePageChange(page: Int){
        print("Page changed - \(page)")
        
        indicatorViews.forEach {indicator in
            if indicator.tag != page{
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    indicator.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1.0)
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    indicator.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
                }, completion: nil)
            }
        }
        self.pageImageView.alpha = 1.0
        self.pageImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
//            self.pageImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.pageImageView.alpha = 0.0
        }) { (finished) in
            self.pageImageView.image = self.images[page]
            self.pageImageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.pageImageView.alpha = 1.0
                self.pageImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
        
        
    }
    
    
    
}
