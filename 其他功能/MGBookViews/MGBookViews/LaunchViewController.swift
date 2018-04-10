//
//  LaunchViewController.swift
//  MGBookViews
//
//  Created by newunion on 2018/2/7.
//  Copyright © 2018年 i-Techsys. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet weak var imageV: UIImageView!
    var start: CFTimeInterval = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()

        start = CACurrentMediaTime()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        let end = CACurrentMediaTime()
        
        print("App启动时间\(end-start)秒")
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
