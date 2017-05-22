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

    @IBOutlet weak var backgroundGradientImage: UIImageView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
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
//        profileNameLabel.text = PFUser.current()?["name"] as? String
//        profileEmailLabel.text = PFUser.current()?.email
        if profilePicture != nil {
            self.profilePictureImage.image = profilePicture
        }
        
        addLogoutButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadViewData()
    }
    
    func addLogoutButton(){
        print("\(UIScreen.main.bounds.width)  \(self.view.frame.width)")
        let logoutButton = UIButton(frame: CGRect(x: 50, y: self.view.frame.height - 60, width: self.view.frame.width - 100 - 100, height: 40))
        logoutButton.backgroundColor = UIColor(red: 0.404, green: 0.753, blue: 0.635, alpha: 1.00)
        logoutButton.layer.cornerRadius = 4
        logoutButton.layer.shadowOpacity = 0.2
        logoutButton.layer.shadowRadius = 2
        logoutButton.setTitle("Logout", for: UIControlState())
        logoutButton.setTitleColor(UIColor.white, for: UIControlState())
        logoutButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 16)
        logoutButton.addTarget(self, action: #selector(SidePanelViewController.logoutClicked), for: .touchUpInside)
        self.view.addSubview(logoutButton)
    }
    
    var progressHUD = MBProgressHUD()
    func logoutClicked(){
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.mode = .indeterminate
        progressHUD.labelText = "Loggin Out"
        progressHUD.color = UIColor(white: 1.0, alpha: 1.0)
        progressHUD.labelColor = UIColor.darkGray
        progressHUD.detailsLabelText = ""
        progressHUD.detailsLabelColor = UIColor.darkGray
        progressHUD.activityIndicatorColor = UIColor.darkGray
        progressHUD.dimBackground = true
//        PFUser.logOut()
        
        delay(0.5) { 
            self.progressHUD.detailsLabelText = "User logged out"
            self.delay(0.5, closure: {
                MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
                
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            })
        }
    }
    
    
    func loadViewData(){
        
        let gradient = CAGradientLayer()
        gradient.frame = backgroundGradientImage.frame
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.backgroundColor = UIColor.green.cgColor
        gradient.colors = [UIColor(red: 0.369, green: 0.216, blue: 0.424, alpha: 1.00).cgColor,UIColor(red: 0.722, green: 0.478, blue: 0.816, alpha: 1.00).cgColor]
        let bgImage = imageFromLayer(gradient)
        backgroundGradientImage.image = bgImage
        
        
    }
    
    func imageFromLayer(_ layer:CALayer) -> UIImage{
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - TableView Delegate/Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "pageOptionsCell")
        let imageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        cell.addSubview(imageView)
        
        let textLabel = UILabel(frame: CGRect(x: 80,y: 10,width: cell.frame.width - 90, height: 30))
        textLabel.font = UIFont(name: "Avenir-Light", size: 14)
        cell.addSubview(textLabel)
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            textLabel.text = "Search"
            imageView.image = UIImage(named: "airplane")
        case 1:
            textLabel.text = "Cart"
            imageView.image = UIImage(named: "shopping_cart")
        case 2:
            textLabel.text = "History"
            imageView.image = UIImage(named: "bulleted_list")
        case 3:
            textLabel.text = "Account"
            imageView.image = UIImage(named: "user")
        case 4:
            textLabel.text = "Payments"
            imageView.image = UIImage(named: "coins")
        case 5:
            textLabel.text = "Share"
            imageView.image = UIImage(named: "share")
        case 6:
            textLabel.text = "Help"
            imageView.image = UIImage(named: "help")
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
        print("Index Path \((indexPath as NSIndexPath).row) Selected")
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(Notification(name: Notification.Name(rawValue: "ToggleLeftMenu"), object: self))
        postNotification((indexPath as NSIndexPath).row)
    }
    
    
}
