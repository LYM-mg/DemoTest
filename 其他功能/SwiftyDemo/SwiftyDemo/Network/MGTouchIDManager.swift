//
//  MGTouchIDManager.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/12.
//  Copyright © 2019 firestonetmt. All rights reserved.
//

/// 指纹解锁
import UIKit
import LocalAuthentication

class MGTouchIDManager: NSObject {
    enum MGCheckResult: NSInteger {
        case success              //成功
        case failed               //失败
        case noSupport            //不支持
        case passwordNotSet       //未设置手机密码
        case touchidNotSet        //未设置指纹
        case touchidNotAvailable  //不支持指纹
        case cancleSys            //系统取消
        case canclePer            //用户取消
        case inputNUm             //输入密码
        case touchIDLockout       //输入次数过多验证被锁
    }

    static func userFingerprintTipStr(withtips tips:String, withIsPwdBtn:Bool , block : @escaping (_ result :MGCheckResult) -> Void){
        if #available(iOS 9.0, *) {
            //iOS 版本判断 低版本无需调用
            let context = LAContext()
            //创建一个上下文对象
            if !withIsPwdBtn {
                context.localizedFallbackTitle = "" //设置为空，再试一次的alertVC中没有右边的输入密码按钮
            }else {
                context.localizedFallbackTitle = "验证手势密码"
            }
            var error: NSError? = nil
            //捕获异常
            if(context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)){
                //判断当前设备是否支持指纹解锁
                //指纹解锁开始
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason:tips, reply: { (success, error) in
                    if(success){
                        if context.evaluatedPolicyDomainState != nil {
                            //指纹验证成功
                            print("指纹验证成功")
                            block(MGCheckResult.success)
                        }else{
                            print("系统密码输入成功")
                        }
                    }
                    else{
                        let laerror = error as! LAError
                        switch laerror.code {
                            case LAError.authenticationFailed:
                                print("连续三次输入错误，身份验证失败。")
                                block(MGCheckResult.failed)
                                break
                            case LAError.userCancel:
                                print("用户点击取消按钮。")
                                block(MGCheckResult.canclePer)
                                break
                            case LAError.userFallback:
                                print("用户点击输入密码。")
                                block(MGCheckResult.inputNUm)
                                break
                            case LAError.systemCancel:
                                print("系统取消")
                                block(MGCheckResult.cancleSys)
                                break
                            case LAError.passcodeNotSet:
                                print("用户未设置密码")
                                block(MGCheckResult.passwordNotSet)
                                break
                            case LAError.touchIDNotAvailable:
                                print("touchID不可用")
                                block(MGCheckResult.touchidNotAvailable)
                                break
                            case LAError.touchIDNotEnrolled:
                                print("touchID未设置指纹")
                                block(MGCheckResult.touchidNotSet)
                                break
                            case LAError.touchIDLockout:
                                print("touchID输入次数过多验证被锁")
                                block(MGCheckResult.touchIDLockout)
                                MGTouchIDManager.unlockTouchID()
                                break
                            default:
                                break
                        }
                    }
                })
            }else{
                print("不支持或者验证次数过多已被锁定");
                MGTouchIDManager.unlockTouchID()
            }
        }else {
            block(.noSupport)
        }
    }
    /// 检查手机 TouchID 功能是否开启或可以使用
    static var isSupportTouchID: Bool {
        get {
            let context = LAContext()
            var error :NSError?
            let isSupport = context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)
            //自定义的
            if #available(iOS 9.0, *) {
                return isSupport
            }
            else {
                //ios9以下
                return false
            }
        }
    }

    //解锁次数过多被锁之后，调用系统的开机解锁密码
    static func unlockTouchID() {
        let context = LAContext();
        var authError: NSError? = nil;
        if #available(iOS 9.0, *) {
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) { context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "需要您的密码，才能启用 Touch ID", reply: { (success, evaluateError) in
                if success {
                    // Touch ID 解锁成功

                }
            })
            }
        } else {
            //
        }
    }
}

