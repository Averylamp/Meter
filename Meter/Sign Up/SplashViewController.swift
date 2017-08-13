//
//  SplashViewController.swift
//  Meter
//
//  Created by Avery Lamp on 4/16/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import LTMorphingLabel


class SplashViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var skipButton: UIButton!
    let images:[UIImage] = [#imageLiteral(resourceName: "IntroPage1Image"), #imageLiteral(resourceName: "IntroPage2Image"), #imageLiteral(resourceName: "IntroPage3Image")]
    
    @IBOutlet weak var pageImageView: UIImageView!
    
    @IBOutlet var indicatorViews: [UIView]!
    let subtext = ["Your one stop for all your parking needs. Meter helps you save time and money on parking so that you can focus on what is most important to you.", "Right in your driveway. Listing is simple. Simply list your spot, set prices, select available days, and you’re all set to go! Make over $200 a month from your underutilized space.", "Save up to 50% in parking costs, spend 15 minutes less each day looking for parking. Commuting? Need a consistent place for your car? Use Meter."]
    
    let subtitles = ["welcome to", "passive", "park"]
    let titles = ["meter", "income", "smarter"]
    
    
    let colors = [Constants.Colors.blueHighlight, Constants.Colors.grayHighlight, Constants.Colors.pinkHighlight]
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var subtitleLabel: LTMorphingLabel!
    @IBOutlet weak var titleLabel: LTMorphingLabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForLogin()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        pageImageView.image = images.first
        
        titleLabel.morphingEffect = .scale
        subtitleLabel.morphingEffect = .scale
        
        self.view.layoutIfNeeded()
        initializeScrollView()
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(subtext.count), height: self.scrollView.frame.height)
    }
    
    
    
    func checkForLogin(){
        if  PFUser.current() != nil, FBSDKAccessToken.current() != nil{
            print("Already logged in")
            self.performSegue(withIdentifier: "SplashToMainVCSegue", sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(subtext.count), height: self.scrollView.frame.height)
    }
    
    func initializeScrollView(){
        for i in 0..<subtext.count{
            let textLabel = UILabel(frame: CGRect(x: 0, y:  10, width: self.view.frame.width * 0.75, height:  self.scrollView.frame.height - 20))
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
    
    @IBAction func indicatorSpaceClicked(_ sender: UIButton) {
        indicatorClicked(sender: sender)
    }
    
    func indicatorClicked(sender:UIView){
        print("Indicator Clicked")
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
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
//            self.pageImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            self.pageImageView.alpha = 0.0
        }) { (finished) in
            self.pageImageView.image = self.images[page]
//            self.pageImageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.pageImageView.alpha = 1.0
                self.pageImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
        
        if page == 2{
            UIView.transition(with: self.skipButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.skipButton.setImage(#imageLiteral(resourceName: "introStart"), for: .normal)
                self.skipButton.setImage(#imageLiteral(resourceName: "introStart"), for: .selected)
                self.skipButton.setImage(#imageLiteral(resourceName: "introStart"), for: .highlighted)
            }, completion: nil)
        }else{
            UIView.transition(with: self.skipButton, duration: 0.4, options: .transitionCrossDissolve, animations: {
                self.skipButton.setImage(#imageLiteral(resourceName: "introSkip"), for: .normal)
                self.skipButton.setImage(#imageLiteral(resourceName: "introSkip"), for: .selected)
                self.skipButton.setImage(#imageLiteral(resourceName: "introSkip"), for: .highlighted)
            }, completion: nil)
        }
        
        self.titleLabel.text = titles[page]
        self.subtitleLabel.text = subtitles[page]
        
    }
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        loginClicked(sender)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController{
            self.navigationController?.setViewControllers([loginVC], animated: true)
            
        }
    }
    
    
    @IBAction func registerClicked(_ sender: Any) {
        if let registerVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as? LoginViewController{
            self.navigationController?.setViewControllers([registerVC], animated: true)
            
        }
    }
    
    
}
