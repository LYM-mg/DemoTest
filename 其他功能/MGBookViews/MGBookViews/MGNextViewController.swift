//
//  MGNextViewController.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/28.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGNextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let preview: CameraBlurView = Bundle.main.loadNibNamed("CameraBlurView", owner: nil, options: nil)?.first as! CameraBlurView
        preview.frame = self.view.frame
//        preview.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)
        preview.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.7)
        preview.clipsToBounds = true
        view.addSubview(preview)
    }
}
