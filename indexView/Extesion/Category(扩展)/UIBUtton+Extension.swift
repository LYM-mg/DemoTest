//
//  UIBUtton+Extension.swift
//  chart2
//
//  Created by i-Techsys.com on 16/12/7.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

extension UIButton {
    /// 遍历构造函数
    convenience init(imageName:String?, bgImageName:String?){
        self.init()
        
        // 1.设置按钮的属性
        // 1.1图片
        if let imageName = imageName {
            setImage(UIImage(named: imageName), for: .normal)
            setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        }
        
        // 1.2背@objc 景
        if let bgImageName = bgImageName {
            setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        }
        
        // 2.设置尺寸
        sizeToFit()
    }
    
    convenience init(imageName:String, target: Any, action:Selector) {
        self.init()
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), for: .normal)
        //      @objc   setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(image:UIImage,highlightedImage: UIImage?, target: Any, action:Selector) {
        self.init()
        // 1.设置按钮的属性
        setImage(image, for: .normal)
        if highlightedImage != nil {
            setImage(highlightedImage, for: .highlighted)
        }
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(title:String, target: Any, action:Selector) {
        self.init()
        setTitle(title, for: UIControl.State.normal)
        sizeToFit()
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(imageName:String, title: String, target: Any, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), for: .normal)
//        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setTitle(title, for: UIControl.State.normal)
        showsTouchWhenHighlighted = true
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }

    convenience init(image: UIImage, title: String, target:Any, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(image, for: .normal)
        //        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setTitle(title, for: UIControl.State.normal)
        setTitleColor(.white, for: .normal)
        setTitleColor(.lightGray, for: .highlighted)
        showsTouchWhenHighlighted = true
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, for: .touchUpInside)
    }
}
