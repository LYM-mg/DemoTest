//
//  MGWindow.swift
//  MGBookViews
//
//  Created by newunion on 2018/5/17.
//  Copyright © 2018年 i-Techsys. All rights reserved.
//

import UIKit

class MGWindow: UIWindow {
    static let topWindow_: MGWindow = MGWindow()
    static var dismiss: (()->())?
    /**
     *  显示顶部窗口
     */
    
    class func show(dismiss:@escaping ()->()) {
        MGWindow.dismiss = dismiss
        /*
         1.窗口级别越高，就越显示在顶部
         2.如果窗口级别一样，那么后面出来的窗口会显示在顶部
         UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
         */
        /// 1.创建顶部窗口

        topWindow_.windowLevel = UIWindowLevelStatusBar
        //    topWindow_.frame = CGRectMake(0, 0, BSScreenW, 200);
        //    topWindow_.alpha = 0.2;
        //    topWindow_.backgroundColor = [UIColor orangeColor];
        topWindow_.frame = UIScreen.main.bounds
        topWindow_.rootViewController = UIViewController()
        topWindow_.backgroundColor = UIColor.red
        topWindow_.isHidden = false
        // 只需要拉伸宽度即可  也拉伸高度的话就会出现问题(默认就是拉伸宽度和高度的)
        topWindow_.rootViewController?.view.autoresizingMask = .flexibleWidth
        topWindow_.rootViewController?.view.frame = CGRect(x: 0, y: 20, width: CGFloat(MGScreenW), height: MGScreenH-20)
        /// 2.添加点按手势
//        topWindow_.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.topWindowClick)))
    
//        let btn: UIButton = UIButton(frame: CGRect(x: 60, y: 300, width: 80, height: 50))
//        btn.backgroundColor = UIColor.purple
//        btn.setTitle("点我试试", for: .normal)
//        btn.addTarget(topWindow_, action: #selector(remove(_:)), for: .touchUpInside)
        topWindow_.rootViewController = UIViewController()
        var btn: UIButton? = topWindow_.viewWithTag(200) as? UIButton
        if (btn == nil) {
            btn = UIButton(frame: CGRect(x: 60, y: 300, width: 80, height: 50))
            btn!.tag = 200;
            btn!.setTitle("点我试试", for: .normal)
            btn!.addTarget(topWindow_, action: #selector(remove(_:)), for: .touchUpInside)
            topWindow_.addSubview(btn!)
        }
    }
    
    @objc fileprivate func remove(_ btn: UIButton) {
        MGWindow.topWindow_.isHidden = true;
        if ((MGWindow.dismiss) != nil) {
            MGWindow.dismiss!()
        }
    }
}
