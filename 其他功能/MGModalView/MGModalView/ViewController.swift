//
//  ViewController.swift
//  MGModalView
//
//  Created by i-Techsys.com on 17/4/7.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate lazy var normalModalView: MGModelView = MGModelView()
    fileprivate lazy var narrowedModalView: MGModelView = MGModelView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "ModalView"
        self.view.backgroundColor = UIColor.white
        
        self.normalModalView = MGModelView(size: CGSize(width: self.view.bounds.size.width, height: 300), andBaseViewController: self)
        self.normalModalView.contentView.backgroundColor = UIColor.yellow
        
        
        self.narrowedModalView = MGModelView(size: CGSize(width: self.view.bounds.size.width, height: 300), andBaseViewController: self)
        self.narrowedModalView.narrowedOff = true;
        self.narrowedModalView.contentView.backgroundColor = UIColor.red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func model(_ sender: UIButton) {
        normalModalView.open()
    }

    @IBAction func narrowModel(_ sender: UIButton) {
        narrowedModalView.open()
    }
}

