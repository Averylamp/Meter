//
//  SidePanelViewController.swift
//  FlightBites
//
//  Created by Avery Lamp on 5/24/16.
//  Copyright © 2016 David Jenkins. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol SidePanelViewControllerDelegate {
    func newPageSelected(_ index: Int)
}

class SidePanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SidePanelViewControllerDelegate?
    var profilePicture:UIImage? = nil
    
    struct Notifications {
        static let SearchSelected = "SearchSelected"
        static let SearchClear = "SearchCleared"
        static let CartSelected = "CartSelected"
        static let HistorySelected = "HistorySelected"
        static let AccountSelected = "AccountSelected"
        static let SettingsSelected = "SettingsSelected"
        static let ShareSelected = "ShareSelected"
        static let HelpSelected = "HelpSelected"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func postNotification(_ index: Int){
        let notificationCenter = NotificationCenter.default
        switch index {
        case 0:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: Notifications.SearchSelected), object: self))
        case 1:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: Notifications.CartSelected), object: self))
        case 2:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: Notifications.HistorySelected), object: self))
        case 3:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: Notifications.AccountSelected), object: self))
        case 4:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: Notifications.SettingsSelected), object: self))
        case 5:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: Notifications.ShareSelected), object: self))
        case 6:
            notificationCenter.post(Notification(name: Notification.Name(rawValue: Notifications.HelpSelected), object: self))
        default:
            break
        }
    }


    // MARK: - TableView Delegate/Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        
        
        
        let textLabel = UILabel(frame: CGRect(x: 40,y: 10,width: cell.frame.width - 50, height: 30))
        textLabel.font = UIFont(name: "Avenir-Roman", size: 16)
        textLabel.center.y = cell.center.y
        cell.addSubview(textLabel)
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            textLabel.text = "Payments"
            imageView.image = UIImage(named: "airplane")
        case 1:
            textLabel.text = "Free Credits"
            imageView.image = UIImage(named: "shopping_cart")
        case 2:
            textLabel.text = "Parking History"
            imageView.image = UIImage(named: "bulleted_list")
        case 3:
            textLabel.text = "Help"
            imageView.image = UIImage(named: "user")
        case 4:
            textLabel.text = "Settings"
            imageView.image = UIImage(named: "coins")
//        case 5:
//            textLabel.text = "Share"
//            imageView.image = UIImage(named: "share")
//        case 6:
//            textLabel.text = "Help"
//            imageView.image = UIImage(named: "help")
        default:
            textLabel.text = "Search"
            imageView.image = UIImage(named: "search")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Index Path \((indexPath as NSIndexPath).row) Selected")
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.post(Notification(name: Notification.Name(rawValue: "ToggleLeftMenu"), object: self))
//        postNotification((indexPath as NSIndexPath).row)
    }
    
    
}
