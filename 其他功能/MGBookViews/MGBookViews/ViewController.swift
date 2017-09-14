//
//  ViewController.swift
//  MGBookViews
//
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var number = 110;
    var number1 = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orange
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "测试手势", style: .plain, target: self, action: #selector(click))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "加载图片", style: .plain, target: self, action: #selector(click1))
    }

    func click() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.mg_randomColor()
        self.show(vc, sender: nil)
    }
    
    func click1() {
        view.addSubview(imageView)
        imageView.center = self.view.center
        imageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "80@2x", ofType: ".png")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.show(MGProfileViewController(), sender: nil)
        
//        let _ = Timer.new(after: 5.0.minutes) {
//            print("5秒后执行定时器")
//        }
        
//        var nub = arc4random_uniform(10) + 5
//        _ = Timer.every(1.0) { [unowned self] in
//            self.number -= 1
//            MGLog(self.number)
//            if self.number == 0 {
//                print("定时器销毁")
//            }
//        }
        
        Timer.every(1.0) { [unowned self](timer: Timer) in
            self.number1 -= 1
            MGLog(self.number1)
            if self.number1 == 0 {
                timer.invalidate()
                print("定时器销毁")
            }
        }

        
        let num: Int64 = 1111144411111
        print(String(format: "%014ld", num))
        
        let heihie = 111
        print(String(format: "%014ld", heihie))
        
        let num2 = 222
        print(String(format: "%08ld", num2))
        
        let heihie2 = 99
        print(String(format: "%08ld", heihie2))
        
        imageView.image = UIImage(named: "80")
    }
}

