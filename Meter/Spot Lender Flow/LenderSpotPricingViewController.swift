//
//  LenderSpotPricingViewController.swift
//  Meter
//
//  Created by Avery Lamp on 7/12/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse

class LenderSpotPricingViewController: UIViewController {
    
var spotPFObject: PFObject? = nil
    
    @IBOutlet weak var monthlyTextField: UITextField!
    @IBOutlet weak var weeklyTextField: UITextField!
    @IBOutlet weak var dailyTextField: UITextField!
    
    @IBOutlet weak var monthlySuggestedRateLabel: UILabel!
    @IBOutlet weak var weeklySuggestedRateLabel: UILabel!
    @IBOutlet weak var dailySuggestRateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthlyTextField.delegate = self
        weeklyTextField.delegate = self
        dailyTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(LenderSpotPricingViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LenderSpotPricingViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let dismissKeyboardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LenderSpotPricingViewController.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardTapGestureRecognizer)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will show")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize)
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func dismissKeyboard(){
        if self.dailyTextField.isFirstResponder{
            self.dailyTextField.resignFirstResponder()
        }
        if self.weeklyTextField.isFirstResponder{
            self.weeklyTextField.resignFirstResponder()
        }
        if self.monthlyTextField.isFirstResponder{
            self.monthlyTextField.resignFirstResponder()
        }
    }
    
    @IBAction func infoButtonClicked(_ sender: Any) {
        print("Info button Clicked")
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension LenderSpotPricingViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextResponder = self.view.viewWithTag(textField.tag + 1) as? UITextField{
            nextResponder.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    
}
