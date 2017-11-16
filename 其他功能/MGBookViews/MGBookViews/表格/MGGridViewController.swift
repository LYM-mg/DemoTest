//  MGGridViewController.swift
//  MGBookViews
//  Created by i-Techsys.com on 2017/11/15.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// https://github.com/LYM-mg
// http://www.jianshu.com/u/57b58a39b70e

import UIKit

class MGGridViewController: UIViewController, UICollectionGridViewSortDelegate {
    
    var gridViewController: UICollectionGridViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridViewController = UICollectionGridViewController()
        gridViewController.setColumns(columns: ["编号","客户", "消费金额", "消费次数", "满意度"])
        gridViewController.addRow(row: ["No.01","hangge", "100", "8", "60%"])
        gridViewController.addRow(row: ["No.02","张三", "223", "16", "81%"])
        gridViewController.addRow(row: ["No.03","李四", "143", "22", "93%"])
        gridViewController.addRow(row: ["No.04","王五", "75", "4", "53%"])
        gridViewController.addRow(row: ["No.05","韩梅梅", "43", "12", "33%"])
        gridViewController.addRow(row: ["No.06","李雷", "33", "27", "45%"])
        gridViewController.addRow(row: ["No.07","王大力", "33", "22", "15%"])
        gridViewController.addRow(row: ["No.08","蝙蝠侠", "100", "8", "60%"])
        gridViewController.addRow(row: ["No.09","超人", "223", "16", "81%"])
        gridViewController.addRow(row: ["No.10","钢铁侠", "143", "25", "93%"])
        gridViewController.addRow(row: ["No.11","灭霸", "75", "2", "53%"])
        gridViewController.addRow(row: ["No.12","快银", "43", "12", "33%"])
        gridViewController.addRow(row: ["No.13","闪电侠", "33", "29", "45%"])
        gridViewController.addRow(row: ["No.14","绿箭", "33", "22", "15%"])
        gridViewController.addRow(row: ["No.15","绿巨人", "223", "16", "88%"])
        gridViewController.addRow(row: ["No.16","黑寡妇", "143", "25", "43%"])
        gridViewController.addRow(row: ["No.17","企鹅人", "75", "24", "51%"])
        gridViewController.addRow(row: ["No.18","双面人", "43", "11", "34%"])
        gridViewController.addRow(row: ["No.19","奥特曼", "33", "27", "25%"])
        gridViewController.addRow(row: ["No.20","小怪兽s", "33", "28", "05%"])
        gridViewController.addRow(row: ["No.21","四大皆空", "200", "13", "40%"])
        gridViewController.addRow(row: ["No.22","大神", "98", "54", "86%"])
        gridViewController.addRow(row: ["No.23","李发的", "143", "23", "96%"])
        gridViewController.addRow(row: ["No.24","王他个人", "65", "90", "57%"])
        gridViewController.addRow(row: ["No.25","韩回梅", "86", "4", "39%"])
        gridViewController.addRow(row: ["No.26","李大雷", "25", "8", "95%"])
        gridViewController.addRow(row: ["No.27","王大餐", "83", "1", "25%"])
        gridViewController.addRow(row: ["No.28","钢钒头", "645", "9", "80%"])
        gridViewController.addRow(row: ["No.29","何慧达", "54", "31", "31%"])
        gridViewController.addRow(row: ["No.30","倪妮才", "98", "21", "63%"])
        gridViewController.addRow(row: ["No.31","接口", "54", "24", "57%"])
        gridViewController.addRow(row: ["No.32","接口都三", "15", "15", "23%"])
        gridViewController.addRow(row: ["No.33","看书啦", "432", "25", "65%"])
        gridViewController.addRow(row: ["No.34","背景帝", "56", "45", "16%"])
        gridViewController.addRow(row: ["No.35","懂球帝", "321", "32", "84%"])
        gridViewController.addRow(row: ["No.36","背锅侠", "543", "87", "92%"])
        gridViewController.addRow(row: ["No.37","篮球运动", "75", "2", "53%"])
        gridViewController.addRow(row: ["No.38","无耻小三", "54", "6", "35%"])
        gridViewController.addRow(row: ["No.39","金仨", "32", "74", "35%"])
        gridViewController.addRow(row: ["No.40","我喜欢你s", "23", "43", "100%"])
        
        gridViewController.sortDelegate = self
        view.addSubview(gridViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        let y: CGFloat = (self.navigationController != nil) ? (MGScreenH==812.0 ? 88:64):0
        let tabBarH: CGFloat = (self.tabBarController?.hidesBottomBarWhenPushed != true) ? (MGScreenH==812.0 ? 83:49):0
        gridViewController.view.frame = CGRect(x:0, y:y, width:view.frame.width,
                                               height:view.frame.height-y-tabBarH)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //表格排序函数
    func sort(colIndex: Int, asc: Bool, rows: [[Any]]) -> [[Any]] {
        let sortedRows = rows.sorted { (firstRow: [Any], secondRow: [Any])
            -> Bool in
            let firstRowValue = firstRow[colIndex] as! String
            let secondRowValue = secondRow[colIndex] as! String
            if colIndex == 0 || colIndex == 1 {
                //首例、姓名使用字典排序法
                if asc {
                    return firstRowValue < secondRowValue
                }
                return firstRowValue > secondRowValue
            } else if colIndex == 2 || colIndex == 3 {
                //中间两列使用数字排序
                if asc {
                    return Int(firstRowValue)! < Int(secondRowValue)!
                }
                return Int(firstRowValue)! > Int(secondRowValue)!
            }
            //最后一列数据先去掉百分号，再转成数字比较
            let firstRowValuePercent = Int(firstRowValue.substring(to:
                firstRowValue.index(before: firstRowValue.endIndex)))!
            let secondRowValuePercent = Int(secondRowValue.substring(to:
                secondRowValue.index(before: secondRowValue.endIndex)))!
            if asc {
                return firstRowValuePercent < secondRowValuePercent
            }
            return firstRowValuePercent > secondRowValuePercent
        }
        return sortedRows
    }
}
