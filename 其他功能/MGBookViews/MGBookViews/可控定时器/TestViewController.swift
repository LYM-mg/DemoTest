//
//  TestViewController.swift
//  MGBookViews
//
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var timecountDown10: UIButton!
    @IBOutlet weak var timecountDown30: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 10秒的倒计时⏳
    @IBAction func countDown(_ sender: UIButton) {
        TimeCountDownManager.manager.scheduledCountDownWith("button1", timeInteval: 10, countingDown: { (timeInterval) in
            MGLog(timeInterval)
            sender.titleLabel?.text = "剩余\(Int(timeInterval))s"
            sender.isEnabled = false
            }) { (timeInterval) in // 倒计时为0执行操作
                sender.isEnabled = true
        }
    }
    
    // 30秒的倒计时⏳
    @IBAction func countDown2(_ sender: UIButton) {
        TimeCountDownManager.manager.scheduledCountDownWith("button2", timeInteval: 30, countingDown: { (timeInterval) in
            sender.titleLabel?.text = "剩余\(Int(timeInterval))s"
            sender.isEnabled = false
        }) { (timeInterval) in
            sender.isEnabled = true
        }
    }

    // 暂停按钮的点击 （30秒的倒计时⏳）
    @IBAction func pauseOne(_ sender: UIButton) {
        if TimeCountDownManager.manager.pauseOneTask(key: "button2") {
            
        }else {
            MGLog("没有该task")
        }
    }
    
    // 恢复按钮的点击 （30秒的倒计时⏳）
    @IBAction func continueTIme(_ sender: UIButton) {
        if TimeCountDownManager.manager.suspendOneTask(key: "button2") {
            
        }else {
            MGLog("定时器未启动")
            MGLog("没有该task")
        }
    }
    
    // 停止一个定时器 （30秒的倒计时⏳）
    @IBAction func stopOneTask(_ sender: UIButton) {
        if TimeCountDownManager.manager.cancelOneTask("button2") {
            timecountDown30.titleLabel?.text = "点击倒计时30"
            timecountDown30.isEnabled = true
        }else {
            MGLog("没有找到该定时器")
        }
    }
    
     // 全部暂停（所有倒计时⏳）
    @IBAction func allPause(_ sender: UIButton) {
        TimeCountDownManager.manager.pauseAllTask()
    }
    
    // 全部停止（所有倒计时⏳）
    @IBAction func stopAll(_ sender: AnyObject) {
        timecountDown30.titleLabel?.text = "点击倒计时30"
        timecountDown30.isEnabled = true
        timecountDown10.titleLabel?.text = "点击倒计时10"
        timecountDown10.isEnabled = true
        TimeCountDownManager.manager.cancelAllTask()
    }
    
    // 全部继续（所有倒计时⏳）
    @IBAction func allContinue(_ sender: UIButton) {
        TimeCountDownManager.manager.suspendAllTask()
    }
    
    
    deinit {
        print("deinit")
    }
}
