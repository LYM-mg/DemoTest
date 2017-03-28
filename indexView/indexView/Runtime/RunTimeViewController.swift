//
//  RunTimeViewController.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/17.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import Foundation

// 带你装逼带不动你飞，  简单实用RunTime交换方法
class RunTimeViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let urlString = "http://www.163.com/中文"
        let _ = NSURL.init(string: urlString)
    }
    
    // MARK: - Action
    @IBAction func checkIsURL() {
        if (urlTextField.text?.isEmpty)! {
            self.showAlertWithMessage("请输入URL")
            return
        }
        
        let url = NSURL.init(string: urlTextField.text!)
        
        if url == nil {
            self.alert(msg: "URL是空")
        }
    }
    
    func alert(msg: String!) {
        let alertControler = UIAlertController(title: "提示", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertControler, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alertControler.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - UIViewController alerts options.
    func showAlertWithMessage(_ msg: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}

// MARK: - NSURL
extension NSURL  {
    override open class func initialize() {
        super.initialize()
        self.mg_SwitchMethod(cls: NSURL.self, originalSelector: #selector(NSURL.init(string:)), swizzledSelector: #selector(NSURL.MGURL(withStr:)))
    }

    func MGURL(withStr: String) -> URL? {
        let url = MGURL(withStr: withStr)
        if url == nil {
            print("URL是空")
        }
        
        return url
    }
    
    /**
     - parameter cls: : 当前类
     - parameter originalSelector: : 原方法
     - parameter swizzledSelector: : 要交换的方法
     */
    /// RunTime交换方法
//    static func mg_SwitchMethod(cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
//        let originalMethod = class_getInstanceMethod(cls, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
//        
//        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//        
//        if didAddMethod {
//            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    }
}




// MARK: - 给扩展动态添加属性，在OC中就是对应分类
var mg_keyBytesKey = "mg_keyBytesKey";
var mg_dataBytesKey = "mg_dataBytesKey";
extension Data {
    // MARK: - RunTime
    private struct DataKeys {
        static var mg_keyBytesKey = "mg_keyBytesKey"
        static var mg_dataBytesKey = "mg_dataBytesKey"
    }
    
    var keyBytes: UnsafeMutablePointer<DIR>! {
        get {
            return (objc_getAssociatedObject(self, &DataKeys.mg_keyBytesKey) as? UnsafeMutablePointer<DIR>!)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &DataKeys.mg_keyBytesKey, newValue as UnsafeMutablePointer<DIR>!, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    var dataBytes: UnsafeMutablePointer<DIR>! {
        get {
            return (objc_getAssociatedObject(self, &DataKeys.mg_dataBytesKey) as? UnsafeMutablePointer<DIR>!)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &DataKeys.mg_dataBytesKey, newValue as UnsafeMutablePointer<DIR>!, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

