//
//  MGCarGroup.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/13.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGCarGroup: NSObject {
    /**
     *  这组的标题
     */
    var title: String!
    /**
     *  存放的所有的汽车品牌(里面装的都是MJCar模型)
     */
    var cars: [[String : NSObject]]? {
        didSet {
            guard let cars = cars else { return }
            for dict in cars {
                carArrs.append(MGCar(dict: dict))
            }
        }
    }
    lazy var carArrs: [MGCar] = [MGCar]()
    
    override init() {
        
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
