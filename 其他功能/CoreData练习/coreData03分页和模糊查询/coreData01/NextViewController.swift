//
//  NextViewController.swift
//  coreData01
//
//  Created by i-Techsys.com on 17/1/15.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import CoreData

class NextViewController: UIViewController {
    // MARK: - 属性
    @IBOutlet weak var tableView: UITableView!
    var peoples = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
    }
    

    fileprivate func getContext() -> NSManagedObjectContext{
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.persistentContainer.viewContext
    }
}

// MARK: - Action
extension NextViewController {
    // 分页查询
    @IBAction func pageSearch(_ sender: AnyObject) {
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        /*  
            第一页：0 - 6
            第二页：6 - 6
            第三页：12 - 6
         */
        fetchRequest.fetchOffset = 0        // 分页的起始索引
        fetchRequest.fetchLimit = 6         // 分页查询到数据的条数
//        fetchRequest.fetchBatchSize = 6     // 限制查询到哪里，默认是0代表无限，
        
        do {
           let results = try getContext().fetch(fetchRequest)
           print(results)
           peoples += results
           tableView.reloadData()
        }catch {
            print(error)
        }
    }
    
    // 包含查询
    @IBAction func containSearch(_ sender: AnyObject) {
        let request = NSFetchRequest<Person>(entityName: "Person")
        let sort = NSSortDescriptor(key: "name", ascending: true)  // 按名字升序排序
        request.sortDescriptors = [sort]
        let pre = NSPredicate(format: "name CONTAINS %@", "1")     // 按名字包含“1”的对象
        request.predicate = pre
        
        do {
            let results = try getContext().fetch(request)
            print(results)
            peoples = results
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    // 模糊查询
    @IBAction func blurSearch(_ sender: AnyObject) {
        let request = NSFetchRequest<Person>(entityName: "Person")
        let sort = NSSortDescriptor(key: "name", ascending: false)  // 按名字降序排序
        request.sortDescriptors = [sort]
        // (format: "name like %@", "xiao*")      // 按名字以“xiao”开头的对象
        // (format: "name like %@", "*xiao")      // 按名字以“xiao”结尾的对象
        let pre = NSPredicate(format: "name like %@", "xiao*")
        request.predicate = pre
        
        do {
            let results = try getContext().fetch(request)
            print(results)
            peoples = results
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    // 开头查询
    @IBAction func startSearch(_ sender: AnyObject) {
        let request = NSFetchRequest<Person>(entityName: "Person")
        let sort = NSSortDescriptor(key: "height", ascending: true)
        let pre = NSPredicate(format: "name BEGINSWITH %@", "小")   // 按名字以"小"开头的对象
        request.sortDescriptors = [sort]
        request.predicate = pre
        
        do {
            let results = try getContext().fetch(request)
            print(results)
            peoples = results
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    // 结尾查询
    @IBAction func endSearch(_ sender: AnyObject) {
        let request = NSFetchRequest<Person>(entityName: "Person")
        let pre = NSPredicate(format: "name ENDSWITH %@" , "红")         // 按名字以"红"结尾的对象
        let sort = NSSortDescriptor(key: "birthday", ascending: false)   // 按生日降序排序
        request.predicate = pre
        request.sortDescriptors = [sort]
        
        do {
            let results = try getContext().fetch(request)
            print(results)
            peoples = results
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
}


// MARK: - 数据源
extension NextViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellID")
        }
        let person = peoples[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell?.textLabel?.text = person.value(forKey: "name") as? String
        
        let birthdayDate = person.value(forKey: "birthday")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        cell?.detailTextLabel?.text = formatter.string(from: birthdayDate as! Date)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        label.text = String(describing: person.value(forKey: "height")!)
        cell?.accessoryView = label
        return cell!
    }
}
