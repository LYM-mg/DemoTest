//
//  MGLineViewController.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/22.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGLineViewController: UIViewController,LineVisible {
    var lineWidth: CGFloat = 3
    var lineColor: UIColor = UIColor.brown
    var lineHeight: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let redV = UIView(frame: CGRect(x: 100, y: 80, width: 100, height: 100))
        redV.backgroundColor = .red
        addLineTo(view: redV)
        view.addSubview(redV)
        
        
        
        let blueV = UIView(frame: CGRect(x: 100, y: 200, width: 100, height: 80))
        blueV.tag = 100
        blueV.backgroundColor = .blue
        addLineTo(view: blueV,position: .top)
        view.addSubview(blueV)
        
        
        let greenV = UIView(frame: CGRect(x: 100, y: 300, width: 100, height: 80))
        greenV.backgroundColor = .green
        addLineTo(view: greenV, position: .left)
        view.addSubview(greenV)
        
        lineColor = .yellow
        let purpleV = UIView(frame: CGRect(x: 100, y: 400, width: 100, height: 80))
        purpleV.backgroundColor = UIColor.purple
        addLineTo(view: purpleV, position: .right)
        view.addSubview(purpleV)
        
        let btn = UIButton(frame: CGRect(x: 60, y: 500, width: 80, height: 50))
        btn.backgroundColor = UIColor.purple
        btn.setTitle("点我试试", for: .normal)
        btn.addTarget(self, action: #selector(show(_:)), for: .touchUpInside)
        addLineTo(view: btn, position: .right)
        view.addSubview(btn)
        
        let btn1 = UIButton(frame: CGRect(x: 200, y: 500, width: 80, height: 50))
        btn1.backgroundColor = UIColor.purple
        btn1.setTitle("down", for: .normal)
        btn1.addTarget(self, action: #selector(show1(_:)), for: .touchUpInside)
        addLineTo(view: btn, position: .right)
        view.addSubview(btn1)
    }
    
    @objc fileprivate func show(_ btn: UIButton) {
        guard let menu = HWDropdownMenu(type: DropdownMenuType.up) else {return}
        menu.delegate = self
        // 2.设置内容
        let vc = MGTitleMenuViewController(style: .plain)
        vc.view.height = 100
        vc.view.width = 100
        menu.contentController = vc
        // 3.显示
        menu.show(from: btn)
    }
    
    @objc fileprivate func show1(_ btn: UIButton) {
        guard let menu = HWDropdownMenu(type: DropdownMenuType.down) else {return}
        menu.delegate = self
        // 2.设置内容
        let vc = MGTitleMenuViewController(style: .plain)
        vc.view.height = 80
        vc.view.width = 80
        menu.contentController = vc
        // 3.显示
        menu.show(from: btn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let v = view.viewWithTag(100)
        deleteLineTo(view: v!)
    }
}

extension MGLineViewController: HWDropdownMenuDelegate {
    func dropdownMenuDidShow(_ menu: HWDropdownMenu!) {
        
    }
    
    func dropdownMenuDidDismiss(_ menu: HWDropdownMenu!) {
        
    }
}
