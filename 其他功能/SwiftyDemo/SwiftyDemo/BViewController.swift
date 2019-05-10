//
//  BViewController.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/3/26.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit

class BViewController: UIViewController {
    fileprivate lazy var selectedArr = [false,false,false,false,false,false]
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomColor()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.rightClick))


        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }

    deinit {
        print("\(self) deinit")
    }

    @objc func rightClick() {
        self.navigationController?.pushViewController(RightViewController(), animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(LeftViewController(), animated: true)
    }
}

extension BViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)  as! Cell
        cell.textLabel?.text = "ssssss\(indexPath.row)"
        cell.btn.isSelected = selectedArr[indexPath.row]
        cell.block = { [unowned self](btn:UIButton,cell1:Cell) in
            if (btn.isSelected) {return}
            self.selectedArr = [false,false,false,false,false,false]
            self.selectedArr[indexPath.row] = true
            self.tableView.reloadData()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}


class Cell: UITableViewCell {
    var btn: UIButton!
    var block:((_ btn: UIButton, _ cell:Cell) -> ())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let btn = UIButton()
        btn.center = self.contentView.center;
        btn.setImage(UIImage(named: "tongyi2"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "tongyi"), for: UIControl.State.selected)
        self.btn = btn;
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(self.btnClick(_:)), for: UIControl.Event.touchUpInside)
        self.accessoryView = btn;
//        self.contentView.addSubview(btn)
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
