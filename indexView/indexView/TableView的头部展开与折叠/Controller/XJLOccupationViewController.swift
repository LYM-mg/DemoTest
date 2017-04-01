//
//  XJLOccupationViewController.swift
//  OccupationClassify
//
//  Created by 许佳莉 on 2017/3/24.
//  Copyright © 2017年 MESMKEE. All rights reserved.
//

import UIKit
import Alamofire

class XJLOccupationViewController: UITableViewController {
    // 数据源
    fileprivate lazy var occupationDict = [XJLGroupModel]()
    
    fileprivate lazy var hearderSection: Int = 0
//    private lazy var hearderView: XJLHeaderFooterView = XJLHeaderFooterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "职业列表"
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "TableViewCellID")
        tableView.register(XJLHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "HeaderFooterViewID")
        
        loadData()
    }
    
    
    func loadData() {
        // http://api.shikee.tv/common/Occupation/index
        Alamofire.request("http://api.shikee.tv/common/Occupation/index").responseJSON { (response) in
            guard let dict = response.result.value as? [String: Any] else { return }
            guard let dictArr = dict["data"] as? [[String: Any]] else { return }
            
            var resultArr:[[String: Any]] = [[String: Any]]()
            var lastIid: Int = 0
            for model in dictArr {
                let iid = Int(model["iid"]! as! String)!
                if lastIid == iid {
                    continue
                }
                var arr = [Any]()
                for dict in dictArr{
                    if iid == (dict["iid"]! as AnyObject).intValue {
                        arr.append(dict)
                    }
                }
                let dictionary:[String: Any] = ["group": arr]
                resultArr.append(dictionary)
                lastIid = iid
            }
            
            for model in resultArr {
                self.occupationDict.append(XJLGroupModel(dict: model))
            }
            self.tableView.reloadData()
        }
    }
}


// MARK: - Table view data source
extension XJLOccupationViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return occupationDict.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = occupationDict[section]  //  return  group.models.count
        return group.isExpaned == false ? 0 : group.models.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellID", for: indexPath)
        let group = occupationDict[indexPath.section]
        let model = group.models[indexPath.row]
        cell.textLabel?.text = model.name
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension XJLOccupationViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderFooterViewID") as! XJLHeaderFooterView
        // 回调
        headerView.gruop = occupationDict[section]
        var tempHearderView: XJLHeaderFooterView? = XJLHeaderFooterView()
        headerView.btnBlock = { (dict: XJLGroupModel,hearderView: XJLHeaderFooterView) in
            self.tableView.beginUpdates()
            self.tableView.reloadSections(IndexSet(integer: self.hearderSection), with: .automatic)
            self.tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
            self.tableView.endUpdates()
            
            tempHearderView = hearderView
            self.hearderSection = section
            tempHearderView!.gruop?.isExpaned = false
//            if ((self.hearderSection == section)) {
//
//                return
//            }
        }
        return headerView
    }
}
