//
//  LenderSpotPhotosViewController.swift
//  Meter
//
//  Created by Avery Lamp on 7/12/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices

class LenderSpotPhotosViewController: UIViewController {
    
    var spotPFObject: PFObject? = nil
    
    @IBOutlet weak var continueButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeUpImageView: UIImageView!
    
    @IBOutlet weak var surroundingsImageView: UIImageView!
    @IBOutlet weak var additionalImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkForRequiredImages()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func addImageClicked(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Close Up Clicked")
        case 1:
            print("Surroundings Clicked")
        case 2:
            print("Addional Clicked")
        default:
            print("Image clicked")
        }
        promptImageRetrieval(type: sender.tag)
    }
    
    func promptImageRetrieval(type: Int){
        let actionSheet = UIAlertController(title: "Pick your image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Choose Existing", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.view.tag = type
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.mediaTypes = [kUTTypeImage as String]
            self.present(picker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            let picker = UIImagePickerController()
            picker.view.tag = type
            picker.delegate = self
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.mediaTypes = [kUTTypeImage as String]
            self.present(picker, animated: true, completion: nil)
        }))
        if type == 2 && self.additionalImageView.image != #imageLiteral(resourceName: "addImageTemporary"){
            actionSheet.addAction(UIAlertAction(title: "Remove Photo", style: .destructive, handler: { (action) in
                UIView.transition(with: self.additionalImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.additionalImageView.image = #imageLiteral(resourceName: "addImageTemporary")
                }, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }

    @IBAction func continueButtonClicked(_ sender: Any) {
        if self.closeUpImageView.image != #imageLiteral(resourceName: "addImageTemporary"), let closeUpImage = self.closeUpImageView.image, self.surroundingsImageView != #imageLiteral(resourceName: "addImageTemporary"), let surroundingsImage = self.surroundingsImageView.image, self.spotPFObject != nil{
            DispatchQueue.global().async {
                if let closeUpData = UIImagePNGRepresentation(closeUpImage), let closeUpPFFile = PFFile(data: closeUpData){
                    self.spotPFObject![SpotKeys.SpotPicture] = closeUpPFFile
                }
                if let surroundingImageData = UIImagePNGRepresentation(surroundingsImage), let surroundingImagePFFile = PFFile(data: surroundingImageData){
                    self.spotPFObject![SpotKeys.EntrancePicture] = surroundingImagePFFile
                }
                DispatchQueue.main.sync {
                    if self.additionalImageView.image != #imageLiteral(resourceName: "addImageTemporary"), let additionalImage = self.additionalImageView.image, let additionalImageData = UIImagePNGRepresentation(additionalImage), let addionalImagePFFile = PFFile(data: additionalImageData){
                        self.spotPFObject![SpotKeys.AdditionalPicture] = addionalImagePFFile
                    }
                }
                DispatchQueue.main.async {
                    self.transitionToPricingVC()
                }
            }
        
        }else{
            let alertController = UIAlertController(title: "Requirements not met", message: "Please add the required images", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
            self.checkForRequiredImages()
        }
    }
    
    func transitionToPricingVC(){
        if let lenderPricingVC = UIStoryboard(name: "LendSpot", bundle: nil).instantiateViewController(withIdentifier: "LenderSpotPricingVC")as? LenderSpotPricingViewController{
            lenderPricingVC.spotPFObject = self.spotPFObject
            
            self.navigationController?.pushViewController(lenderPricingVC, animated: true)
        }
        
    }
    
}

extension LenderSpotPhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            print("Image Found")
            if let editedImage = info[UIImagePickerControllerEditedImage] as?  UIImage{
                print("Edited Image Found")
                switch picker.view.tag {
                case 0:
                    print("Close Up Image Returned")
                    UIView.transition(with: self.closeUpImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.closeUpImageView.image = editedImage
                    }, completion: nil)
                case 1:
                    print("Surroundings Image Returned")
                    UIView.transition(with: self.surroundingsImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.surroundingsImageView.image = editedImage
                    }, completion: nil)
                case 2:
                    print("Addional Image Returned")
                    UIView.transition(with: self.additionalImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.additionalImageView.image = editedImage
                    }, completion: nil)
                default:
                    print("Image Returned")
                }
            }else{
                print("Edited Image Not Found")
                switch picker.view.tag {
                case 0:
                    print("Close Up Image Returned")
                    UIView.transition(with: self.closeUpImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.closeUpImageView.image = image
                    }, completion: nil)
                case 1:
                    print("Surroundings Image Returned")
                    UIView.transition(with: self.surroundingsImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.surroundingsImageView.image = image
                    }, completion: nil)
                case 2:
                    print("Addional Image Returned")
                    UIView.transition(with: self.additionalImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        self.additionalImageView.image = image
                    }, completion: nil)
                default:
                    print("Image Returned")
                }
            }
        }
        self.checkForRequiredImages()
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkForRequiredImages(){
//        if closeUpImageView.image != #imageLiteral(resourceName: "addImageTemporary") && self.surroundingsImageView.image != #imageLiteral(resourceName: "addImageTemporary"){
            UIView.animate(withDuration: 0.5, animations: {
                self.continueButtonHeightConstraint.constant = 50
                self.view.layoutIfNeeded()
            })
//        }else{
//            UIView.animate(withDuration: 0.5, animations: {
//                self.continueButtonHeightConstraint.constant = 0
//                self.view.layoutIfNeeded()
//            })
//        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
