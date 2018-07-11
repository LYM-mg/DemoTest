//
//  ViewController.swift
//  MGBookViews
//
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var isShowAlert: Bool = false
    lazy var isShowUpdateAlert: Bool = false
    lazy var imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var number = 110;
    var number1 = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orange
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "测试手势", style: .plain, target: self, action: #selector(click))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "加载图片", style: .plain, target: self, action: #selector(click1))
        
        
        let textF = UITextField(frame: CGRect(x: 10, y: 100, width: 200, height: 30))
        textF.borderStyle = .roundedRect
        textF.clearButtonMode = .whileEditing
        textF.delegate = self
        view.addSubview(textF)
        
        let textF1 = UITextField(frame: CGRect(x: 10, y: 150, width: 200, height: 30))
        textF1.loadRightClearButton()
        textF1.tag = 100
        textF1.delegate = self
        textF1.borderStyle = .roundedRect
        textF1.clearButtonMode = .whileEditing
        view.addSubview(textF1)
    }

    func click() {
        self.show(MGProfileViewController(), sender: nil)
//        let vc = MGNextViewController()
//        vc.view.backgroundColor = UIColor.mg_randomColor()
//        self.show(vc, sender: nil)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.navigationController?.topViewController == self) {
            if (self.isShowAlert)  {
                MGWindow.show(dismiss: {
                    self.isShowAlert = false
                })
            }
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.isShowUpdateAlert = true
        var alertView: XLAlertView? = XLAlertView.instance(withTitle: "你个大笨蛋", forceUpdate: "NO", withContent: "你是笨蛋吗？你看我想不想理你", withEnsureBlock: { (reslut) in
            UIApplication.shared.openURL(URL(string: "http://baidu.com")!)
            self.isShowUpdateAlert = false
        }) { (reslut) in
            self.isShowUpdateAlert = false
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.isShowUpdateAlert = true
            let vc: UIViewController = (self.tabBarController!.selectedViewController! as! UINavigationController).topViewController!
            if (vc == self) {
                self.tabBarController?.view.addSubview(alertView!)
            }
        }
       
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.isShowAlert = true
            let vc: UIViewController = (self.tabBarController!.selectedViewController! as! UINavigationController).topViewController!
            if (vc == self) {
                MGWindow.show(dismiss: {
                    self.isShowAlert = false
                })
            }
        }
        
//        var alertView: XLAlertView? = XLAlertView.instance(withTitle: "你个大笨蛋", forceUpdate: "NO", withContent: "你是笨蛋吗？你看我想不想理你", withEnsureBlock: { (reslut) in
//            UIApplication.shared.openURL(URL(string: "http://baidu.com")!)
//        }) { (reslut) in
//
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            self.tabBarController?.view.addSubview(alertView!)
//        }
    
    
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
        
//        Timer.every(1.0) { [unowned self](timer: Timer) in
//            self.number1 -= 1
//            MGLog(self.number1)
//            if self.number1 == 0 {
//                timer.invalidate()
//                print("定时器销毁")
//            }
//        }
//
//        
//        let num: Int64 = 1111144411111
//        print(String(format: "%014ld", num))
//        
//        let heihie = 111
//        print(String(format: "%014ld", heihie))
//        
//        let num2 = 222
//        print(String(format: "%08ld", num2))
//        
//        let heihie2 = 99
//        print(String(format: "%08ld", heihie2))
//        
//        imageView.image = UIImage(named: "80")
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if range.length == 0 {
//            if textField.tag == 100 {
////                var regex = ""
//                if range.location == 1 {
//                    if textField.text == "0" {
//                        let regex = "(^([.]\\d{0,1})?)$" // "(^(0|([1-9]{0,}))([.]\\d{0,1})?)$"
//                        // 2.利用规则创建表达式对象
//                        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//                        print(predicate.evaluate(with: string))
//                        return predicate.evaluate(with: string)
//                    }
//                }
//                let regex = "(^(0|([1-9]{0,}))([.]\\d{0,1})?)$" // "(^(0|([1-9]{0,}))([.]\\d{0,1})?)$"
//                // 2.利用规则创建表达式对象
//                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//                textField.text = textField.text ?? "" + string
//                print(predicate.evaluate(with: textField.text))
//                return predicate.evaluate(with: textField.text)
//            }else {
//
//            }
//        }
        let regex = "(^(0|([1-9]{0,}))([.]\\d{0,2})?)$"
        // "^[0-9]*?((.)[0-9]{0,2})?$"
        // "(^(0|([1-9]{0,}))([.]\\d{0,2})?)$"
        // "(^[1-9]\\d{0,}(([.]\\d{0,2})?))?|(^[0]?(([.]\\d{0,2})?))?"
        // "([1-9]\\d{0,}(([.]\\d{0,1})?))?|([0]?(([.]\\d{0,1})?))?"
        // "([1-9]\\d{0,}(([.]\\d{0,1})?))?|([0]|(0[.]\\d{0,1}))" // |
        // "^[0-9]+(.[0-9]{2})?$"  //"[0-9]+\\.?[0-9]{2}"  //"^\\d+(\\.\\d{2})?$" // "/^(0|[-][1-9]d{0,}).d{1,2}$/"   // "^(0|[1-9]\\d{0,})(([.]\\d{0,1})?)?$"
        // 2.利用规则创建表达式对象
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let text = (textField.text ?? "") + string
        if text.hasPrefix(".") {
            textField.text = "0" + textField.text!
        }
        print(predicate.evaluate(with: text))
        return predicate.evaluate(with: text)
//        return true
    }
}

