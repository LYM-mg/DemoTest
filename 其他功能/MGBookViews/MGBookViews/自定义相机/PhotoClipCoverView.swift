//
//  PhotoClipCoverView.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/27.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class PhotoClipCoverView: UIView {
    /** 裁剪框frame */
    public var showRect = CGRect.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx: CGContext = UIGraphicsGetCurrentContext() else  { return }
        // 整体颜色
        ctx.setFillColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.6)
        ctx.fill(rect)
        //draw the transparent layer
        //中间清空矩形框
        let clearDrawRect: CGRect = showRect
        ctx.clear(clearDrawRect)
        //边框
        ctx.stroke(clearDrawRect)
        ctx.setStrokeColor(red: 1, green: 1, blue: 1, alpha: 1)
        //颜色
        ctx.setLineWidth(0.5)
        //线宽
        ctx.addRect(clearDrawRect)
        //矩形
        ctx.strokePath()
    }
}
