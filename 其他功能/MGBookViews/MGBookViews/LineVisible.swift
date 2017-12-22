//
//  LineVisible.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/22.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

public enum Position {
    case top
    case bottom
    case left
    case right
}

//MARK: - view加线 Protocol
public protocol LineVisible : class {
    
    var lineColor: UIColor { get set }
    
    var lineHeight: CGFloat { get set }
    var lineWidth: CGFloat { get set }
    
    func addLineTo(view: UIView,position: Position?, edge: UIEdgeInsets?)
    
    func deleteLineTo(view: UIView)
}


extension LineVisible{
    // 添加下划线
    public func addLineTo(view:UIView, position: Position? = .bottom,edge:UIEdgeInsets? = .zero){
        
        let lineEdge = edge ?? UIEdgeInsets.zero
        let position = position ?? .bottom
        
        let lineView = UIView()
        lineView.tag = 135792
        lineView.backgroundColor = lineColor
        view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        switch position {
            case .bottom:
                let leftCon = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: lineEdge.left)
                let rightCon = NSLayoutConstraint(item: lineView, attribute: .right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .right, multiplier: 1.0, constant: lineEdge.right)
                let bottomCon = NSLayoutConstraint(item: lineView, attribute: .bottom, relatedBy: .equal
                    , toItem: view, attribute: .bottom, multiplier: 1.0, constant: lineEdge.bottom)
                let heightCon = NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: lineHeight)
                view.addConstraints([leftCon,rightCon,bottomCon,heightCon])
            case .top:
                let leftCon = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: lineEdge.left)
                let rightCon = NSLayoutConstraint(item: lineView, attribute: .right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .right, multiplier: 1.0, constant: lineEdge.right)
                let topCon = NSLayoutConstraint(item: lineView, attribute: .bottom, relatedBy: .equal
                    , toItem: view, attribute: .top, multiplier: 1.0, constant: lineEdge.top)
                let heightCon = NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: lineHeight)
                view.addConstraints([leftCon,rightCon,topCon,heightCon])
            case .left:
                let leftCon = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: lineEdge.left)
                let topCon = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: lineEdge.top)
                let bottomCon = NSLayoutConstraint(item: lineView, attribute: .bottom, relatedBy: .equal
                    , toItem: view, attribute: .bottom, multiplier: 1.0, constant: lineEdge.bottom)
                let widthCon = NSLayoutConstraint(item: lineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: lineWidth)
                    view.addConstraints([leftCon,bottomCon,topCon,widthCon])
            case .right:
                let rightCon = NSLayoutConstraint(item: lineView, attribute: .right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .right, multiplier: 1.0, constant: lineEdge.right)
                let topCon = NSLayoutConstraint(item: lineView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: lineEdge.top)
                let bottomCon = NSLayoutConstraint(item: lineView, attribute: .bottom, relatedBy: .equal
                    , toItem: view, attribute: .bottom, multiplier: 1.0, constant: lineEdge.bottom)
                let widthCon = NSLayoutConstraint(item: lineView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: lineWidth)
                view.addConstraints([bottomCon,rightCon,topCon,widthCon])
        }
        
        
        // 使用框架布局
//        switch position {
//            case .bottom:
//                lineView.snp.makeConstraints { (make) in
//                    make.left.equalTo(view).offset(lineEdge.left)
//                    make.right.equalTo(view).offset(lineEdge.right)
//                    make.bottom.equalTo(view).offset(lineEdge.bottom)
//                    make.height.equalTo(lineHeight)
//                }
//            case .top:
//                lineView.snp.makeConstraints { (make) in
//                    make.left.equalTo(view).offset(lineEdge.left)
//                    make.right.equalTo(view).offset(lineEdge.right)
//                    make.top.equalTo(view).offset(lineEdge.top)
//                    make.height.equalTo(lineHeight)
//                }
//            case .left:
//                lineView.snp.makeConstraints { (make) in
//                    make.left.equalTo(view).offset(lineEdge.left)
//                    make.bottom.equalTo(view).offset(lineEdge.bottom)
//                    make.top.equalTo(view).offset(lineEdge.top)
//                    make.width.equalTo(lineWidth)
//                }
//            case .right:
//                lineView.snp.makeConstraints { (make) in
//                    make.right.equalTo(view).offset(lineEdge.right)
//                    make.bottom.equalTo(view).offset(lineEdge.bottom)
//                    make.top.equalTo(view).offset(lineEdge.top)
//                    make.width.equalTo(lineWidth)
//                }
//        }
    }
    
    // 删除下划线
    public func deleteLineTo(view:UIView){
        if let subView = view.viewWithTag(135792) {
            subView.removeFromSuperview()
        }
    }
}


