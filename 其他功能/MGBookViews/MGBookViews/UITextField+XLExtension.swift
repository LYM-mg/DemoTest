//
//  UITextField+XLExtension.swift
//  LoanApp
//
//  Created by newunion on 2017/12/18.
//  Copyright © 2017年 Tassel. All rights reserved.
//

import UIKit

typealias CallBackBlock = ((Any)->())

extension UITextField {
    // 改进写法【推荐】
    fileprivate struct RuntimeKey {
        static let Right_Eye_CallBackBlock = UnsafeRawPointer.init(bitPattern: "Right_Eye_CallBackBlock".hashValue)
         static let Right_clear_CallBackBlock = UnsafeRawPointer.init(bitPattern: "Right_clear_CallBackBlock".hashValue)
        /// ...其他Key声明
    }
    
    func loadRightEyeButton() {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "user_password_hide"), for: .normal)
        eyeButton.setImage(UIImage(named: "user_password_show"), for: .selected)
        eyeButton.sizeToFit()
        eyeButton.addTarget(self, action: #selector(self.showHidePassword), for: .touchUpInside)
        rightView = eyeButton
        rightViewMode = .always
    }
    
    @objc func showHidePassword(_ sender: UIButton) {
        let text: String = self.text!
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = !sender.isSelected
        self.text = text
        let backBlock: CallBackBlock? = objc_getAssociatedObject(self, UITextField.RuntimeKey.Right_Eye_CallBackBlock!) as? CallBackBlock
        if backBlock != nil {
            backBlock!(sender.isSelected)
        }
    }
    
    func loadRightEyeButton(withCallBack backBlock: CallBackBlock?) {
        objc_setAssociatedObject(self, UITextField.RuntimeKey.Right_Eye_CallBackBlock!, backBlock, .OBJC_ASSOCIATION_RETAIN)
        loadRightEyeButton()
    }
    
    func loadRightClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "login_textField_clear"), for: .normal)
        //    [clearButton setImage:[UIImage new] forState:UIControlStateSelected];
        clearButton.sizeToFit()
        clearButton.addTarget(self, action: #selector(self.setClearInput), for: .touchUpInside)
        addTarget(self, action: #selector(textFieldChange(_:)), for: .editingChanged)
        rightView = clearButton
        rightViewMode = .whileEditing
    }

    @objc func setClearInput(_ btn: UIButton) {
        let inputStr: String = text!
        text = ""
        rightView?.isHidden = true
        let backBlock: CallBackBlock? = objc_getAssociatedObject(self, UITextField.RuntimeKey.Right_clear_CallBackBlock!) as? CallBackBlock
        if backBlock != nil {
            backBlock!(inputStr)
        }
    }
    
    func loadRightClearButton(withCallBack backBlock: CallBackBlock) {
         objc_setAssociatedObject(self, UITextField.RuntimeKey.Right_clear_CallBackBlock!, backBlock, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        loadRightClearButton()
    }
    
    @objc fileprivate func textFieldChange(_ textF: UITextField) {
        rightView?.isHidden = !textF.hasText
    }
}
