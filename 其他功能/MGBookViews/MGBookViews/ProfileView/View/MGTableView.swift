//  MGTableView.swift
//  MGBookViews
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// https://github.com/LYM-mg
// http://www.jianshu.com/u/57b58a39b70e

import UIKit

enum TableViewType: Int {
    case dynamic = 0
    case art = 1
    case more = 2
    case layout = 3
}


class MGTableView: UITableView,UITableViewDataSource {

    lazy var type: TableViewType = .dynamic
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.backgroundColor = UIColor.white
        self.dataSource = self
    }
    
    convenience init(type: TableViewType) {
        self.init()
        self.type = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
//    override var contentOffset: CGPoint {
//        get {
//            return super.contentOffset
//        }set {
//           super.contentOffset = newValue
//        }
//    }
    override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        if (self.window != nil) {
            super.setContentOffset(contentOffset, animated: animated)
        }
    }
}


extension MGTableView {
    override var numberOfSections: Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .dynamic {
             return 50
        }else if type == .art{
             return 50
        }else if type == .more {
             return 20
        }else if type == .layout{
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        if type == .dynamic {
            cell?.textLabel?.text = "MG明明就是你\(indexPath.row)"
        }else if type == .art{
            cell?.textLabel?.text = "文章啊啊是\(indexPath.row)"
        }else if type == .more {
            cell?.textLabel?.text = "更多资料\(indexPath.row)"
        }
        
        return  cell!
    }
}
