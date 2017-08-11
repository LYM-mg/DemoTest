//
//  ViewController.swift
//  Demo
//
//  Created by i-Techsys.com on 2017/8/11.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(actionBlock: { [unowned self](tap) in
            // 要执行的代码
            debugPrint("我被点击了----")
        }))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClick(tap:))))
    }
    
    func tapClick(tap: UITapGestureRecognizer) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.sync {
            print("dsadsad")
        }
    }
}

