//
//  UICollectionGridViewCellCollectionViewCell.swift
//  MGBookViews
//
//  Created by i-Techsys.com on 2017/11/15.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class UICollectionGridViewCell: UICollectionViewCell {
    
    //内容标签
    var label:UILabel!
    
    //箭头图标
    var imageView:UIImageView!
    
    //标签左边距
    var paddingLeft:CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        
        //添加内容标签
        self.label = UILabel(frame: .zero)
        self.label.textAlignment = .center
        self.addSubview(self.label)
        
        //添加箭头图标
        self.imageView = UIImageView(frame: .zero)
        self.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: paddingLeft, y: 0,
                             width: frame.width - paddingLeft * 2,
                             height: frame.height)
        
        let imageWidth: CGFloat = 14
        let imageHeight: CGFloat = 14
        imageView.frame = CGRect(x:frame.width - imageWidth,
                                 y:frame.height/2 - imageHeight/2,
                                 width:imageWidth, height:imageHeight)
    }
}

