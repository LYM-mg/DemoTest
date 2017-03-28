//
//  NSData+Extension.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

// MARK: - 加密  AES/AES128/DES/DES3/CAST/RC2/RC4/Blowfish......
/**  需在桥接文件导入头文件 ，因为C语言的库
 *   #import <CommonCrypto/CommonDigest.h>
 *   #import <CommonCrypto/CommonCrypto.h>
 */
enum CryptoAlgorithm {
    /// 加密的枚举选项 AES/AES128/DES/DES3/CAST/RC2/RC4/Blowfish......
    case AES, AES128, DES, DES3, CAST, RC2,RC4, Blowfish
    
    var algorithm: CCAlgorithm {
        var result: UInt32 = 0
            switch self {
            case .AES:          result = UInt32(kCCAlgorithmAES)
            case .AES128:       result = UInt32(kCCAlgorithmAES128)
            case .DES:          result = UInt32(kCCAlgorithmDES)
            case .DES3:         result = UInt32(kCCAlgorithm3DES)
            case .CAST:         result = UInt32(kCCAlgorithmCAST)
            case .RC2:          result = UInt32(kCCAlgorithmRC2)
            case .RC4:          result = UInt32(kCCAlgorithmRC4)
            case .Blowfish:     result = UInt32(kCCAlgorithmBlowfish)
        }
        return CCAlgorithm(result)
    }
    
    var keyLength: Int {
        var result: Int = 0
        switch self {
            case .AES:          result = kCCKeySizeAES128
            case .AES128:       result = kCCKeySizeAES256
            case .DES:          result = kCCKeySizeDES
            case .DES3:         result = kCCKeySize3DES
            case .CAST:         result = kCCKeySizeMaxCAST
            case .RC2:          result = kCCKeySizeMaxRC2
            case .RC4:          result = kCCKeySizeMaxRC4
            case .Blowfish:     result = kCCKeySizeMaxBlowfish
        }
        return Int(result)
    }
    
    var cryptLength: Int {
        var result: Int = 0
        switch self {
            case .AES:          result = kCCKeySizeAES128
            case .AES128:       result = kCCBlockSizeAES128
            case .DES:          result = kCCBlockSizeDES
            case .DES3:         result = kCCBlockSize3DES
            case .CAST:         result = kCCBlockSizeCAST
            case .RC2:          result = kCCBlockSizeRC2
            case .RC4:          result = kCCBlockSizeRC2
            case .Blowfish:     result = kCCBlockSizeBlowfish
        }
        return Int(result)
    }
}

// MARK: - 加密扩展NSData
extension NSData {
    /*
     加密
     - parameter algorithm: 加密方式
     - parameter keyData:   加密key
     
     - return NSData: 加密后的数据 可选值
     */
    func enCrypt(algorithm: CryptoAlgorithm, keyData:NSData) -> NSData? {
        return crypt(algorithm: algorithm, operation: CCOperation(kCCEncrypt), keyData: keyData)
    }
    
    /*
     解密
     - parameter algorithm: 解密方式
     - parameter keyData:   解密key
     
     - return NSData: 解密后的数据  可选值
     */
    func deCrypt(algorithm: CryptoAlgorithm, keyData:NSData) -> NSData? {
        return crypt(algorithm: algorithm, operation: CCOperation(kCCDecrypt), keyData: keyData)
    }
    
    
    /*
     解密和解密方法的抽取的封装方法
     - parameter algorithm: 何种加密方式
     - parameter operation: 加密和解密
     - parameter keyData:   加密key
     
     - return NSData: 解密后的数据  可选值
     */
    func crypt(algorithm: CryptoAlgorithm, operation:CCOperation, keyData:NSData) -> NSData? {
        let keyBytes        = keyData.bytes
        let keyLength       = Int(algorithm.keyLength)
        
        let dataLength      = self.length
        let dataBytes       = self.bytes
        
        let cryptLength     = Int(dataLength + algorithm.cryptLength)
        let cryptPointer    = UnsafeMutablePointer<UInt8>.allocate(capacity: cryptLength)
        
        let algoritm:  CCAlgorithm = CCAlgorithm(algorithm.algorithm)
        let option:   CCOptions    = CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding)
        
        let numBytesEncrypted = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        numBytesEncrypted.initialize(to: 0)
        
        let cryptStatus = CCCrypt(operation, algoritm, option, keyBytes, keyLength, nil, dataBytes, dataLength, cryptPointer, cryptLength, numBytesEncrypted)
        
        if CCStatus(cryptStatus) == CCStatus(kCCSuccess) {
            let len = Int(numBytesEncrypted.pointee)
            let data:NSData = NSData(bytesNoCopy: cryptPointer, length: len)
            
            numBytesEncrypted.deallocate(capacity: 1)
            return data
        } else {
            numBytesEncrypted.deallocate(capacity: 1)
            cryptPointer.deallocate(capacity: cryptLength)
            return nil
        }
    }
}


// MARK: - Data    Data打印出来是16或者32 bytes,打印需转成NSData类型打印结果比较直观
// MARK: - data
extension Data {
    /*
     加密
     - parameter algorithm: 加密方式
     - parameter keyData:   加密key
     
     - return NSData: 加密后的数据 可选值
     */
    mutating func enCrypt(algorithm: CryptoAlgorithm, keyData:Data) -> Data? {
        return crypt(algorithm: algorithm, operation: CCOperation(kCCEncrypt), keyData: keyData)
    }
    
    /*
     解密
     - parameter algorithm: 解密方式
     - parameter keyData:   解密key
     
     - return NSData: 解密后的数据  可选值
     */
    mutating func deCrypt(algorithm: CryptoAlgorithm, keyData:Data) -> Data? {
        return crypt(algorithm: algorithm, operation: CCOperation(kCCDecrypt), keyData: keyData)
    }
    
    
    /*
     解密和解密方法的抽取的封装方法
     - parameter algorithm: 何种加密方式
     - parameter operation: 加密和解密
     - parameter keyData:   加密key
     
     - return NSData: 解密后的数据  可选值
     */
    mutating func crypt(algorithm: CryptoAlgorithm, operation:CCOperation, keyData: Data) -> Data? {
        let keyLength       = Int(algorithm.keyLength)
        let dataLength      = self.count
        let cryptLength     = Int(dataLength+algorithm.cryptLength)
        let cryptPointer    = UnsafeMutablePointer<UInt8>.allocate(capacity: cryptLength)
        let algoritm:  CCAlgorithm = CCAlgorithm(algorithm.algorithm)
        let option:   CCOptions    = CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding)
        let numBytesEncrypted = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        numBytesEncrypted.initialize(to: 0)
        
        var keyBytes: UnsafePointer<Int8>?
        keyData.withUnsafeBytes {(bytes: UnsafePointer<Int8>)->Void in
             keyBytes = bytes
        }
        
        var dataBytes: UnsafePointer<Int8>?
        self.withUnsafeBytes {(bytes: UnsafePointer<CChar>)->Void in
//            print(bytes)
            dataBytes = bytes
        }
        
        let cryptStatus = CCCrypt(operation, algoritm, option, keyBytes!, keyLength, nil, dataBytes!, dataLength, cryptPointer, cryptLength, numBytesEncrypted)
        
        if CCStatus(cryptStatus) == CCStatus(kCCSuccess) {
            let len = Int(numBytesEncrypted.pointee)
            let data = Data.init(bytes: cryptPointer, count: len)
            numBytesEncrypted.deallocate(capacity: 1)
            return data
        } else {
            numBytesEncrypted.deallocate(capacity: 1)
            cryptPointer.deallocate(capacity: cryptLength)
            return nil
        }
    }
}


