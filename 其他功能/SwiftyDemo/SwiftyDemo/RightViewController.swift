//
//  RightViewController.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/3/26.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit

class RightViewController: UIViewController {

    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tb = UITableView(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tb.dataSource = self
        tb.delegate = self
        //        tb.estimatedRowHeight = 60  // 设置估算高度
        //        tb.rowHeight = UITableViewAutomaticDimension // 告诉tableView我们cell的高度是自动的
        tb.register(Cell.self, forCellReuseIdentifier: "CellID")
        return tb
    }()
    var headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomColor()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.rightClick))


        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }

        let headerView  = UIView()
        headerView.backgroundColor = UIColor.red
        tableView.tableHeaderView = headerView
        self.headerView = headerView

        headerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.width.equalTo(self.view.mg_width)
        }

        let btn = UIButton()
        let lb = UILabel()
        btn.backgroundColor = UIColor.randomColor()
        btn.setTitle("傻瓜", for: .normal)
        btn.addTarget(self, action: #selector(changeClick), for: .touchUpInside)
        lb.backgroundColor = UIColor.randomColor()
        lb.text = "你就是一个笨蛋，是吗？"
        lb.numberOfLines = 0;
        lb.tag = 100;
        headerView.addSubview(btn)
        headerView.addSubview(lb)

        lb.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.top.equalTo(headerView).offset(10)
            make.bottom.equalTo(btn.snp.top).offset(-10)
        }
        btn.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.bottom.equalTo(headerView).offset(-10)
        }
    }

    deinit {
        print("\(self) deinit")
    }

    @objc func changeClick() {
        var str = "你就是一个笨蛋，是吗？不🙅‍♂️，我不是，你才是笨蛋！那你是一个傻瓜，笨笨哒，哈哈哈哈哈。不🙅‍♀️，我也不是一个傻瓜，我是一个可爱的人。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。如果全世界与你为敌的话，那么他就是我的敌人了。"
        /// 随机数
        let count = str.count
        let randonNumber = Int(arc4random_uniform(UInt32(count-11))+11)
        str = String(str.prefix(randonNumber))
        print(str)

        let lb: UILabel = self.tableView.tableHeaderView?.viewWithTag(100) as! UILabel
        lb.text = str
        //        let height = self.headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        //            self.tableView.tableHeaderView?.mg_height = height
        UIView.animate(withDuration: 0.5) {
            self.tableView.layoutIfNeeded()
            self.tableView.tableHeaderView = self.headerView;
        }
    }

    @objc func rightClick() {
        self.navigationController?.pushViewController(TbaleViewContainTBController(), animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(LeftViewController(), animated: true)
    }
}

extension RightViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

