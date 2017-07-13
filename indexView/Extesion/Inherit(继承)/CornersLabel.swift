//
//  CornersLabel.swift
//  chart2
//
//  Created by i-Techsys.com on 16/11/25.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

// MARK: - 圆角Label
class CornersLabel: UILabel {
//    override func draw(_ rect: CGRect) {
//        let pathRect = self.bounds.insetBy(dx: 1, dy: 1)
//        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 14)
//        path.lineWidth = 1
//        UIColor.white.setFill()
//        UIColor.blue.setStroke()
//        path.fill()
//        path.stroke()
//    }
}

extension CornersLabel {
    override open func draw(_ rect: CGRect) {
        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: 0, height: 8))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

}
