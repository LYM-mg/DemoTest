//
//  ViewController.swift
//  coreData
//
//  Created by i-Techsys.com on 17/1/10.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    fileprivate lazy var tableView: UITableView = UITableView(frame: self.view.frame)
    
    @IBOutlet weak var textField: UITextField!
    var peoples = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        view.addSubview(tableView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(ViewController.saveClick))

        peoples = getPerson()
    }
    
    
    
    @objc func addClick() {
        let alertVC = UIAlertController(title: "新建联系人", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "请输入名字"
        }
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "请输入年龄"
            textfield.keyboardType = UIKeyboardType.numberPad
        }
        // 确定
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            let age = Int(arc4random_uniform(100))
//            self.storePerson(name: self.textField.text ?? "默认文字", age: age)
            let text = alertVC.textFields?.first?.text
            let ageText = alertVC.textFields?.last?.text
            self.storePerson(name: text ?? "明明就是你", age: Int(ageText ?? "0")!)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(sureAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc func saveClick() {
        let _ = getPerson()
    }
    
}

// MARK: - coreData
extension ViewController {
    /// 获取托管对象内容总管
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    /// 保存一条数据
    func storePerson(name:String, age: Int){
        let managerContext = getContext()
        // 定义一个entity，这个entity一定要在Xcdatamoded做好定义
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managerContext)
        let person = NSManagedObject(entity: entity!, insertInto: managerContext) as! Person
        person.setValue(name, forKey: "name")
        person.setValue(age, forKey: "age")
        
        peoples.append(person)
        try? managerContext.save()
    }
    
    /// 获取某一entity的所有数据
    func getPerson() -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let searchResults = try? getContext().fetch(fetchRequest)
        print("numbers of \(searchResults!.count)")
        for p in (searchResults as! [NSManagedObject]){
            print("name:  \(p.value(forKey: "name")!) age: \(p.value(forKey: "age")!)")
        }
        return searchResults as! [NSManagedObject]
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cellID")
        }
        let person = peoples[indexPath.row]
        cell?.textLabel?.text = person.value(forKey: "name") as? String
        cell?.detailTextLabel?.text = String(describing: person.value(forKey: "age")!)
        return cell!
    }
}

