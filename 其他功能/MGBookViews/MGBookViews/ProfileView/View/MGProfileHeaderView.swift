//  MGProfileHeaderView.swift
//  MGBookViews
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// https://github.com/LYM-mg
// http://www.jianshu.com/u/57b58a39b70e

import UIKit
import SnapKit

class MGProfileHeaderView: UIView {
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        nameLabel.text = "MG明明就是你"
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()
    
    lazy var infoLabel: UILabel = {
        let infoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        infoLabel.text = "珠海\n\n有一个人，明明很忙\n\n却依旧抽出时间帮人解决BUG"
        infoLabel.textAlignment = .center
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.textColor = UIColor.gray
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.systemFont(ofSize: 11)
        return infoLabel
    }()

    lazy var editInfoButton: UIButton = {
        let editInfoButton = UIButton(type: .custom)
        editInfoButton.setTitle("编辑个人资料", for: .normal)
        editInfoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        editInfoButton.setTitleColor(UIColor.red, for: .normal)
        editInfoButton.layer.borderColor = UIColor.red.cgColor
        editInfoButton.layer.cornerRadius = 2
        editInfoButton.layer.borderWidth = 0.5
        editInfoButton.addTarget(self, action: #selector(self.clickedEditAction), for: .touchUpInside)

        return editInfoButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(infoLabel)
        addSubview(editInfoButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(infoLabel.snp.top).offset(-10)
            make.centerX.equalTo(infoLabel)
        }
        editInfoButton.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(15)
            make.centerX.equalTo(infoLabel)
            make.width.equalTo(100)
        }
    }
    
    func clickedEditAction(_ sender: UIButton) {
        print("你点击了编辑资料按钮")
    }

}
