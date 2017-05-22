//
//  MainNavigationViewController.swift
//  FlightBites
//
//  Created by Avery Lamp on 5/25/16.
//  Copyright © 2016 David Jenkins. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {
    
    fileprivate var searchSelectedObserver: NSObjectProtocol?
    fileprivate var searchClearObserver: NSObjectProtocol?
    fileprivate var cartSelectedObserver: NSObjectProtocol?
    fileprivate var historySelectedObserver: NSObjectProtocol?
    fileprivate var accountSelectedObserver: NSObjectProtocol?
    fileprivate var settingsSelectedObserver: NSObjectProtocol?
    fileprivate var shareSelectedObserver: NSObjectProtocol?
    fileprivate var helpSelectedObserver: NSObjectProtocol?
    
    var profilePicture: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var searchVCS = [UIViewController]()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    func addObservers(){
        let notificationCenter = NotificationCenter.default
        searchSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: SidePanelViewController.Notifications.SearchSelected), object: nil, queue: nil, using: { (notification) in
            self.storeCurrentVCS()
            if self.searchVCS.count > 0 {
                self.setViewControllers(self.searchVCS, animated: true)
            }else{
//                let searchVC = UIStoryboard(name: "Search", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
//                self.searchVCS.append(searchVC!)
                self.setViewControllers(self.searchVCS, animated: true)
            }
        })
        searchClearObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: SidePanelViewController.Notifications.SearchClear), object: nil, queue: nil, using: { (notification) in
            self.searchVCS = [UIViewController]()
        })
        cartSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: SidePanelViewController.Notifications.CartSelected), object: nil, queue: nil, using: { (notification) in
            self.storeCurrentVCS()
            let cartVC = UIStoryboard(name: "Cart", bundle: Bundle.main).instantiateViewController(withIdentifier: "CartViewController")
            if notification.object as? SidePanelViewController != nil {
                self.setViewControllers([cartVC], animated: true)
            }else{
                UIView.animate(withDuration: 0.8, animations: {
                    UIView.setAnimationCurve(.easeInOut)
                    self.setViewControllers([cartVC], animated: false)
                    UIView.setAnimationTransition(.curlUp, for: self.view, cache: false)
                })
                
            }
            
        })
        
        accountSelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: SidePanelViewController.Notifications.AccountSelected), object: nil, queue: nil, using: { (notification) in
            self.storeCurrentVCS()
            let accountVC = UIStoryboard(name: "Account", bundle: Bundle.main).instantiateViewController(withIdentifier: "AccountViewController")
            self.setViewControllers([accountVC], animated: true)
        })
        
        historySelectedObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: SidePanelViewController.Notifications.HistorySelected), object: nil, queue: nil, using: { (notification) in
            let orderHistoryVC = UIStoryboard(name: "OrderHistory", bundle: nil).instantiateViewController(withIdentifier: "OrderHistoryViewController")
            self.setViewControllers([orderHistoryVC], animated: true)
        })
    }
    
    func storeCurrentVCS(){
//        if (self.viewControllers.first as? SearchViewController) != nil {
//            self.searchVCS = self.viewControllers
//        }
    }
    
    func removeObservers(){
        let notificationCenter = NotificationCenter.default
        
        if searchSelectedObserver != nil{
            notificationCenter.removeObserver(searchSelectedObserver!)
        }
        if cartSelectedObserver != nil{
            notificationCenter.removeObserver(cartSelectedObserver!)
        }
        if historySelectedObserver != nil{
            notificationCenter.removeObserver(historySelectedObserver!)
        }
        if accountSelectedObserver != nil{
            notificationCenter.removeObserver(accountSelectedObserver!)
        }
        if settingsSelectedObserver != nil{
            notificationCenter.removeObserver(settingsSelectedObserver!)
        }
        if shareSelectedObserver != nil{
            notificationCenter.removeObserver(shareSelectedObserver!)
        }
        if helpSelectedObserver != nil{
            notificationCenter.removeObserver(helpSelectedObserver!)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
