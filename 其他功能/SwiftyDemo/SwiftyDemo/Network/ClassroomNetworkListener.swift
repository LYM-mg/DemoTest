//
//  ClassroomNetworkManager.swift
//  Classroom
//
//  Created by jiali on 2019/4/10.
//  Copyright © 2019 Dan Fu. All rights reserved.
//

import UIKit

enum MGNetWorkStatus {
    case wifi
    case viaWWAN
    case noNetWork
    case other
}

protocol ClassRoomNetWorkListenerDelegate : NSObjectProtocol {
    func netWorkChanged(status:MGNetWorkStatus)
}

class ClassroomNetworkListener {

    static let listener = ClassroomNetworkListener()
    var delegates:[ClassRoomNetWorkListenerDelegate] = []
    let reach = Reachability()
    var reslut:((_ status: MGNetWorkStatus)->())?
    
    weak var delegate:ClassRoomNetWorkListenerDelegate?{
        didSet{
            if delegate != nil {
                delegates.append(delegate!)
            }
        }
    }

    convenience init(reslut:@escaping ((_ status: MGNetWorkStatus)->())) {
        self.init()
        self.reslut = reslut;
    }
    
    init() {
        starNotifier()
    }
    
   fileprivate func starNotifier() {
        do {
            try self.reach?.startNotifier()
        } catch {
            return
        }
    }
    
    class func removeListener(delegate:NSObject) {
        var index = 0
        for del in ClassroomNetworkListener.getInstance().delegates {
            let obj = del as! NSObject
            if obj == delegate {
                ClassroomNetworkListener.getInstance().delegates.remove(at: index)
                break
            }
            index += 1
        }
    }
    
    func starListener()  {
        NotificationCenter.default.addObserver(ClassroomNetworkListener.getInstance(), selector: #selector(ClassroomNetworkListener.change), name: Notification.Name.reachabilityChanged, object: nil)
    }

    func stopListener()   {
        reach!.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: nil)
    }
    
    @objc func change()  {
        for gate in delegates {
            gate.netWorkChanged(status:self.getCurrentNetWork())
        }
        if reslut != nil {
            reslut!(self.getCurrentNetWork())
        }
    }
    
    func getCurrentNetWork() -> MGNetWorkStatus {
        let status = reach!.connection
        if status == .cellular{
            return .viaWWAN
        }else if status == .wifi{
            return .wifi
        }else if status == .none{
            return .noNetWork
        }
        return .wifi
        
    }
    
    
    class func getInstance() -> ClassroomNetworkListener {
        return self.listener
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
