//
//  Date+Extension.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 17/1/6.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

extension Date {
    /**
        时间戳转化为字符串
        time:时间戳
     */
    static func timeStamp(time: TimeInterval) -> String {
        //时间戳
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(time)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日"
        print("对应的日期时间：\(dformatter.string(from: date as Date))")
        return dformatter.string(from: date)
    }
    
    /**
       时间戳转化为字符串
       time:时间戳字符串
     */
    static func timeStamp(timeStr: String) -> String {
        let time = Double(timeStr)!  + 28800  //因为时差问题要加8小时 == 28800 sec

   //        let time: TimeInterval = 1000
        let detaildate = Date(timeIntervalSince1970: time)
        
        //实例化一个NSDateFormatter对象
        let dateFormatter = DateFormatter()
        
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDateStr = dateFormatter.string(from: detaildate)
        return currentDateStr
    }
    
    /**
        time: 字符串
     */
    static func timeFromStr(strTime: String) -> String {
        //实例化一个NSDateFormatter对象
        let dateFormatter = DateFormatter()
        
        //设定时间格式,这里可以设置成自己需要的格式
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: strTime)
        //用[NSDate date]可以获取系统当前时间
        let currentDateStr = dateFormatter.string(from: date!)
        
        //输出格式为：2010-10-27 10:22:13
//        NSLog("%@",currentDateStr)
        
        //alloc后对不使用的对象别忘了release
        return currentDateStr
    }
    
    
    /**
     *  根据字符串转换时间，时间的格式要根据服务器返回的时间类型，要不然会转换失败 "EEE MM dd HH:mm:ss Z yyyy"
     */
    static func dateWithString(str: String) -> Date? {
        // 1.创建时间格式化对象
        let formatter = DateFormatter()
        // 2.指定时间格式
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 3.指定时区
        formatter.locale = Locale(identifier: "en")

        // 4.转换时间
        return formatter.date(from: str)
    }
}
