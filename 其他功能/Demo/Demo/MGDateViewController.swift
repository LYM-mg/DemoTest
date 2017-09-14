//  MGDateViewController.swift
//  Demo
//  Created by i-Techsys.com on 2017/9/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// https://github.com/LYM-mg
// http://www.jianshu.com/u/57b58a39b70e

import UIKit
import Alamofire
import SwiftyJSON

let MGScreenW      = UIScreen.main.bounds.size.width
let MGScreenH      = UIScreen.main.bounds.size.height

class MGDateViewController: UIViewController {
    
    fileprivate lazy var redV: UIView = {
        let redV = UIView(frame: CGRect(x: 0, y: 100, width: 20, height: 10))
        redV.backgroundColor = UIColor.red
        return redV
    }()
    
    fileprivate lazy var yellowV: UIView = {
        let yellowV = UIView(frame: CGRect(x: 0, y: 110, width: 0, height: 2))
        yellowV.backgroundColor = UIColor.yellow
        return yellowV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let second = DateTool.desStr(serviceStr: "2017-09-06 19:28:01")
        
        self.view.addSubview(redV)
        self.view.addSubview(yellowV)

        print(second)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let base = CABasicAnimation(keyPath: "position.x")
        base.fromValue = 0
        base.toValue = MGScreenW*0.85
        base.duration = 0.8
        base.repeatCount = 1
        base.isRemovedOnCompletion = false
        base.fillMode = kCAFillModeForwards
        redV.layer.add(base, forKey: "positionX")
        
        UIView.animate(withDuration: 0.8) { 
            self.yellowV.frame.size.width = MGScreenW*0.85
        }
        
        self.perform(#selector(shache), with: nil, afterDelay: base.duration)
    }
    
    func shache() {
        UIView.animate(withDuration: 0.2) { 
            self.redV.layer.anchorPoint = CGPoint(x: 1, y: 1)
            self.redV.layer.transform = CATransform3DMakeRotation(20, 0, 0, 1)
        }
        
//        let rotate = CABasicAnimation(keyPath: "transform.rotation")
//        rotate.fromValue = 20
//        rotate.toValue = 0
//        rotate.isRemovedOnCompletion = false
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.redV.layer.transform = CATransform3DIdentity
            self.yellowV.frame.size.width = MGScreenW
        }, completion: nil)
        
        let base = CABasicAnimation(keyPath: "position.x")
        base.fromValue = MGScreenW*0.85
        base.toValue = MGScreenW
        base.duration = 1.0
        base.isRemovedOnCompletion = false
        base.fillMode = kCAFillModeForwards
        base.repeatCount = 1

        
       redV.layer.add(base, forKey: "group")
    }
    
    
    func test() {
        NetWorkTools.requestData(type: .get, urlString: "http://www.youdianbus.cn/ydbus-api/api/order/list_order_storage_item?date=2017-09&dev_id=D781FAF8-C667-4FBA-B2FE-49E9B21F28C4&t_flag=true&token=a43acba1c90752f93e51f64364b71d9c&user_id=7c19f276d626928a611e0f58eeaddc09", succeed: { (res, err) in
            let json = JSON(res)
            let data = json["data"]
            let arr = data["orderStorageItemList"].arrayValue
            for a in arr {
                let di = a["line"]
                print(di)
            }
        }) { (err) in
            
        }
    }
    var  dataArr: [Any] = [
        ["hour":"0小时","Minutes":[["one":"10分钟","two":"20分钟","three":"30分钟","four":"40分钟","five":"50分钟"]]],
        ["hour":"1小时","Minutes":[["one":"10分钟","two":"20分钟","three":"30分钟","four":"40分钟","five":"50分钟"]]],
        ["hour":"2小时","Minutes":[["one":"10分钟","two":"20分钟","three":"30分钟","four":"40分钟","five":"50分钟"]]],
        ["hour":"4小时","Minutes":[["one":"10分钟","two":"20分钟","three":"30分钟","four":"40分钟","five":"50分钟"]]]
    ]
    
}

class DateTool {
    /**
     *   根据字符串转换时间
     *   获取当前时间的格式
     *   返回一个字符串时间
     */
    static func desStr(serviceStr: String) -> Int{
        // 1.创建时间格式化对象
        let formatter = DateFormatter()
        // 2.指定时间格式
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 3.指定时区
        formatter.locale = Locale(identifier: "en")
        // 4.转换时间
        guard let serviceDate = formatter.date(from: serviceStr) else { return 0}
        
        // 获取当前时间与指定时间的差值
        return Int(Date().timeIntervalSince(serviceDate))
    }
}


