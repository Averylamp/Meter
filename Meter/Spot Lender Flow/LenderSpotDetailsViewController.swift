//
//  LenderSpotDetailsViewController.swift
//  Meter
//
//  Created by Avery Lamp on 7/12/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse

class LenderSpotDetailsViewController: UIViewController {
    
    var spotPFObject: PFObject? = nil
    
    @IBOutlet weak var shortDescriptionTextView: UITextView!
    @IBOutlet weak var aboutSpotTextView: UITextView!
    @IBOutlet weak var parkingInstructionsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortDescriptionTextView.delegate = self
        aboutSpotTextView.delegate = self
        parkingInstructionsTextView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(LenderSpotPricingViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LenderSpotPricingViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LenderSpotPricingViewController.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    var keyboardHeight: CGFloat = 0
    func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will show")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
        
    }
    
    func shiftUp(height: CGFloat){
        UIView.animate(withDuration: 0.5) {
            self.view.frame.origin.y = -height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    func dismissKeyboard(){
        if self.shortDescriptionTextView.isFirstResponder{
            self.shortDescriptionTextView.resignFirstResponder()
        }
        if self.aboutSpotTextView.isFirstResponder{
            self.aboutSpotTextView.resignFirstResponder()
        }
        if self.parkingInstructionsTextView.isFirstResponder{
            self.parkingInstructionsTextView.resignFirstResponder()
        }
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if let spotListedVC = UIStoryboard(name: "LendSpot", bundle: nil).instantiateViewController(withIdentifier: "SpotListingCompleteVC") as? LenderSpotCompletedViewController{
            
            self.navigationController?.pushViewController(spotListedVC, animated: true)
        }
    }
    
}

extension LenderSpotDetailsViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case self.shortDescriptionTextView:
            print("Short Description Selected")
        case self.aboutSpotTextView:
            print("About Spot Selected")
            if keyboardHeight > 0{
                self.shiftUp(height: keyboardHeight)
            }else{
                self.shiftUp(height: 216)
            }
        case self.parkingInstructionsTextView:
            print("Parking Instructions Selected")
            if keyboardHeight > 0{
                self.shiftUp(height: keyboardHeight)
            }else{
                self.shiftUp(height: 216)
            }
        default:
            print("Some text view selected")
        }
    }
    
}
