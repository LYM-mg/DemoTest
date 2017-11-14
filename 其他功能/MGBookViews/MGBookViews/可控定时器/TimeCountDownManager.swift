//
//  TimeCountingDownTaskBlock.swift
//  MGBookViews
//
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

/// 计时中回调
typealias TimeCountingDownTaskBlock = (_ timeInterval: TimeInterval) -> Void
// 计时结束后回调
typealias TimeFinishedBlock = (_ timeInterval: TimeInterval) -> Void


/// TimeCountDownManager是定时器管理类，是个单利，通过pool可以管理app中所有需要倒计时的task
class TimeCountDownManager: NSObject {
    // 单行单利
    static let manager = TimeCountDownManager()

    var pool: OperationQueue

    override init() {
        pool = OperationQueue()
        super.init()
    }

    /**
    *  开始倒计时，如果倒计时管理器里具有相同的key，则直接开始回调。
    *
    *  @param aKey         任务key，用于标示唯一性
    *  @param timeInterval 倒计时总时间，受操作系统后台时间限制，倒计时时间规定不得大于 120 秒.
    *  @param countingDown 倒计时时，会多次回调，提供当前秒数
    *  @param finished     倒计时结束时调用，提供当前秒数，值恒为 0
    */
    func scheduledCountDownWith(_ key: String, timeInteval: TimeInterval, countingDown:TimeCountingDownTaskBlock?,finished:TimeFinishedBlock?) {
        var task: TimeCountDownTask?
        if coundownTaskExistWith(key, task: &task) {
            task?.countingDownBlcok = countingDown
            task?.finishedBlcok = finished
            if countingDown != nil {
                countingDown!((task?.leftTimeInterval)!)
            }
        } else {
            task = TimeCountDownTask()
            task?.leftTimeInterval = timeInteval
            task?.countingDownBlcok = countingDown
            task?.finishedBlcok = finished
            task?.name = key

            pool.addOperation(task!)
        }
    }

    /**
    *  查询倒计时任务是否存在
    *
    *  @param akey 任务key
    *  @param task 任务
    *  @return YES - 存在， NO - 不存在
    */
    fileprivate func coundownTaskExistWith(_ key: String,task: inout TimeCountDownTask? ) -> Bool {
        var taskExits = false

        for (_, obj)  in pool.operations.enumerated() {
          let temptask = obj as! TimeCountDownTask
          if temptask.name == key {
                task = temptask
                taskExits = true
                MGLog("#####\(temptask.leftTimeInterval)")
                break
          }
        }
        return taskExits
    }
    
    // MARK: - 单个操作
    ///  暂停指定倒计时任务
    ///
    /// - Parameter key: 任务key
    /// - Returns: 有这个任务返回true；否则，返回false
    func pauseOneTask(key: String)  -> Bool {
        for (_, obj)  in pool.operations.enumerated() {
            let task = obj as! TimeCountDownTask
            let taskName = task.name ?? ""
            if taskName == key {
                task.isSuppend = true
                return true
            }
        }
        return false
    }

    ///  恢复指定倒计时任务
    ///
    /// - Parameter key: 任务key
    /// - Returns: 有这个任务返回true；否则，返回false
    func suspendOneTask(key: String) -> Bool {
        for (_, obj)  in pool.operations.enumerated() {
            let task = obj as! TimeCountDownTask
            let taskName = task.name ?? ""
            if taskName == key {
                task.isSuppend = false
                return true
            }
        }
        return false
    }
    
    ///  取消指定任务的倒计时任务
    ///
    /// - Parameter key: 任务key
    /// - Returns: 有这个任务取消定时器，返回true，否则，返回false
    func cancelOneTask(_ key: String)  -> Bool {
        for operation in pool.operations {
            let task = operation as! TimeCountDownTask
            let taskName = task.name ?? ""
            if taskName == key {
                task.cancel()
                return true
            }
        }
        return false
    }

    // MARK: - 所有操作
    /**
     *   暂停所有倒计时⏳任务
     */
    func pauseAllTask() {
        for (_, obj)  in pool.operations.enumerated() {
            let temptask = obj as! TimeCountDownTask
            temptask.isSuppend = true
        }
    }
    
    /**
     *   恢复所有倒计时任务
     */
    func suspendAllTask() {
        for (_, obj)  in pool.operations.enumerated() {
            let temptask = obj as! TimeCountDownTask
            temptask.isSuppend = false
        }
    }
    
    /**
      *  取消所有倒计时任务
      */
    func cancelAllTask() {
        pool.cancelAllOperations()
    }
}


/// TimeCountDownTask是具体的用来处理倒计时的NSOperation子类，可以暂停和取消定时器。比如cancel具体taskIdentifier的task，suspended具体的task，pause具体的task，cancel具体的task，等等！
class TimeCountDownTask: Operation {
    var taskIdentifier: UIBackgroundTaskIdentifier = -1
    var leftTimeInterval: TimeInterval = 0 // ⏳定时时长
    var countingDownBlcok: TimeCountingDownTaskBlock?// ⏳每一秒定时器处理的回调
    var finishedBlcok: TimeFinishedBlock?  // 倒计时⏳为0时的回调
    var isSuppend: Bool = false  // 主要来控制是否暂停定时器

    override func main() {
        if self.isCancelled {
            return
        }
        taskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)

        while leftTimeInterval > 0 {
            if self.isCancelled {
                return
            }
            
            if (isSuppend) { // 暂停了就跳过下列循环
                continue
            }
            
            MGLog("----\(leftTimeInterval)")
            MGLog(self.isExecuting)
            
            DispatchQueue.main.async(execute: {
                if self.countingDownBlcok != nil {  // ⏳每一秒定时器处理的回调
                    self.countingDownBlcok!(self.leftTimeInterval)
                }
                self.leftTimeInterval -= 1
            })

           Thread.sleep(forTimeInterval: 1)
        }

        DispatchQueue.main.async {
            if self.isCancelled {
                return
            }
            
            if self.finishedBlcok != nil { // 倒计时⏳为0时的回调
                if self.leftTimeInterval == 0 {
                    self.finishedBlcok!(0)
                }
            }
        }

        if taskIdentifier != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(taskIdentifier)
            taskIdentifier = UIBackgroundTaskInvalid
        }
    }
}

