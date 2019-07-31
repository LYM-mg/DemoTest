//
//  MGPhotoExtension.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

extension UIColor {

    /// 生成图片
    public var mg_image : UIImage {

        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}

extension Int {
    /// 将数据大小变为格式字符串
    public var mg_dataSize : String {

        guard self > 0 else {

            return ""
        }

        let unit = 1024.0

        guard Double(self) < unit * unit else {

            return String(format:"%.1fMB",Double(self) / unit / unit)
        }

        guard Double(self) < unit else {

            return String(format:"%.0fKB",Double(self) / unit)
        }

        return "\(self)B"
    }



    /// 16进制数值获得颜色
    public var mg_color : UIColor {

        guard self > 0 else {

            return UIColor.white
        }

        let red = (CGFloat)((self & 0xFF0000) >> 16) / 255.0
        let green = (CGFloat)((self & 0xFF00) >> 8) / 255.0
        let blue = (CGFloat)((self & 0xFF)) / 255.0


        if #available(iOS 10, *)
        {
            return UIColor(displayP3Red:red , green: green, blue: blue, alpha: 1.0)
        }

        guard #available(iOS 10, *) else {

            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }

        return UIColor.black
    }
}

extension TimeInterval {

    /// 将时间戳转换为当前的总时间，格式为00:00:00
    public var mg_time : String {

        let time : UInt = UInt(self)

        guard time < 60 * 60 else {

            let hour = String(format: "%.2d",time / 60 / 60)
            let minute = String(format: "%.2d",time % 3600 / 60)
            let second = String(format: "%.2d",time % (3600 * 60))

            return "\(hour):\(minute):\(second)"
        }


        guard time < 60 else {

            let minute = String(format:"%.2d",time / 60)
            let second = String(format:"%.2d",time % 60)

            return "\(minute):\(second)"
        }


        return "00:\(String(format:"%.2d",time))"
    }
}




struct MGPhotosAssociateHandle {
    static let MG_ControlHandleValue = UnsafeRawPointer(bitPattern: "MG_ControlHandleValue".hashValue)
    static let MG_GestureHandleValue = UnsafeRawPointer(bitPattern: "MG_GestureHandleValue".hashValue)
}

// MARK: Control
typealias MGControlActionClosure = ((UIControl)->Void)

extension UIControl {
    // MARK: public
    func action(at state:UIControl.Event,handle:MGControlActionClosure?)
    {
        guard let actionHandle = handle else { return }

        objc_setAssociatedObject(self, MGPhotosAssociateHandle.MG_ControlHandleValue!, actionHandle, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)

        self.addTarget(self, action: #selector(UIControl.MG_actionHandle), for: state)
    }


    // MARK: private
    @objc fileprivate func MG_actionHandle()
    {
        guard let actionHandle = objc_getAssociatedObject(self, MGPhotosAssociateHandle.MG_ControlHandleValue!) else { return }
        (actionHandle as! MGControlActionClosure)(self)
    }
}



typealias MGGestureClosure = ((UIGestureRecognizer) -> Void)

extension UIGestureRecognizer
{

    /// 用于替代目标动作回调的方法
    ///
    /// - Parameter handle: 执行的闭包
    func action(_ handle:MGGestureClosure?)
    {
        guard let handle = handle else {

            return
        }

        //缓存
        objc_setAssociatedObject(self, MGPhotosAssociateHandle.MG_GestureHandleValue!, handle, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)

        //添加
        self.addTarget(self, action: #selector(UIGestureRecognizer.MG_actionHandle))
    }


    @objc fileprivate func MG_actionHandle()
    {
        //执行
        (objc_getAssociatedObject(self, MGPhotosAssociateHandle.MG_GestureHandleValue!) as! MGGestureClosure)(self)

    }
}




// MARK: UIMenuItem
typealias XJLMenuItemActionClosure = ((UIMenuItem)->Void)
extension UIMenuItem {
    struct XJLMenuItemAssociateHandle {
        static let XJL_MenuItemHandleValue = UnsafeRawPointer(bitPattern: "XJL_MenuItemHandleValue".hashValue)
    }
    /// 用于替代目标动作回调的方法
    ///
    /// - Parameter handle: 执行的闭包
    class func action(_ title: String,_ handle:@escaping XJLMenuItemActionClosure) -> UIMenuItem{
        //缓存
        objc_setAssociatedObject(self, XJLMenuItemAssociateHandle.XJL_MenuItemHandleValue!, handle, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)

        //添加
        return UIMenuItem(title: title, action: #selector(XJL_actionHandle(_:)))
//        self.addTarget(self, action: #selector(UIGestureRecognizer.MG_actionHandle))
    }


    @objc fileprivate func XJL_actionHandle(_ menu:UIMenuItem) {
        //执行
        (objc_getAssociatedObject(self, XJLMenuItemAssociateHandle.XJL_MenuItemHandleValue!) as! XJLMenuItemActionClosure)(menu)

    }
}
