//
//  UITableView+Extension.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 17/3/13.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class ProductTableView: UITableView {
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.next?.touchesBegan(touches, with: event)
//        super.touchesBegan(touches, with: event)
//    }
//    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.next?.touchesMoved(touches, with: event)
//        super.touchesMoved(touches, with: event)
//    }
//    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.next?.touchesEnded(touches, with: event)
//        super.touchesEnded(touches, with: event)
//    }
    
    fileprivate func _sectionIndexTouchesEnded(_: UIEvent) {
        print("dsadadsa")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.tipLetterlabel.isHidden = true
        }
    }
    
    fileprivate func endTrackingWithTouch(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("dsadadsa")
    }
    
    fileprivate func _sectionIndexTouchesMoved(_: UIEvent) {
        print("dsadadsa")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //            self.tipLetterlabel.isHidden = true
        }
    }
}
