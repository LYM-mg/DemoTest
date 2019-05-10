//
//  MGModel.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/3.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit

class MGModel: NSObject {
    override init() {
        super.init()
    }

    func encode(with aCoder: NSCoder) {
        var methodCount: UInt32 = 0
        var ivarNum: UInt32 = 0
        let ivars = class_copyIvarList(MGModel.self, &ivarNum)
        for index in 0..<numericCast(ivarNum) {
            let ivar: objc_property_t = ivars![index]
            if let name:UnsafePointer<Int8> = ivar_getName(ivar) {
                debugPrint("ivar_name: \(String(cString: name))")
                // 归档
                if  let key = String(utf8String:name) {
                    let value = self.value(forKey: key)
                    aCoder.encode(value, forKey: key)
                }
            }
        }

        free(ivars)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        var ivarNum: UInt32 = 0
        let ivars = class_copyIvarList(MGModel.self, &ivarNum)
        for index in 0..<numericCast(ivarNum) {
            // 取出i位置对应的成员变量
            let ivar: Ivar = ivars![index]
            if let name:UnsafePointer<Int8> = ivar_getName(ivar) {
                debugPrint("ivar_name: \(String(cString: name))")
                // 归档
                if  let key = String(utf8String:name) {
                    let value = aDecoder.decodeObject(forKey: key)
                    // 设置到成员变量身上
                    if value != nil {
                        self.setValue(value, forKey: key)
                    }
                }
            }
        }

        free(ivars)
    }
}
private func ClassMethodNames(c: AnyClass) -> [Any]? {
    var array: [AnyHashable] = []

    var methodCount: UInt32 = 0
    let methodList = class_copyMethodList(c, &methodCount)
    guard let methodArray = methodList else {
        return array;
    }
    for i in 0..<methodCount {
        array.append(NSStringFromSelector(method_getName(methodArray[Int(i)])))
    }
    free(methodArray)

    return array
}
