//
//  WechatSessionActivity.swift
//  UIActivityViewControllerDemo
//
//  Created by Shaolie on 15/10/3.
//  Copyright © 2015年 LinShaoLie. All rights reserved.
//

import UIKit

class WechatSessionActivity: MGCustomActivity {
    override var activityTitle: String? {
        return "微信朋友"
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: "wechat_session")
    }
    
    
    override func perform() {
        super.perform()
        if let block = self.finishedBlock {
            block()
        }
        
        self.activityDidFinish(true)
        
    }

}
