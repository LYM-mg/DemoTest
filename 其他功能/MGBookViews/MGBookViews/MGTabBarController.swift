//
//  MGTabBarController.swift
//  MGDYZB
//
//  Created by ming on 16/10/25.
//  Copyright © 2016年 ming. All rights reserved.

//  简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
//  github:  https://github.com/LYM-mg
//

import UIKit

class MGTabBarController: UITabBarController {

    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarAppear = UITabBarItem.appearance()
        tabBarAppear.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: UIControlState.selected)
        
        setUpAllChildViewControllers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - setUpAllChildViewControllers
    fileprivate func setUpAllChildViewControllers () {
        let normalImages = ["tabbar_home","tabbar_discover","tabbar_message_center","tabbar_profile"]
        let selectedImages = ["tabbar_home_highlighted","tabbar_discover_highlighted","tabbar_message_center_highlighted","tabbar_profile_highlighted"]

        
        let newsVC = UIViewController()
        setUpNavRootViewCOntrollers(vc: newsVC, title: "首页", imageName: normalImages[0], selImage: selectedImages[0])
        
        let circleVC = UIViewController()
        setUpNavRootViewCOntrollers(vc: circleVC, title: "资讯", imageName: normalImages[1], selImage: selectedImages[1])
        
        let garageVC = UIViewController()
        setUpNavRootViewCOntrollers(vc: garageVC, title: "关注", imageName: normalImages[2], selImage: selectedImages[2])
        
        let profileVC = ViewController()
        setUpNavRootViewCOntrollers(vc: profileVC, title: "我的", imageName: normalImages[3], selImage: selectedImages[3])
    }
    
    
    fileprivate func setUpNavRootViewCOntrollers(vc: UIViewController, title:String, imageName: String, selImage: String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: selImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        self.addChildViewController(BaseNavigationController(rootViewController: vc))
    }

}
