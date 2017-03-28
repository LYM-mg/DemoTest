//
//  SqitView.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 17/2/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class SqitView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor(r: 220, g: 220, b: 220).cgColor)
        context.setLineWidth(1)
        let lengths: [CGFloat] = [3, 3]
        context.setLineDash(phase: 0, lengths: lengths)
        //画虚线
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: rect.size.height - 1))
        //开始画线
        context.addLine(to: CGPoint(x: MGScreenW - 10, y: rect.size.height - 1))
        context.strokePath()
    }

}
