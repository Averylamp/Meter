//
//  ContainerViewController.swift
//  FlightBites
//
//  Created by Avery Lamp on 5/24/16.
//  Copyright © 2016 David Jenkins. All rights reserved.
//

import UIKit

enum SlideState{
    case bothCollapsed
    case leftPanelExpanded
}

class ContainerViewController: UIViewController, ActiveViewControllerDelegate {

    var activeNavigationController: MainNavigationViewController!
    var activeViewController: UIViewController!
    var currentState: SlideState = .bothCollapsed {
        didSet{
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForActiveViewController(shouldShowShadow)
        }
    }
    
    var leftPanelController: SidePanelViewController?
    let centerPanelExpandedOffset: CGFloat = 100
    var profilePicture: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let NavStoryboard = UIStoryboard(name: "Navigation", bundle: Bundle.main)

        
        activeNavigationController = NavStoryboard.instantiateViewController(withIdentifier: "NavigationViewController") as! MainNavigationViewController
        view.addSubview(activeNavigationController.view)
        addChildViewController(activeNavigationController)
        
        activeNavigationController.didMove(toParentViewController: self)
        
//        let searchVC =  UIStoryboard(name: "Search", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
//        activeNavigationController.searchVCS = [searchVC!]
        activeNavigationController.setViewControllers(activeNavigationController.searchVCS, animated: false)
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        activeNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        
//        if profilePicture == nil{
//            if FBSDKAccessToken.current() != nil {
//                
//                FBSDKGraphRequest(graphPath: "me", parameters: ["fields":""]).start(completionHandler: { (connection, result, error) -> Void in
//                    if error == nil{
//                        if let dict = result as? Dictionary<String, AnyObject>{
//                            let fbUserId = dict["id"]
////                            let defaults = NSUserDefaults.standardUserDefaults()
////                            if let picture = defaults.objectForKey(fbUserId as! String){
////                                self.profilePicture = picture as? UIImage
////                            }else{
//                            
//                            let pictureURL = "https://graph.facebook.com/\(fbUserId!)/picture?type=large&return_ssl_resources=1"
//                            let urlRequest = URL(string: pictureURL)
//                            let urlRequestNeeded = URLRequest(url: urlRequest!)
//                            
//                            NSURLConnection.sendAsynchronousRequest(urlRequestNeeded, queue: OperationQueue.main, completionHandler: { (response, data, error) in
//                                if error == nil{
//                                    let image = UIImage(data: data!)
////                                    print("Image Found")
//                                    self.profilePicture = image
//                                    self.activeNavigationController.profilePicture = image
////                                    defaults.setObject(image, forKey: fbUserId as! String)
//                                }else{
//                                    print("Error - \(error)")
//                                }
//                            })
//                            
//                        }
//                    }
//                })
//            }
//
//        }
    }
    fileprivate var toggleObserver: NSObjectProtocol?
    override func viewDidAppear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        toggleObserver = notificationCenter.addObserver(forName: NSNotification.Name(rawValue: "ToggleLeftMenu"), object: nil, queue: nil, using: { (notofication) in
            self.toggleLeftPanel()
        })
    }
    
    // MARK: - Active View Controller Delegate
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = currentState != .leftPanelExpanded
        if notAlreadyExpanded{
            addLeftPanelViewController()
        }
        
        animateLeftPanel(notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        if leftPanelController == nil {
            leftPanelController = UIStoryboard(name: "Navigation", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeftPanelViewController") as? SidePanelViewController
            leftPanelController?.profilePicture = self.profilePicture
            addChildSidePanelController(leftPanelController!)
            leftPanelController!.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - centerPanelExpandedOffset, height: self.view.frame.height)
            leftPanelController?.view.layoutIfNeeded()
            leftPanelController!.loadViewData()
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController){
        view.insertSubview(sidePanelController.view, at: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    func animateLeftPanel(_ shouldExpand: Bool){
        if shouldExpand {
            currentState = .leftPanelExpanded
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "leftPanelExpanded"), object: self))
            animateCenterPanelXPosition(activeNavigationController.view.frame.width - centerPanelExpandedOffset)
        }else {
            animateCenterPanelXPosition(0){ finished in
                self.currentState = .bothCollapsed
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "menusCollapsed"), object: self))
                self.leftPanelController!.view.removeFromSuperview()
                self.leftPanelController = nil
            }
        }
            
    }
    
    func animateCenterPanelXPosition(_ targetPosition:CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.activeNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForActiveViewController(_ shouldShowShadow: Bool){
        if shouldShowShadow{
            activeNavigationController.view.layer.shadowOpacity = 0.8
        }else{
            activeNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    

}

extension ContainerViewController: UIGestureRecognizerDelegate{
    //MARK: - Gesture recognizer
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer){
        let gestureIsDraggingFromLeftToRight = recognizer.velocity(in: view).x > 0
        
        switch recognizer.state {
        case .began:
            if currentState == .bothCollapsed{
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                }
                showShadowForActiveViewController(true)
            }
        case .changed:
            let translation = recognizer.translation(in: view).x
            if translation < 0 && currentState == .bothCollapsed {break}
            recognizer.view?.center.x = recognizer.view!.center.x + translation
            recognizer.setTranslation(CGPoint.zero, in: view)
        case .ended:
            if leftPanelController != nil {
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if currentState != .bothCollapsed {
            return true
        }
        if touch.location(in: self.view).x < self.view.frame.width / 3{
            return true
        }else {
            return false
        }
    }
}
