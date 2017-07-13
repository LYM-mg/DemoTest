//
//  XJLHeaderFooterView.swift
//  OccupationClassify
//
//  Created by i-Techsys.com on 17/3/27.
//  Copyright © 2017年 MESMKEE. All rights reserved.
//

import UIKit

class XJLHeaderFooterView: UITableViewHeaderFooterView {

    private lazy var image = UIImageView()
    private lazy var label = UILabel()
    var btnBlock: ((_ dict: XJLGroupModel,_ hearderView: XJLHeaderFooterView)->())? // 头部点击回调
    
    // 模型
    var gruop: XJLGroupModel? {
        didSet {
            if (gruop!.isExpaned) { // 已经展开
                image.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)/2);
            } else { // 未展开
                image.transform = CGAffineTransform.identity;
            }
            
           label.text = gruop?.models.first?.industry_name ?? "笨蛋"
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    func setUpUI() {
        self.layoutIfNeeded()
        contentView.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
        
        image = UIImageView(frame: CGRect(x: 10, y: 12, width: 7, height: 10))
        image.image = UIImage(named: "xiala")
        image.center = CGPoint(x: 10, y: 44/2)
        label = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 44))
        label.textColor = UIColor.white
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: 44))
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(XJLHeaderFooterView.btnClick(_:)), for: .touchUpInside)
        self.addSubview(image)
        self.addSubview(label)
        self.addSubview(btn)
    }
    
    @objc func btnClick(_ btn: UIButton) {
        gruop!.isExpaned = !gruop!.isExpaned
        if (gruop!.isExpaned) { // 已经展开
            image.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)/2)
        } else { // 未展开
            image.transform = CGAffineTransform.identity;
        }
        
        if btnBlock != nil {
            btnBlock!(gruop!,self)
        }
    }
}
