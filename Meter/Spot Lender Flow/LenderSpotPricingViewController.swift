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
    @IBOutlet weak var monthlyCheckboxButton: UIButton!
    @IBOutlet weak var weeklyCheckboxButton: UIButton!
    @IBOutlet weak var dailyCheckboxButton: UIButton!
    
    
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
    
    @IBAction func checkboxClicked(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "checkboxUnchecked"){
            UIView.transition(with: sender, duration: 0.3, options: .transitionCrossDissolve, animations: {
                sender.setImage(#imageLiteral(resourceName: "checkboxChecked"), for: .normal)
            }, completion: nil)
        }else{
            UIView.transition(with: sender, duration: 0.3, options: .transitionCrossDissolve, animations: {
                sender.setImage(#imageLiteral(resourceName: "checkboxUnchecked"), for: .normal)
            }, completion: nil)
        }
        self.saveInformation()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveInformation(){
        if let monthlyPrice = Double(self.monthlyTextField.text!) {
            self.spotPFObject![SpotKeys.MonthlyPrice] = monthlyPrice
        }else if let placeholderPrice = Double(self.monthlyTextField.placeholder!){
            self.spotPFObject![SpotKeys.MonthlyPrice] = placeholderPrice
        }else{
            self.spotPFObject![SpotKeys.MonthlyPrice] = 0
        }
        if let weeklyPrice = Double(self.weeklyTextField.text!) {
            self.spotPFObject![SpotKeys.WeeklyPrice] = weeklyPrice
        }else if let placeholderPrice = Double(self.weeklyTextField.placeholder!){
            self.spotPFObject![SpotKeys.WeeklyPrice] = placeholderPrice
        }else{
            self.spotPFObject![SpotKeys.WeeklyPrice] = 0
        }
        if let dailyPrice = Double(self.dailyTextField.text!) {
            self.spotPFObject![SpotKeys.DailyPrice] = dailyPrice
        }else if let placeholderPrice = Double(self.dailyTextField.placeholder!){
            self.spotPFObject![SpotKeys.DailyPrice] = placeholderPrice
        }else{
            self.spotPFObject![SpotKeys.DailyPrice] = 0
        }
        if monthlyCheckboxButton.currentImage == #imageLiteral(resourceName: "checkboxChecked"){
            self.spotPFObject![SpotKeys.AvailableMonthly] = true
        }else{
            self.spotPFObject![SpotKeys.AvailableMonthly] = false
        }
        if weeklyCheckboxButton.currentImage == #imageLiteral(resourceName: "checkboxChecked"){
            self.spotPFObject![SpotKeys.AvailableWeekly] = true
        }else{
            self.spotPFObject![SpotKeys.AvailableWeekly] = false
        }
        if dailyCheckboxButton.currentImage == #imageLiteral(resourceName: "checkboxChecked"){
            self.spotPFObject![SpotKeys.AvailableDaily] = true
        }else{
            self.spotPFObject![SpotKeys.AvailableDaily] = false
        }
        
        
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        if let lenderSpotDetailsVC = UIStoryboard(name: "LendSpot", bundle: nil).instantiateViewController(withIdentifier: "LenderSpotDetailsVC") as? LenderSpotDetailsViewController{
            saveInformation()
            
            
            lenderSpotDetailsVC.spotPFObject = self.spotPFObject
            self.navigationController?.pushViewController(lenderSpotDetailsVC, animated: true)
        }
        
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case monthlyTextField:
            print("Monthly Text Field Selected")
        case weeklyTextField:
            print("Weekly Text Field Selected")
            if keyboardHeight > 0{
                self.shiftUp(height: keyboardHeight)
            }else{
                self.shiftUp(height: 216)
            }
        case dailyTextField:
            print("Daily Text Field Selected")
            if keyboardHeight > 0{
                self.shiftUp(height: keyboardHeight)
            }else{
                self.shiftUp(height: 216)
            }
        default:
            print("Unknown Text field selected")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if  Double(textField.text!) == nil{
            textField.text = ""
        }else{
            saveInformation()
        }
    }
    
    
    
}
