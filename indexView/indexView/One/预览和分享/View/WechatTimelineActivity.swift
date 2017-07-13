//
//  WechatTimelineActivity.swift
//  UIActivityViewControllerDemo
//
//  Created by Shaolie on 15/10/3.
//  Copyright © 2015年 LinShaoLie. All rights reserved.
//

import UIKit

class WechatTimelineActivity: MGCustomActivity {
    override var activityTitle: String? {
        return "微信朋友圈"
    }
    
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "wechat_timeline")
//        return UIImage(named: "wechat_timeline")
    }
}
