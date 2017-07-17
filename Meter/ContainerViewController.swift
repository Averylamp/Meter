//
//  ContainerViewController.swift
//  FlightBites
//
//  Created by Avery Lamp on 5/24/16.
//  Copyright © 2016 David Jenkins. All rights reserved.
//

import UIKit

enum SlideState{
    case mainVC
    case leftPanelExpanded
}



class ContainerViewController: UIViewController {
    
    var activeNavigationController: MainNavigationViewController!
    var activeViewController: UIViewController!
    var currentState: SlideState = .mainVC
    
    var leftPanelController = SidePanelViewController()
    let leftPanelWidth: CGFloat = 240
    var profilePicture: UIImage? = nil
    var containerOverlay = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let NavStoryboard = UIStoryboard(name: "Navigation", bundle: Bundle.main)
        
        
        activeNavigationController = NavStoryboard.instantiateViewController(withIdentifier: "NavigationViewController") as! MainNavigationViewController
        view.addSubview(activeNavigationController.view)
        addChildViewController(activeNavigationController)
        
        activeNavigationController.didMove(toParentViewController: self)
        
        let mainVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController")
        //        let searchVC =  UIStoryboard(name: "Search", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        activeNavigationController.mainVCS = [mainVC]
        activeNavigationController.setViewControllers(activeNavigationController.mainVCS, animated: false)
        
        containerOverlay = UIButton(frame: self.view.frame)
        containerOverlay.backgroundColor = UIColor.black
        containerOverlay.isUserInteractionEnabled = false
        containerOverlay.layer.opacity = 0.0
        containerOverlay.addTarget(self, action: #selector(ContainerViewController.overlayClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(containerOverlay)
        
        self.addLeftPanelViewController()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        activeNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        let panelPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
        panelPanGestureRecognizer.delegate = self
        leftPanelController.view.addGestureRecognizer(panelPanGestureRecognizer)
        let tableViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerViewController.handlePanGesture(_:)))
        tableViewPanGestureRecognizer.delegate = self
        leftPanelController.tableView.addGestureRecognizer(tableViewPanGestureRecognizer)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: NSNotification.Name(rawValue: NavigationNotifications.toggleMenu), object: nil, queue: nil, using: { (notification) in
            self.toggleMenu()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func overlayClicked(sender:UIButton){
        animateSidePanel(expand: false)
    }
    
    func toggleMenu() {
        if currentState == .mainVC{
            animateSidePanel(expand: true)
        }else{
            animateSidePanel(expand: false)
        }
    }
    
    let overlayFullOpacity:CGFloat = 0.5
    let fullShadowOpacity:Float = 0.7
    let sidePanelAnimationDuration = 0.3
    func animateSidePanel(expand:Bool){
        if expand{
            UIView.animate(withDuration: sidePanelAnimationDuration, delay: 0.0, options: .curveEaseOut, animations: {
                self.leftPanelController.view.frame = CGRect(x:0, y: 0, width: self.leftPanelController.view.frame.width, height: self.leftPanelController.view.frame.height)
                self.leftPanelController.view.layer.shadowOpacity = self.fullShadowOpacity
                self.containerOverlay.layer.opacity = Float(self.overlayFullOpacity)
                
            }, completion: nil)
            currentState = .leftPanelExpanded
            containerOverlay.isUserInteractionEnabled = true
        }else{
            UIView.animate(withDuration: sidePanelAnimationDuration, delay: 0.0, options: .curveEaseOut, animations: { 
                self.leftPanelController.view.frame = CGRect(x: -self.leftPanelController.view.frame.width, y: 0, width: self.leftPanelController.view.frame.width, height: self.leftPanelController.view.frame.height)
                self.leftPanelController.view.layer.shadowOpacity = 0.0
                self.containerOverlay.layer.opacity = 0.0
            }, completion: nil)
            currentState = .mainVC
            containerOverlay.isUserInteractionEnabled = false
        }
    }
    
    func addLeftPanelViewController() {
        leftPanelController = UIStoryboard(name: "Navigation", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeftPanelViewController") as! SidePanelViewController
        leftPanelController.view.frame = CGRect(x: -leftPanelWidth, y: 0, width:leftPanelWidth, height: self.view.frame.height)
        view.addSubview(leftPanelController.view)
        leftPanelController.didMove(toParentViewController: self)
        leftPanelController.view.layoutIfNeeded()
        
    }
    
}

extension ContainerViewController: UIGestureRecognizerDelegate{
    //MARK: - Gesture recognizer
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer){
        let gestureIsDraggingFromLeftToRight = recognizer.velocity(in: view).x > 0
        
        switch recognizer.state {
        case .began:
            print("Began sliding VC")
        case .changed:
            let translation = recognizer.translation(in: view).x
            if translation + leftPanelController.view.frame.origin.x < 0 && translation + leftPanelController.view.frame.origin.x > -leftPanelController.view.frame.width{
                leftPanelController.view?.center.x = leftPanelController.view!.center.x + translation
            }
            containerOverlay.layer.opacity = Float((leftPanelController.view.frame.origin.x + leftPanelController.view.frame.width) / leftPanelController.view.frame.width * overlayFullOpacity)
            leftPanelController.view.layer.shadowOpacity = Float(Float(leftPanelController.view.frame.origin.x + leftPanelController.view.frame.width) / Float(leftPanelController.view.frame.width) * fullShadowOpacity)
            recognizer.setTranslation(CGPoint.zero, in: view)
        case .ended:
            if leftPanelController.view.center.x > 0{
                if recognizer.velocity(in: view).x < -100{
                    animateSidePanel(expand: false)
                }else{
                    animateSidePanel(expand: true)
                }
            }else{
                animateSidePanel(expand: false)
            }
        default:
            break
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if currentState != .mainVC {
            return true
        }
        if touch.location(in: self.view).x < self.view.frame.width / 3{
            return true
        }else {
            return false
        }
    }
}
