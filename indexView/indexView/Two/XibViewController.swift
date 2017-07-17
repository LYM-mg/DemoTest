//
//  XibViewController.swift
//  indexView
//
//  Created by i-Techsys.com on 2017/7/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class XibViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let view: XJLView  = XJLView.loadViewFromXib1()
        self.view.addSubview(view)
        let view1: MGXibView  = MGXibView.loadViewFromXib1()
        view1.mg_y = view.frame.maxY + 10
        self.view.addSubview(view1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SB", style: .done, target: self, action: #selector(LoadSB))
    }
    
    func LoadSB() {
        self.show(SBTools.loadControllerFromSB("Main"), sender: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
