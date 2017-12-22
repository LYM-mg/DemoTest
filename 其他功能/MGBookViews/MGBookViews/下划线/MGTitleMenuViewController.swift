//
//  MGTitleMenuViewController.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/22.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGTitleMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 30
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: ID)
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "好友"
        }
        else if indexPath.row == 1 {
            cell?.textLabel?.text = "密友"
        }
        else if indexPath.row == 2 {
            cell?.textLabel?.text = "全部"
        }
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
}
