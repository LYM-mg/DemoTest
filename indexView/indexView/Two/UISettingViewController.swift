//
//  UISettingViewController.swift
//  indexView
//
//  Created by i-Techsys.com on 2017/7/13.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// // app-Prefs:root=WIFI

import UIKit

class UISettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let url = URL(string: "App-Prefs:root=i-Techsys.com.indexView") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}

// MARK: - Action
extension UISettingViewController {
    @IBAction func 跳转到WIFI(_ sender: UIButton) {
        guard let url = URL(string: "App-Prefs:root=WIFI") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func 跳转到蜂窝移动网络(_ sender: UIButton) { // 无效
        guard let url = URL(string: "App-Prefs:root=MOBILE_DATA_SETTINGS_ID") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func 通用关于本机(_ sender: UIButton) {
        guard let url = URL(string: "App-Prefs:root=General&path=About") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func 墙纸(_ sender: UIButton) {
        guard let url = URL(string: "App-Prefs:root=Wallpaper") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func 照片与相机(_ sender: UIButton) {
        guard let url = URL(string: "App-Prefs:root=Photos") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func 通用语言与地区(_ sender: UIButton) {
        guard let url = URL(string: "App-Prefs:root=General&path=INTERNATIONAL") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func 蓝牙(_ sender: UIButton) {
        guard let url = URL(string: "App-Prefs:root=Bluetooth") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func 通用(_ sender: UIButton) {
        guard let url = URL(string: "App-Prefs:root=General") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}

/*
 无线局域网 App-Prefs:root=WIFI
 蓝牙 App-Prefs:root=Bluetooth
 蜂窝移动网络 App-Prefs:root=MOBILE_DATA_SETTINGS_ID
 个人热点 App-Prefs:root=INTERNET_TETHERING
 运营商 App-Prefs:root=Carrier
 通知 App-Prefs:root=NOTIFICATIONS_ID
 通用 App-Prefs:root=General
 通用-关于本机 App-Prefs:root=General&path=About
 通用-键盘 App-Prefs:root=General&path=Keyboard
 通用-辅助功能 App-Prefs:root=General&path=ACCESSIBILITY
 通用-语言与地区 App-Prefs:root=General&path=INTERNATIONAL
 通用-还原 App-Prefs:root=Reset
 墙纸 App-Prefs:root=Wallpaper
 Siri App-Prefs:root=SIRI
 隐私 App-Prefs:root=Privacy
 Safari App-Prefs:root=SAFARI
 音乐 App-Prefs:root=MUSIC
 音乐-均衡器 App-Prefs:root=MUSIC&path=com.apple.Music:EQ
 照片与相机 App-Prefs:root=Photos
 FaceTime App-Prefs:root=FACETIME
 */
