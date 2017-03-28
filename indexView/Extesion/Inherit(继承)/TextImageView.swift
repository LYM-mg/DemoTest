//
//  TextImageView.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 17/2/24.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class TextImageView: UIView {
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.white
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    
    var title: String? {
        didSet{
            titleLabel.text = title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(titleLabel)

        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        
        let colorArr = [UIColor(r: 200, g: 66,  b: 55).withAlphaComponent(0.8),
                        UIColor(r: 97,  g: 91,  b: 175).withAlphaComponent(0.8),
                        UIColor(r: 226, g: 150, b: 46).withAlphaComponent(0.8),
                        UIColor(r: 38,  g:176,  b: 124).withAlphaComponent(0.8),
                        UIColor(r: 254, g:176,  b: 38).withAlphaComponent(0.8),
                        UIColor(r: 69,  g: 105, b: 181).withAlphaComponent(0.8),
                        UIColor(r: 22,  g: 169, b: 134),
                        UIColor(r: 130, g:152,  b: 178),
                        UIColor(r: 121, g:208,  b: 249),
                        UIColor(r: 231, g:233,  b: 209)]
        let color = colorArr[Int(arc4random_uniform(UInt32(colorArr.count)))]
        self.backgroundColor = color
        titleLabel.backgroundColor = self.backgroundColor!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = self.bounds
    }
    
    
    // 绘制的代码放在drawRect中去
//    override func draw(_ rect: CGRect) {
//        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.size.height/2)
        // 4.关闭路径
//        color.setFill()
//        path.close()
//        path.fill()
//        var dict = [String: Any]()
//        dict[NSFontAttributeName] = 18
//        dict[NSForegroundColorAttributeName] = UIColor.white
//        
//        
//        let str = "dsa"
//        let label = UILabel()
//        label.text = "D"
//        label.center = CGPoint(x: rect.size.width/2, y: rect.size.height/2)
//        str.draw(at: CGPoint(x: rect.size.width/2, y: rect.size.height/2), withAttributes: nil)
//    }

}


