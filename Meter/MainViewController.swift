//
//  MainViewController.swift
//  Meter
//
//  Created by Avery Lamp on 5/21/17.
//  Copyright © 2017 Avery Lamp. All rights reserved.
//

import UIKit
import Parse

enum SpotDetailStatus {
    case visible
    case hidden
    case fullScreen
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var detailViewBottomConstraint: NSLayoutConstraint!
    var mapVC: MapViewController?
    var detailVC: DetailViewController?
    var spotDetailStatus: SpotDetailStatus = .hidden
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissDetailViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.panGestureMoved(recognizer:)))
        self.view.addGestureRecognizer(dismissDetailViewPanGesture)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapVC"{
            if let embededMapVC = segue.destination as? MapViewController{
                mapVC = embededMapVC
                mapVC?.delegate = self
            }
        }
        if segue.identifier == "DetailVC"{
            if let embededDetailVC = segue.destination as? DetailViewController{
                detailVC = embededDetailVC
                detailVC?.delegate = self
            }
        }
        
    }
    
    
}

extension MainViewController{
    func hideDetailVC(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.6) {
            self.detailViewBottomConstraint.constant = -300
            
            self.view.layoutIfNeeded()
        }
        self.spotDetailStatus = .hidden
    }
    
    func showDetailVC(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.6) {
            self.detailViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        self.spotDetailStatus = .visible
    }
    
    
}

extension MainViewController: UIGestureRecognizerDelegate{
    
    func panGestureMoved(recognizer: UIPanGestureRecognizer){
        print("Pan Gesture Moved \(recognizer.translation(in: self.view).y)")
        if recognizer.velocity(in: self.view).y > 500 && self.spotDetailStatus == .visible{
            self.hideDetailVC()
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return true
    }
    
}

extension MainViewController: MapDelegate{
    func pinClicked(spot: Spot) {
        if var allSpots = self.mapVC?.spotObjects{
            
                        allSpots.sort(by: { (spot1, spot2) -> Bool in
                            return (CLLocation(latitude: spot.coordinate.latitude, longitude: spot.coordinate.longitude)).distance(from: CLLocation(latitude: spot1.coordinate.latitude, longitude: spot1.coordinate.longitude)) < (CLLocation(latitude: spot.coordinate.latitude, longitude: spot.coordinate.longitude)).distance(from: CLLocation(latitude: spot2.coordinate.latitude, longitude: spot2.coordinate.longitude))
                        })
            var allPFSpots = [PFObject]()
            allSpots.forEach{
                if let pfobj  = $0.pfObject{
                    allPFSpots.append(pfobj)
                }
            }
            self.detailVC?.loadSpots(spots: allPFSpots)
        }
        
        if self.spotDetailStatus == .hidden{
            showDetailVC()
        }
    }
    
    func pinDeselected(spot: Spot) {
        
    }
}

extension MainViewController: DetailDelegate{
    func spotHighlighted(spot: PFObject) {
        if let mapVC = mapVC{
            mapVC.highlightSpot(spot: spot)
        }
    }
    
    
}
