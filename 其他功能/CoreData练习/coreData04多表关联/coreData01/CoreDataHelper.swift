//
//  CoreDataHelper.swift
//  coreData01
//
//  Created by i-Techsys.com on 17/1/15.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//  一般一个数据库对应一个上下文Context

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    // MARK: - 便利构造方法
    var modelName: String = ""   // 数据库的名称 默认是App的名称
    override init() {
        super.init()
        var bundlePath = Bundle.main.bundlePath
        bundlePath = bundlePath.components(separatedBy: "/").last!
        bundlePath = bundlePath.components(separatedBy: ".").first!
        modelName = bundlePath
    }
    
    convenience init(modelName: String) {
        self.init()
        self.modelName = modelName
    }
    
    // 这个目录用来存放应用程序Core Data存储文件，在当前事例中，会在应用程序的Document目录下生成名为“FoodPin.Coredata”文件。
    // MARK: - Core Data stack
    @available(iOS 10.0 , *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "self.modelName")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    //iOS9下的 Core Data stack
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.modelName + ".sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //iOS9下的 Core Data stack结束
    // MARK: - Core Data Saving support
    @available(iOS 10.0 , *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

