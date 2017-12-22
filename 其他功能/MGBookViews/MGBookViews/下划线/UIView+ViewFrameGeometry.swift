//
//  UIView+ViewFrameGeometry.swift
//  SwiftTools
//
//  Created by Tassel on 2017/10/18.
//  Copyright © 2017年 Tassel. All rights reserved.
//

import UIKit

public extension UIView {

    // MARK:
    var x:CGFloat {
        
        set {
            var newFrame = self.frame
            newFrame.origin.x = _pixelIntergral(newValue)
            self.frame = newFrame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y:CGFloat {
        
        set {
            var newFrame = self.frame
            newFrame.origin.y = _pixelIntergral(newValue)
            self.frame = newFrame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var width:CGFloat {
        
        set {
            var newFrame = self.frame
            newFrame.size.width = _pixelIntergral(newValue)
            self.frame = newFrame
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height:CGFloat {
        
        set {
            var newFrame = self.frame
            newFrame.size.height = _pixelIntergral(newValue)
            self.frame = newFrame
        }
        get {
            return self.frame.size.height
        }
    }
    
    var top:CGFloat {
        
        set {

            var newFrame = self.frame
            newFrame.origin.y =  _pixelIntergral(newValue)
            self.frame = newFrame
        }
        
        get {
            
            return self.y
        }
    }
    var bottom:CGFloat {
        
        set {
            
            var newFrame = self.frame
            newFrame.origin.y =  _pixelIntergral(newValue) - self.height
            self.frame = newFrame
        }
        
        get {
            
            return self.y+self.height
        }
    }
    var left:CGFloat {
        
        set {
            
            var newFrame = self.frame
            newFrame.origin.x =  _pixelIntergral(newValue)
            self.frame = newFrame
        }
        
        get {
            
            return self.y
        }
    }
    var right:CGFloat {
        
        set {
            
            var newFrame = self.frame
            newFrame.origin.x =  _pixelIntergral(newValue) - self.width
            self.frame = newFrame
        }
        
        get {
            
            return self.x+self.width
        }
    }
    var origin:CGPoint {

        set {
            
            var newFrame = self.frame
            newFrame.origin = newValue
            self.frame = newFrame
        }
        
        get {
            
            return self.frame.origin
        }
    }
    
    var size:CGSize {
        
        set {
            
            var newFrame = self.frame
            newFrame.size = newValue
            self.frame = newFrame
        }
        
        get {
            return self.frame.size
        }
    }
    // MARK: - Private Methods
    fileprivate func _pixelIntergral(_ pointValue:CGFloat)->CGFloat {
        
        let scale = UIScreen.main.scale
        return (round(pointValue*scale)/scale)
    }
    
    /// 查找一个视图的所有子视图
    func allSubViewsForView(view: UIView) -> [UIView] {
        var array = [UIView]()
        for subView in view.subviews {
            array.append(subView)
            if (subView.subviews.count > 0) {
                // 递归
                let childView = self.allSubViewsForView(view: subView)
                array += childView
            }
        }
        return array
    }
}
