//
//  TbaleViewContainTBController.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/8.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit

class TbaleViewContainTBController: UIViewController {

    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tb = UITableView(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tb.dataSource = self
        tb.delegate = self
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        tb.estimatedRowHeight = 44  // 设置估算高度
        tb.rowHeight = UITableView.automaticDimension // 告诉tableView我们cell的高度是自动的
        tb.register(MGTBCell.self, forCellReuseIdentifier: "CellID")
        if #available(iOS 11.0, *){
            tb.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tb
        }()
    var headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomColor()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.rightClick))


        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view).offset(64)
        }

        let headerView  = UIView()
        headerView.backgroundColor = UIColor.red
        tableView.tableHeaderView = headerView
        self.headerView = headerView

        headerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.width.equalTo(self.view.mg_width)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        tableView.reloadData()
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
        UIView.animate(withDuration: 0.5) {
            self.tableView.layoutIfNeeded()
            self.tableView.tableHeaderView = self.headerView;
        }
    }

    @objc func rightClick() {
//        self.navigationController?.pushViewController(TbaleViewContainTBController(), animated: true)
    }
}

extension TbaleViewContainTBController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! MGTBCell
        cell.index = indexPath.row;
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
}

class MGTBCell: UITableViewCell {
    var index: NSInteger? {
        didSet {
            let height = self.tableView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            print("contentSize.height=\(self.tableView.contentSize.height) -- \(height)")
//            self.tableView.mg_height = self.tableView.contentSize.height
            self.tableView.reloadData()
            self.mg_height = self.tableView.contentSize.height;
            DispatchQueue.main.asyncAfter(deadline: .now()+0.001) {
                self.tableView.snp.makeConstraints { (make) in

                    make.height.equalTo(self.tableView.contentSize.height)
                }
                self.superview?.layoutIfNeeded()
                self.contentView.layoutIfNeeded()
            }
        }
    }
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        let tb = UITableView(frame: .zero, style: .plain)
        tb.backgroundColor = UIColor.white
        tb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tb.dataSource = self
        tb.delegate = self
        tb.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            tb.contentInsetAdjustmentBehavior = .never
        }else {
        }
//        tb.estimatedRowHeight = 44  // 设置估算高度
//        tb.rowHeight = UITableView.automaticDimension // 告诉tableView我们cell的高度是自动的
        tb.rowHeight = 44
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "CellID111")
        return tb
    }()
    var block:((_ btn: UIButton, _ cell:MGTBCell) -> ())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.tableView)

        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
            make.width.equalTo(MGScreenW)
            make.height.equalTo(self.contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc func btnClick(_ btn: UIButton) {
        if (block != nil) {
            self.block!(btn,self)
        }
    }
}

extension MGTBCell:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch index {
            case 0,2,5,8,12:
                return 3
            case 1,4,9:
                return 1
            default:
                return 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID111", for: indexPath)
        switch index {
        case 0,2,5,8,12:
            cell.backgroundColor = UIColor.red
        case 1,4,9:
            cell.backgroundColor = UIColor.green
        default:
            cell.backgroundColor = UIColor.blue
        }

        cell.textLabel?.text = "MGindex=\(String(describing: index!)) -- \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}
