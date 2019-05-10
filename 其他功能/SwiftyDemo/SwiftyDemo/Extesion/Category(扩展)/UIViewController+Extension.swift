//
//  UIViewController+Extension.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/30.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

private let mainScreenW = UIScreen.main.bounds.size.width
private let mainScreenH = UIScreen.main.bounds.size.height

// MARK: - HUD
extension UIViewController {
    // MARK:- RuntimeKey   动态绑属性
    // 改进写法【推荐】
    struct RuntimeKey {
        static let mg_HUDKey = UnsafeRawPointer.init(bitPattern: "mg_HUDKey".hashValue)!
        static let mg_GIFKey = UnsafeRawPointer(bitPattern: "mg_GIFKey".hashValue)!
        static let mg_GIFWebView = UnsafeRawPointer(bitPattern: "mg_GIFWebView".hashValue)!
        /// ...其他Key声明
    }
}

extension UIViewController {
    class func currentViewController() -> UIViewController? {
        // Find best view controller
        let viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        return UIViewController.findBestViewController(viewController)

    }

    class func findBestViewController(_ vc: UIViewController?) -> UIViewController? {
        if vc?.presentedViewController != nil {
            // Return presented view controller
            return UIViewController.findBestViewController(vc?.presentedViewController)
        } else if (vc is UISplitViewController) {
            // Return right hand side
            let svc = vc as? UISplitViewController
            if (svc?.viewControllers.count ?? 0) > 0 {
                return UIViewController.findBestViewController(svc?.viewControllers.last)
            } else {
                return vc
            }
        } else if (vc is UINavigationController) {
            // Return top view
            let svc = vc as? UINavigationController
            if (svc?.viewControllers.count ?? 0) > 0 {
                return UIViewController.findBestViewController(svc?.topViewController)
            } else {
                return vc
            }
        } else if (vc is UITabBarController) {
            // Return visible view
            let svc = vc as? UITabBarController
            if (svc?.viewControllers?.count ?? 0) > 0 {
                return UIViewController.findBestViewController(svc?.selectedViewController)
            } else {
                return vc
            }
        } else {
            // Unknown view controller type, return last child view controller
            return vc
        }
    }
}



/// MARk: - 返回到指定控制器
extension UIViewController {
    /**
     *  导航栏回到指定控制器
     *  className：控制器名字（字符串）
     *  animated：是否带动画
     */
    func back(toController className: String!, animated: Bool) {
        guard let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return
        }
        let classStringName = appName + "." + className
        guard  let cls:AnyClass = NSClassFromString(classStringName) else {
            return;
        }

        self.back(toControllerClass: cls, animated: animated)
    }

    /**
     *  导航栏回到指定控制器
     *  cls：控制器类名）
     *  animated：是否带动画
     */
    func back(toControllerClass cls: AnyClass, animated: Bool) {
        if navigationController != nil, let childViewControllers = navigationController?.children {
            let resluts = childViewControllers.filter { return $0.isKind(of: cls) }
            if resluts.count>0,let firstObject = resluts.first {
                navigationController!.popToViewController(firstObject, animated: animated)
            }
        }
    }
}

    
