//
//  MGCar.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/13.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGCar: NSObject {
    
    /**
     *  图标
     */
    var icon: String!
    /**
     *  名称
     */
    var name: String!
    
    override init() {
        
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
