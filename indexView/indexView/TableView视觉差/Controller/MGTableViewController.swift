//
//  ViewController.swift
//  MGTableView
//
//  Created by i-Techsys.com on 16/12/13.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit

class MGTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var dataArr: [UIImage] = {
        var arr: [UIImage] = [UIImage]()
        for _ in 1...10 {
            for i in 1...10 {
                let image = UIImage(named: String(format: "%02d", i))
                arr.append(image!)
            }
        }
        return arr
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorStyle = .none
        tableView.rowHeight = 300
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDataSource
extension MGTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let imageV = cell.viewWithTag(1000) as! UIImageView
        imageV.image = dataArr[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MGTableViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in self.tableView.visibleCells {
            let imageVParentV = cell.viewWithTag(1001)
            let imageV = cell.viewWithTag(1000)
            let rect = imageVParentV?.convert((imageVParentV?.bounds)!, to: nil)
//            var y = UIScreen.main.bounds.size.height - (rect?.origin.y)! - 600
            var y = -(rect?.origin.y)!
            y *= 0.2
            if y>0 {
                y=0
            }
            if y < -200 {
                y = -200
            }
            imageV?.frame.origin.y = y
        }
    }
}
