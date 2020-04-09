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

        self.tableView.setEditing(true, animated: true)

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
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)  as! Cell
        cell.textLabel?.text = "ssssss\(indexPath.row)"
        
        if indexPath.row == 1  || indexPath.row == 3 || indexPath.row == 4{
            cell.titleBtn?.mg_x = 15
            cell.label.text = "sahklJLefajkfeowpqrjw3eqjopjorfqj温度计链球菌人气颇撒放假快乐人家返利网确认解放路驱蚊扣金额路客文化提交了我就退了二纺机欧六局外人离开他国际物流特困"
        }else {
            cell.label.text = "hahahahah我测试一下你说的问题"
            cell.titleBtn?.mg_x = 45
        }
//        cell.btn.isSelected = selectedArr[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 1  || indexPath.row == 3 || indexPath.row == 4{
            return .none
        }else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .destructive, title: "delete") { (action, index) in
            
        }]
    }
}


class Cell: UITableViewCell {
    var btn: UIButton!
    var titleBtn: UIButton!
    var label: UILabel!
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
        
        
        let titleBtn = UIButton()
        titleBtn.center = self.contentView.center;
        titleBtn.setTitle("edwwe241111twtw", for: .normal)
        titleBtn.setTitleColor(.orange, for: .normal)
        titleBtn.sizeToFit()
        titleBtn.addTarget(self, action: #selector(self.btnClick(_:)), for: UIControl.Event.touchUpInside)
        self.titleBtn = titleBtn;
        self.titleBtn.mg_origin = CGPoint(x: 30, y: self.mg_height/2)
        
        self.addSubview(titleBtn)
        
        
        label  = UILabel()
        label.numberOfLines = 0
        label.text = "rwiqutrtqirtqqqqqqqqqqqqwkjqwejqkhk"
        label.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(label)
        
        
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30))
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for control in self.subviews {
            
            if type(of: control) === NSClassFromString("UITableViewCellEditControl") {
                for v in control.subviews {
                    // 可以修改TableView多选状态下选中状态的图片
                    if (v is UIImageView) {
                        let img = v as? UIImageView
                        v.isHidden = true
                    }
                }
            }
        }
    }
}
