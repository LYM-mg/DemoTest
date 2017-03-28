//
//  WeiboActivity.swift
//  UIActivityViewControllerDemo
//
//  Created by Shaolie on 15/10/1.
//  Copyright © 2015年 LinShaoLie. All rights reserved.
//

import UIKit

class WeiboActivity: MGCustomActivity {
    override init() {
        super.init()
    }
    
    override var activityTitle: String? {
        return "新浪微博"
    }
    
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "weibo")
//        return UIImage(named: "weibo")
    }
    
    override func perform() {
        super.perform()
        //将需要分享的数据通过微博SDK进行
        // 分享
        //...
        print("share to weibo");
        self.activityDidFinish(true)
    }
}
