//  MGScrollView.swift
//  MGBookViews
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// https://github.com/LYM-mg
// http://www.jianshu.com/u/57b58a39b70e

import UIKit

class MGScrollView: UIScrollView {
    var offset: CGPoint = CGPoint.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 事件传递（这个在这里没有起到什么用。主要是了解下事件传递的原理）
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view: UIView? = super.hitTest(point, with: event)
        let hitHead: Bool = point.y < (MGHeadViewHeight - offset.y)
        if hitHead || (view == nil) {
            isScrollEnabled = false
            if view == nil {
                for subView: UIView in subviews {
                    if subView.frame.origin.x == contentOffset.x {
                        view = subView
                    }
                }
            }
            return view!
        }else {
            isScrollEnabled = true
            return view!
        }
    }
}
