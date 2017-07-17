//
//  SBTools.swift
//  indexView
//
//  Created by i-Techsys.com on 2017/7/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class SBTools: NSObject {
    class func loadControllerFromSB<T>(_ SBName: String) -> T {
        return UIStoryboard(name: SBName, bundle: nil).instantiateInitialViewController() as! T
    }
    
    class func loadControllerFromSBWithID<T>(_ SBName: String,_ SBId: String) -> T {
        return UIStoryboard(name: SBName, bundle: nil).instantiateViewController(withIdentifier: SBId) as! T
    }
}
