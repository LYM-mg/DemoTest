//
//  CopyLinkActivity.swift
//  UIActivityViewControllerDemo
//
//  Created by Shaolie on 15/10/1.
//  Copyright © 2015年 LinShaoLie. All rights reserved.
//

import UIKit

enum MGActivityCategory {
    case  Action, Share
}


class CopyLinkActivity: MGCustomActivity {
//    override class var activityCategory: UIActivityCategory?  {
//        didSet {
//            
//        }
//    }
//    override class func activityCategory() -> UIActivityCategory{
//        return UIActivityCategory.action
//    }
    
    //按钮类型（分享按钮：在第一行，彩色，动作按钮：在第二行，黑白）
    override init() {
        super.init()
    }
    
    override var activityTitle: String? {
        return "拷贝链接"
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: "share_link")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        super.prepare(withActivityItems: activityItems)
        //因为是拷贝链接，所有如果不存在NSURL对象，则返回false
        for item in activityItems {
            if let _ = item as? NSURL {
                return true
            }
        }
        return false
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        //拷贝需要的链接
        //...
        print("copy link to pasteboard");
        self.activityDidFinish(true)
    }
}
