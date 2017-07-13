//
//  MGCustomActivity.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/22.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

public typealias FinishedBlock = () -> Void

class MGCustomActivity: UIActivity {
    
    var title:String?
    var image:UIImage?
    var url:NSURL?
    
    var finishedBlock:FinishedBlock?

//    override init() {
//        super.init()
////        self.mg_GetMethodAndPropertiesFromClass(cls: UIActivity.classForCoder())
//    }
//
//    
//    override var activityImage: UIImage? {
//        return UIImage(named: "m_156_100")
//    }
//    
//    override var activityType: UIActivityType? {
//        return UIActivityType(rawValue: NSStringFromClass(self.classForCoder))
//    }
//    
//    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
//        return activityItems.count > 0 ? true : false
//    }
//    
//    override func prepare(withActivityItems activityItems: [Any]) {
//        super.prepare(withActivityItems: activityItems)
//        for activityItem in activityItems {
//            if let title = activityItem as? String {
//                self.title = title
//            } else if let image = activityItem as? UIImage {
//                self.image = image
//            } else if let url = activityItem as? NSURL {
//                self.url = url
//            }
//        }
//    }
    
    override func perform() {
        super.perform()
        if let block = self.finishedBlock {
            block()
        }
        
        self.activityDidFinish(true)
    }
}
