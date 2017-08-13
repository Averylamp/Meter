//
//  MainNavigationViewController.swift
//  FlightBites
//
//  Created by Avery Lamp on 5/25/16.
//  Copyright © 2016 David Jenkins. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    
    fileprivate var findSpotSelectedObserver: NSObjectProtocol?
    fileprivate var freeCreditsSelectedObserver: NSObjectProtocol?
    fileprivate var messagesSelectedObserver: NSObjectProtocol?
    fileprivate var parkingHistorySelectedObserver: NSObjectProtocol?
    fileprivate var paymentSelectedObserver: NSObjectProtocol?
    fileprivate var settingsSelectedObserver: NSObjectProtocol?
    fileprivate var accountSelectedObserver: NSObjectProtocol?
    fileprivate var lendSpotSelectedObserver: NSObjectProtocol?
    fileprivate var mySpotsSelectedObserver: NSObjectProtocol?
    
    var profilePicture: UIImage? = nil
    var mainVCS = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    func addObservers(){
        let notificationCenter = NotificationCenter.default
        findSpotSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.FindSpotSelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            if self.mainVCS.count > 0{
                self.setViewControllers(self.mainVCS, animated: true)
            }else{
                 let mainVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController")
                self.mainVCS = [mainVC]
                self.setViewControllers(self.mainVCS, animated: true)
            }
        })
        
        freeCreditsSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.FreeCreditsSelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            let settingsVC = UIStoryboard(name: "Promotion", bundle: nil).instantiateViewController(withIdentifier: "ReferralVC")
            self.setViewControllers([settingsVC], animated: true)
        })
        
        messagesSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.MessagesSelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            let messageListVC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "MessageListVC")
            self.setViewControllers([messageListVC], animated: true)
        })
        
        parkingHistorySelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.ParkingHistorySelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            let parkingHistoryVC = UIStoryboard(name: "ParkingHistory", bundle: nil).instantiateViewController(withIdentifier: "ParkingHistory")
            self.setViewControllers([parkingHistoryVC], animated: true)
        })
        
        paymentSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.PaymentSelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            let settingsVC = UIStoryboard(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "PaymentMainVC")
            self.setViewControllers([settingsVC], animated: true)
        })
        
        settingsSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.SettingsSelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC")
            self.setViewControllers([settingsVC], animated: true)
        })
        
        accountSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.AccountSelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            let settingsVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "EditAccountVC")
            self.setViewControllers([settingsVC], animated: true)
        })
        
        lendSpotSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.LendSpotSelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            let spotLendVC = UIStoryboard(name: "LendSpot", bundle: nil).instantiateViewController(withIdentifier: "LenderIntroVC")
            self.setViewControllers([spotLendVC], animated: true)
        })
        
        mySpotsSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.MySpotsSelected), object: nil, queue: nil, using: { (notification) in
            self.storeVCs()
            let mySpotVC = UIStoryboard(name: "Account", bundle: nil).instantiateViewController(withIdentifier: "MySpotsVC")
            self.setViewControllers([mySpotVC], animated: true)
        })
    }
    
    func storeVCs(){
        if let mainVC =  self.viewControllers.first as? MainViewController{
            self.mainVCS = self.viewControllers
        }
    }
    
    func removeObservers(){
        let notificationCenter = NotificationCenter.default
        
        if findSpotSelectedObserver != nil{
            notificationCenter.removeObserver(findSpotSelectedObserver!)
        }
        if freeCreditsSelectedObserver != nil{
            notificationCenter.removeObserver(freeCreditsSelectedObserver!)
        }
        if messagesSelectedObserver != nil{
            notificationCenter.removeObserver(messagesSelectedObserver!)
        }
        if parkingHistorySelectedObserver != nil{
            notificationCenter.removeObserver(parkingHistorySelectedObserver!)
        }
        if paymentSelectedObserver != nil{
            notificationCenter.removeObserver(paymentSelectedObserver!)
        }
        if settingsSelectedObserver != nil{
            notificationCenter.removeObserver(settingsSelectedObserver!)
        }
        if accountSelectedObserver != nil{
            notificationCenter.removeObserver(accountSelectedObserver!)
        }
        if lendSpotSelectedObserver != nil{
            notificationCenter.removeObserver(lendSpotSelectedObserver!)
        }
        if mySpotsSelectedObserver != nil{
            notificationCenter.removeObserver(mySpotsSelectedObserver!)
        }
    }
    
    
   
    
}
