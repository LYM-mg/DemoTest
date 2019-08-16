//
//  AppDelegate.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/13.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 9.0, *) {
            setUp3Dtouch(application)
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// MARK: - 3D touch
extension AppDelegate {
    fileprivate func setUp3Dtouch(_ application: UIApplication) {
        // 创建一个应用程序快捷方式项
        if #available(iOS 9.0, *) {
            let shareItem = UIMutableApplicationShortcutItem(type: "share", localizedTitle: "分享", localizedSubtitle: "分享自己的运用", icon: UIApplicationShortcutIcon.init(templateImageName: "share_gray"), userInfo: nil)
            application.shortcutItems = [shareItem]
        }
    }
    
    
    
    @available(iOS 9.0, *)
    @objc(application:performActionForShortcutItem:completionHandler:) func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let isHandledShortItem = handleShortCutItem(shortcutItem)
        completionHandler(isHandledShortItem)
    }
    
    @available(iOS 9.0, *)
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool  {
        var isHandled = false
        if shortcutItem.type == "share" {
            let image = #imageLiteral(resourceName: "ming")
            let str = "hi! I'm MG, welcome to my world, this is my book written by Jane, if feel good, please feel free to call"
            let url = NSURL(string: "http://www.jianshu.com/u/57b58a39b70e")
            let items:[Any] = [image, str, url!]
            
            let activity = UIActivityViewController(activityItems: items, applicationActivities: [MGCustomActivity(),WeiboActivity(),WechatSessionActivity(),WechatTimelineActivity(),CopyLinkActivity()])
            // .copyToPasteboard,.copyToPasteboard,.message,.print,UIActivityType.airDrop,,.postToWeibo,.postToVimeo,.postToTencentWeibo,.mail,.assignToContact,.postToFacebook,.openInIBooks,.postToTwitter
            // 不出现在活动项目
            activity.excludedActivityTypes = [.addToReadingList]
            
            let popver: UIPopoverPresentationController? = activity.popoverPresentationController
            if (popver != nil) {
                popver!.permittedArrowDirections = UIPopoverArrowDirection.left
            }
            UIApplication.shared.keyWindow?.rootViewController?.present(activity, animated: true, completion: nil)
            
            activity.completionWithItemsHandler = { (type, completed, result, err)  in
                if completed {
                    
                }
                activity.completionWithItemsHandler = nil
            }
            isHandled = true
        }
        
        return isHandled
    }
}

