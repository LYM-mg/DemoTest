//
//  XibViewController.swift
//  indexView
//
//  Created by i-Techsys.com on 2017/7/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class XibViewController: UIViewController {

    fileprivate lazy var titleLabel: UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        let view: XJLView  = XJLView.loadViewFromXib1()
        self.view.addSubview(view)
        let view1: MGXibView  = MGXibView.loadViewFromXib1()
        view1.mg_y = view.frame.maxY + 10
        self.view.addSubview(view1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SB", style: .done, target: self, action: #selector(LoadSB))
        
        titleLabel.frame = CGRect(x: 120, y: 380, width: 200, height: 100)
    }
    
    func LoadSB() {
        self.show(SBTools.loadControllerFromSB("Main"), sender: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var att = NSMutableAttributedString(string: "释放查看，的撒会单据号塞到好似符号ID师父hi第三方his地方很多看撒娇的接口", attributes: [NSVerticalGlyphFormAttributeName: 1, NSFontAttributeName: UIFont.systemFont(ofSize: 9), NSForegroundColorAttributeName: UIColor.red])
        titleLabel.attributedText = att
        titleLabel.transform = CGAffineTransform(rotationAngle: .pi/2)
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
