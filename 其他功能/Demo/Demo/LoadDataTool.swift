//
//  LoadDataTool.swift
//  yifanjie
//
//  Created by i-Techsys.com on 2017/7/18.
//  Copyright © 2017年 hsiao. All rights reserved.
//

import UIKit

class LoadDataTool {
    static func loadAreaData() -> [Area] {
        let path = Bundle.main.path(forResource: "area", ofType: "json")
        let data: Data = NSData(contentsOfFile: path!)! as Data
        guard let rootArr = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else { return []}
        var tempArr: [Area] = [Area]()
        for dict in rootArr! {
            tempArr.append(Area(dict: dict))
        }
        return tempArr
    }
}

class Area: BaseModel {
    var area_id: String = ""
    var title: String = ""
    var pid: String = ""
    var sort: String = ""
    var son: [City]!
    
    override func setValue(_ value: Any?, forKey key: String) {
        // 1.判断当前取出的key是否是Area
        if key == "son" {
            // 如果是Area就交给下一级的model去处理
            var models = [City]()
            for dict in value as! [[String: AnyObject]] {
                models.append(City(dict: dict))
            }
            son = models
            return
        }
        
        // 2.否则，父类初始化
        super.setValue(value, forKey: key)
    }
}

class City: BaseModel {
    var area_id:String = ""
    var title:String = ""
    var pid:String = ""
    var sort:String = ""
    var son:Int = 0
}

class BaseModel: NSObject {
    override init(){
        super.init()
    }
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
/**
 "area_id":"110000","title":"北京市","pid":"0","sort":"1","son":[{"area_id":"110100","title":"北京市","pid":"110000","sort":"1"},{"area_id":"110200","title":"县","pid":"110000","sort":"2"}]},{"area_id":"120000","title":"天津市","pid":"0","sort":"2",
 */
