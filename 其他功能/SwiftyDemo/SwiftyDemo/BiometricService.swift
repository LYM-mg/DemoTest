//
//  BiometricService.swift
//  ITService
//
//  Created by jiali on 2019/4/11.
//  Copyright © 2019 Dan Fu. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricServiceError{
    case notAvailable
    case touchIDLockout
    case biometryLockout
    case passcodeNotSet
    case biometryNotEnrolled
    case userFallback
    case systemCancel
    case authenticationFailed

    @available(iOS 11.0, *)
    case faceID
    @available(iOS 11.0, *)
    case touchID
}

open class BiometricService {
    
    let context = LAContext()
    var authError : NSError? = nil
    var localizedReason : String = ""
    static func share() ->  BiometricService{
        let shareInstance = BiometricService.init()
        shareInstance.loadAuthentication()
        return shareInstance
    }
    
    
    fileprivate func loadAuthentication() {
        context.localizedCancelTitle = "取消"
    }
    
    fileprivate func canSupportBiometric() -> Bool {
        //首先判断版本
        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0 {
            return false
        }
        return context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &authError)
    }
    
    func usesBiometric(success: @escaping(()->Void),failure:@escaping (_ error: BiometricServiceError?)-> Void) {
        if canSupportBiometric() {
            if #available(iOS 11.0, *) {
                if context.biometryType == .faceID{
                    localizedReason = "请验证面容ID"
                }else {
                    localizedReason = "请按Home键验证指纹"
                }
            } else {
                localizedReason = "请按Home键验证指纹"
            }
            self.biometricPolicy(successed: success, failure: failure)
        }else{
            //提示不可用
            dealErrorCode(authError, failure: failure)
        }
    }
    
    fileprivate func biometricPolicy(successed: @escaping(()->Void),failure:@escaping (_ error: BiometricServiceError?)-> Void) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) {[weak self] (success : Bool?, error : Error?) in
//            guard let `self` = self else{ return }
            if success == true {
                //成功
                DispatchQueue.main.async {
                    //  进行支付
                    successed()
                }
            }else{
                if let error = error as NSError?{
                    self?.dealErrorCode(error, failure: failure)
                }
            }
        }
    }
    
    fileprivate func dealErrorCode(_ error: NSError?,failure:@escaping (_ error: BiometricServiceError?)-> Void){
        guard let error = error else {
            // 设备不支持
            failure(BiometricServiceError.notAvailable)
            return;
        }
        switch error.code {
            case LAError.touchIDNotAvailable.rawValue:
                failure(BiometricServiceError.notAvailable)
            case LAError.touchIDLockout.rawValue:
                unLockOutTouchID()
                failure(BiometricServiceError.touchIDLockout)
                break
            case LAError.authenticationFailed.rawValue:
                DispatchQueue.main.async {
                    //认证失败，请输入支付密码支付
                    failure(BiometricServiceError.authenticationFailed)
                }
                break
            case LAError.passcodeNotSet.rawValue:
                 guideUserSettingTouchID()
                 failure(BiometricServiceError.passcodeNotSet)
                 break
            case LAError.systemCancel.rawValue:
                print("取消授权，如其他应用切入，用户自主")
                failure(BiometricServiceError.systemCancel)
                break
            case LAError.userFallback.rawValue:
                failure(BiometricServiceError.userFallback)
                DispatchQueue.main.async {
                    //用户选择其他验证方式
                }
                break
            default:
                if #available(iOS 11.0, *) {
                    if context.biometryType == LABiometryType.faceID{
                        failure(BiometricServiceError.faceID)
                        //设备不支持面容 ID
                    }else if context.biometryType == LABiometryType.touchID{
                        //设备不支持Touch ID
                        failure(BiometricServiceError.touchID)
                    }else if error.code == LAError.biometryNotEnrolled.rawValue {
                        // iPhone没录入指纹
                        guideUserSettingTouchID()
                        failure(BiometricServiceError.biometryNotEnrolled)
                    }else if error.code ==  LAError.biometryLockout.rawValue {
                        //验证手机锁屏密码，解锁指纹
                        failure(BiometricServiceError.biometryLockout)
                    }else {
                        //设备不支持Touch ID
                    }
                }
                break
            }
        }
    
    func guideUserSettingTouchID() {
        DispatchQueue.main.async {
            //引导用户跳转到设置去开启
        }
    }
    
    func unLockOutTouchID(){
        DispatchQueue.main.async {
            self.context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "验证手机锁屏密码解锁指纹", reply: { [weak self] (success : Bool?, error : Error?) in
                
                if success == true {
                    self?.loadAuthentication()
                }
            })
        }
    }
}
