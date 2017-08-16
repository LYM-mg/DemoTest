//
//  MGTableViewController.swift
//  Demo
//
//  Created by i-Techsys.com on 2017/8/11.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGTableViewController: UITableViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    var str: Void?
    deinit {
        defer {
        }
        
            removeObserver(self, forKeyPath: NSStringFromSelector(#selector(setter: self.pad_state)), context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.pad_motionManager = (UIApplication.shared.delegate as? AppDelegate)?.shareMotionManager
        
        addObserver(self, forKeyPath: NSStringFromSelector(#selector(setter: self.pad_state)), options: .new, context: nil)
        
        enableLongPressGestureRecognizer()
    }
    
    // MARK: - KVO
   fileprivate func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [String : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == NSStringFromSelector(#selector(setter: self.pad_state))) {
            updateUserInterface(forState: self.pad_state)
        }
    }
    
    // MARK: - Private
    fileprivate func updateUserInterface(forState state: Int) {
        if state == PADTiltViewControllerState.inactive.rawValue {
            UIApplication.shared.statusBarStyle = .default
            navigationController?.navigationBar.barTintColor = nil
            titleLabel?.text = NSLocalizedString("Sensors Off", comment: "")
            titleLabel?.textColor = UIColor.black
            subTitleLabel.text = NSLocalizedString("Long press the content to enable sensors", comment: "")
            subTitleLabel.textColor = UIColor.black
            UIView.animate(withDuration: 0.35, animations: {() -> Void in
                self.tabBarController?.tabBar.alpha = 1.0
            })
        }else if state == PADTiltViewControllerState.initializing.rawValue || state == PADTiltViewControllerState.calibrating.rawValue {
            UIApplication.shared.statusBarStyle = .lightContent
            navigationController?.navigationBar.barTintColor = UIColor.lightGray
            titleLabel?.text = NSLocalizedString("Calibrating Sensors", comment: "")
            titleLabel?.textColor = UIColor.white
            subTitleLabel.text = NSLocalizedString("Hold still for a moment", comment: "")
            subTitleLabel.textColor = UIColor.white
            UIView.animate(withDuration: 0.35, animations: {() -> Void in
                self.tabBarController?.tabBar.alpha = 0.0
            })
        }else  if state == PADTiltViewControllerState.active.rawValue {
            UIApplication.shared.statusBarStyle = .lightContent
            navigationController?.navigationBar.barTintColor = UIColor.lightGray
            titleLabel?.text = NSLocalizedString("Sensors On", comment: "")
            titleLabel?.textColor = UIColor.white
            subTitleLabel.text = NSLocalizedString("Tap or swipe the content to disable sensors", comment: "")
            subTitleLabel.textColor = UIColor.white
        }
    }
    
    // MARK: - enable
    fileprivate func enableLongPressGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.startReceivingTiltUpdates1(_:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
    }

    func enableLongPressTapAndSwipeGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.stopReceivingTiltUpdates1(_:)))
        view.addGestureRecognizer(longPressGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.stopReceivingTiltUpdates1(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.stopReceivingTiltUpdates1(_:)))
        swipeGestureRecognizer.delegate = self
        swipeGestureRecognizer.direction = [.up, .down]
        view.addGestureRecognizer(swipeGestureRecognizer)
    }


    fileprivate func removeGestureRecognizers() {
        for gestureRecognizer: UIGestureRecognizer in view.gestureRecognizers! {
            if (gestureRecognizer is UILongPressGestureRecognizer) || (gestureRecognizer is UITapGestureRecognizer) || (gestureRecognizer is UISwipeGestureRecognizer) {
                view.removeGestureRecognizer(gestureRecognizer)
            }
        }
    }
    

    // MARK: - action
    fileprivate func startReceivingTiltUpdates() {
        pad_startReceivingTiltUpdates()
        removeGestureRecognizers()
        enableLongPressTapAndSwipeGestureRecognizer()
    }
    @objc fileprivate func startReceivingTiltUpdates1(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            startReceivingTiltUpdates()
        }
    }
    
    fileprivate func stopReceivingTiltUpdates() {
        pad_stopReceivingTiltUpdates()
        removeGestureRecognizers()
        enableLongPressGestureRecognizer()
    }
    @objc fileprivate func stopReceivingTiltUpdates1(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .ended {
            stopReceivingTiltUpdates()
        }
    }

    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = "笨蛋傻瓜\(indexPath.row)😚"

        return cell
    }
    
}
