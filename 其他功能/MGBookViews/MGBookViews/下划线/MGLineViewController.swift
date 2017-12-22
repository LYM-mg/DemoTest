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
