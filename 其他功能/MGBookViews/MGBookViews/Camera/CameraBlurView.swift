//
//  CameraBlurView.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/28.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import SnapKit

class CameraBlurView: UIView {
    @IBOutlet weak var tipLabel1: UILabel!
    
    @IBOutlet weak var takePhotoView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tipLabel2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        tipLabel1.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        tipLabel2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))

        let str: NSString = "请保持人像面朝上"
        let range = str.range(of: "人像面朝上")
        let attr2 = NSMutableAttributedString(string: str as String)
        attr2.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorHex(hex: "#FA5532"), range: range)
//        attr2.addAttribute(NSVerticalGlyphFormAttributeName, value: 1, range: NSRange(location: 0, length: 6))
        tipLabel2.attributedText = attr2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipLabel1.x = takePhotoView.x-15-tipLabel1.width
        tipLabel1.center.y = takePhotoView.center.y
        tipLabel2.x = takePhotoView.frame.maxX+15
        tipLabel2.center.y = takePhotoView.center.y
//        tipLabel1.snp.makeConstraints { (make) in
//            make.centerY.equalTo(takePhotoView.snp.centerY)
//            make.right.equalTo(takePhotoView.snp.left).offset(-15)
//        }
//        tipLabel2.snp.makeConstraints { (make) in
//            make.centerY.equalTo(takePhotoView.snp.centerY)
//            make.left.equalTo(takePhotoView.snp.right).offset(15)
//        }
    }

}

extension UIView {
    
}

@IBDesignable class VertricalLabel: UILabel {
    @IBInspectable var angle: CGFloat {
        get{
            return super.transform.a
        } set {
            self.transform = CGAffineTransform(rotationAngle:  CGFloat(Double.pi)/angle)
        }
    }
    
    /**
     * 值为整型NSNumber，0为水平排版的字，1为垂直排版的字。注意,在iOS中, 总是以横向排版
     *
     * In iOS, horizontal text is always used and specifying a different value is undefined.
     */
//    @IBInspectable var vertical: String {
//        get{
//            return super.attributedText as String
//        } set {

//        }
//    }
    
}
