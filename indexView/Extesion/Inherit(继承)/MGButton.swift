//
//  MGButton.swift
//  MGWeibo
//
//  Created by ming on 16/1/8.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGButton: UIButton {
    
    /// 遍历构造函数
    convenience init(bgImageName:String){
        self.init()
        
        // 1.设置按钮的属性
        // 1.1图片
        // 1.2背景
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        
        // 2.设置尺寸
        sizeToFit()
    }
    
    convenience init(imageName:String, target: Any, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(imageName:String, title: String, target: Any, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), for: .normal)
//        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        setTitle(title, for: UIControlState.normal)
        imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        titleEdgeInsets  = UIEdgeInsetsMake(0, 5, 0, 0)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
}


