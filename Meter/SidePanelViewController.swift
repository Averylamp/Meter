//
//  SidePanelViewController.swift
//  FlightBites
//
//  Created by Avery Lamp on 5/24/16.
//  Copyright © 2016 David Jenkins. All rights reserved.
//

import UIKit
import Parse

protocol SidePanelViewControllerDelegate {
    func newPageSelected(_ index: Int)
}

struct NavigationNotifications {
    static let toggleMenu = "ToggleMenuNotification"
    static let AccountSelected = "AccountSelected"
    static let LendSpotSelected = "LendSpotSelected"
    static let FindSpotSelected = "FindSpotSelected"
    static let FreeCreditsSelected = "FreeCreditsSelected"
    static let ParkingHistorySelected = "ParkingHistorySelected"
    static let PaymentSelected = "PaymentSelected"
    static let MessagesSelected = "MessagesSelected"
    static let MySpotsSelected = "MySpotsSelected"
    static let SettingsSelected = "SettingsSelected"
}

class SidePanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var lendNowButton: UIButton!
    @IBOutlet weak var currentUserLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    var delegate: SidePanelViewControllerDelegate?
    
    
//    Find Spot *
//    Free Credits
//    Messages
//    Parking History
//    Payment
//    Settings
    
//    Lend your spot
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        lendNowButton.layer.borderColor = Constants.Colors.blueHighlight.cgColor
        tableView.separatorStyle = .none
        updateProfilePicture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateProfilePicture(){
        DispatchQueue.global().async {
            
        if let currentUser = PFUser.current() {
            do{
                try currentUser.fetchIfNeeded()
                if let ownerName = currentUser["name"] as? String{
                    self.delay(0.0, closure: {
                        self.currentUserLabel.text = ownerName
                    })
                }
                if let proPic = currentUser["profilePicture"] as? PFFile{
                    proPic.getDataInBackground(block: { (data, error) in
                        if error == nil{
                            self.delay(0.0, closure: {
                                self.profilePicture.image = UIImage(data: data!)
                            })
                        }else{
                            print("Error getting profile picture \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }catch{
                print("Failed to fetch current user \(error.localizedDescription)")
            }
        }
        
        }
        
    }
    
    
    func postNotification(_ index: Int){
        let notificationCenter = NotificationCenter.default
        switch index {
        case 0:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.FindSpotSelected), object: self))
        case 1:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.LendSpotSelected), object: self))
        case 2:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.MySpotsSelected), object: self))
        case 3:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.SettingsSelected), object: self))

        default:
            break
        }
//        switch index {
//        case 0:
//            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.FindSpotSelected), object: self))
//        case 1:
//            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.FreeCreditsSelected), object: self))
//        case 2:
//            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.MessagesSelected), object: self))
//        case 3:
//            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.ParkingHistorySelected), object: self))
//        case 4:
//            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.PaymentSelected), object: self))
//        case 5:
//            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.SettingsSelected), object: self))
//        case 6:
//            notificationCenter.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.AccountSelected), object: self))
//        default:
//            break
//        }
    }


    // MARK: - TableView Delegate/Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "pageOptionsCell")
        let imageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        cell.addSubview(imageView)
        
        let seperator = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 1))
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = UIColor(red: 0.816, green: 0.816, blue: 0.816, alpha: 1.00)
        cell.addSubview(seperator)
        cell.addConstraints([
        NSLayoutConstraint(item: seperator, attribute: .width, relatedBy: .equal, toItem: cell, attribute: .width, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: seperator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1.0),
        NSLayoutConstraint(item: seperator, attribute: .centerX, relatedBy: .equal, toItem: cell, attribute: .centerX, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: seperator, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1.0, constant: 0.0)]
        )
        
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 1))
        footer.backgroundColor = UIColor(red: 0.816, green: 0.816, blue: 0.816, alpha: 1.00)
        tableView.tableFooterView = footer
        
        let textLabel = UILabel(frame: CGRect(x: 40,y: 0,width: cell.frame.width - 50, height: 30))
        textLabel.font = UIFont(name: "Avenir-Roman", size: 16)
        textLabel.center.y = cell.center.y
        cell.addSubview(textLabel)

        switch (indexPath as NSIndexPath).row {
        case 0:
            textLabel.text = "Find Spot"
            imageView.image = UIImage(named: "airplane")
        case 1:
            textLabel.text = "Lend your spot"
            imageView.image = UIImage(named: "shopping_cart")
        case 2:
            textLabel.text = "My Spots"
            imageView.image = UIImage(named: "bulleted_list")
        case 3:
            textLabel.text = "Settings"
            imageView.image = UIImage(named: "user")
        
            //        case 6:
            //            textLabel.text = "Help"
        //            imageView.image = UIImage(named: "help")
        default:
            textLabel.text = "Search"
            imageView.image = UIImage(named: "search")
        }
        
//        switch (indexPath as NSIndexPath).row {
//        case 0:
//            textLabel.text = "Find Spot"
//            imageView.image = UIImage(named: "airplane")
//        case 1:
//            textLabel.text = "Free Credits"
//            imageView.image = UIImage(named: "shopping_cart")
//        case 2:
//            textLabel.text = "Messages"
//            imageView.image = UIImage(named: "bulleted_list")
//        case 3:
//            textLabel.text = "Parking History"
//            imageView.image = UIImage(named: "user")
//        case 4:
//            textLabel.text = "Payment"
//            imageView.image = UIImage(named: "coins")
//        case 5:
//            textLabel.text = "Settings"
//            imageView.image = UIImage(named: "share")
////        case 6:
////            textLabel.text = "Help"
////            imageView.image = UIImage(named: "help")
//        default:
//            textLabel.text = "Search"
//            imageView.image = UIImage(named: "search")
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index Path \((indexPath as NSIndexPath).row) Selected")
         NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.toggleMenu), object: self))
        postNotification((indexPath as NSIndexPath).row)
    }
    
    @IBAction func lendSpotClicked(_ sender: Any) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.toggleMenu), object: self))
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.LendSpotSelected), object: self))
    }
    
    @IBAction func viewAccountClicked(_ sender: Any) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: NavigationNotifications.AccountSelected), object: self))
    }
    
}
