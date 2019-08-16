//
//  EncryptViewController.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/16.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class EncryptViewController: UIViewController {

    // MARK：- SB 属性
    @IBOutlet weak var originTetxView: UITextView! // 原始字符串
    @IBOutlet weak var encryptTextView: UITextView! // 加密后的字符串
    @IBOutlet weak var encryptTextField: UITextField! // 加密后的key
    
    
    var selectedAlgorithm: SymmetricCryptorAlgorithm = .des
    fileprivate var cypherText: Data = Data()
    var iv: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(EncryptViewController.AES加密))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func AES加密() {
        show(AESViewController(), sender: nil)
    }
}


// MARK：- Action
extension EncryptViewController {
    // 获取加密的key
    @IBAction func getEncryptKey() {
        let key = SymmetricCryptor.randomStringOfLength(selectedAlgorithm.requiredKeySize())
        self.encryptTextField.text = key
    }
    
    // 加密
    @IBAction func encodeEncrypt() {
        if originTetxView.text.count < 1 || (encryptTextField.text?.count)! < 1 {
            showAlertWithMessage("请输入要加密的字符或者key不能为空")
            return
        }
//      build cryptor
//      let options   kCCOptionPKCS7Padding : kCCOptionECBMode
        let cypher = SymmetricCryptor(algorithm: selectedAlgorithm, options: kCCOptionPKCS7Padding)
        setIV(cypher)
        do {
            cypherText = try cypher.crypt(string: originTetxView.text!, key: encryptTextField.text!)
            if let cypheredString = String(data: cypherText, encoding: String.Encoding.utf8) {
                encryptTextView.text = cypheredString
            } else {
                encryptTextView.text = cypherText.hexDescription 
            }
        }catch {
            self.showAlertWithMessage("不能够给这个东西加密. \(error). Try enabling PKCS7 padding.")
        }
    }
    
    // 解密
    @IBAction func decodeEncrypt() {
        if encryptTextView.text.count < 1 || (encryptTextField.text?.count)! < 0 {
            showAlertWithMessage("请输入至少一个字符.")
            return
        }
        //      let options   kCCOptionPKCS7Padding : kCCOptionECBMode
        let cypher = SymmetricCryptor(algorithm: selectedAlgorithm, options: kCCOptionPKCS7Padding)
        setIV(cypher)
        do {
            let encodeData = try cypher.decrypt(cypherText, key: encryptTextField.text!)
            if let encodeCypheredString = String(data: encodeData, encoding: String.Encoding.utf8) {
                 originTetxView.text = encodeCypheredString
            }else {
                originTetxView.text = "(Unable to generate a valid response string, probably wrong key or parameters, showing as Data instead): \(encodeData)"
            }
        }catch {
             self.showAlertWithMessage("不能解密. \(error)")
        }
    }

    
    func setIV(_ cypher: SymmetricCryptor) {
        if iv == nil {
            cypher.setRandomIV()
            iv = cypher.iv as Data?
        } else { cypher.iv = iv! }
    }
    
    // MARK: - UIViewController alerts options.
    func showAlertWithMessage(_ msg: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
