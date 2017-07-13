//
//  XJLGroupModel.swift
//  OccupationClassify
//
//  Created by i-Techsys.com on 17/3/27.
//  Copyright © 2017年 MESMKEE. All rights reserved.
//

import UIKit

class XJLGroupModel: NSObject {
    var group: [Any]!  {
        didSet {
            for model in group {
                models.append(XJLModel(dict: model as! [String: Any]))
            }
        }
    }
    
    var models:[XJLModel] = [XJLModel]()
    var isExpaned: Bool = false
    
    override init() {
        
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
