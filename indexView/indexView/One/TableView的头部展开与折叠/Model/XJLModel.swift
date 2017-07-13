//
//  XJLModel.swift
//  OccupationClassify
//
//  Created by i-Techsys.com on 17/3/27.
//  Copyright © 2017年 MESMKEE. All rights reserved.
//

import UIKit

class XJLModel: NSObject {
    
    var create_time : String!
    var iid : String!
    var industry_name : String!
    var name : String!
    var oid : String!
    

    override init() {
        
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
