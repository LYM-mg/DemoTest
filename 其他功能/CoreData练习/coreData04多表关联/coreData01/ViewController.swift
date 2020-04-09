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
    // MARK: - 属性
    fileprivate lazy var tableView: UITableView = UITableView(frame: self.view.frame)
    
    @IBOutlet weak var textField: UITextField!
    weak var birthdayTextField: UITextField!
    fileprivate lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minuteInterval = 30
        datePicker.addTarget(self, action: #selector(ViewController.chooseDate), for: .valueChanged)
        return datePicker
    }()
    
    @objc fileprivate func chooseDate(datePicker: UIDatePicker) {
        let selectedDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: selectedDate)
        birthdayTextField.text = dateString
    }
    
    var peoples = [NSManagedObject]()
 
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        tableView.dataSource = self
        view.addSubview(tableView)

        peoples = getPerson()
        
        CoreDataHelper()
    }
}

// MARK: - 导航栏相关 以及 操作
extension ViewController {
    @IBAction func searchData(_ sender: UIBarButtonItem) {
        // 1.FetchRequest抓取请求对象
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        // 2.设置过滤条件
        let pre = NSPredicate(format: "depart.name=%@", "ios")
        fetchRequest.predicate = pre
        
        let searchResults = try? getContext().fetch(fetchRequest)
        print("numbers of \(searchResults!.count)")
        for p in (searchResults as! [Person]){
            print("name:  \(p.value(forKey: "name")!) 部门: \(p.depart!.name!)")
        }
    }
    
    @IBAction func getAllData(_ sender: UIBarButtonItem) {
        peoples = getPerson()
        tableView.reloadData()
        print(getPerson())
    }
    
    @IBAction func addClick(_ sender: AnyObject) {
        let alertVC = UIAlertController(title: "新建联系人", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "请输入名字"
        }
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "请输入身高"
            textfield.keyboardType = UIKeyboardType.numberPad
        }
        alertVC.addTextField { (textfield) in
            self.birthdayTextField = textfield
            textfield.placeholder = "请输入生日"
            textfield.inputView = self.datePicker
        }
        // 确定
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let text = alertVC.textFields?.first?.text
            let heightText = alertVC.textFields?[1].text
            let birthdayText = alertVC.textFields?[2].text
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let birthday = formatter.date(from: birthdayText!)
            self.storePerson(name: text ?? "明明就是你", height: Float(heightText ?? "0")!, birthday: birthday!)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(sureAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    // 创建部门
    @IBAction func creatDepart(_ sender: UIBarButtonItem) {
        let ios = NSEntityDescription.insertNewObject(forEntityName: "Department", into: getContext ())  as! Department
        ios.departNo = "100"
        ios.name = "JAVA"
        ios.creatDate = Date()
        
        let android = NSEntityDescription.insertNewObject(forEntityName: "Department", into: getContext ()) as! Department
        android.departNo = "101"
        android.name = "PHP"
        android.creatDate = Date()
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: getContext())
        let person = NSManagedObject(entity: entity!, insertInto: getContext()) as! Person
        person.name = "阿彬"
        person.height = 174
        person.depart = ios
        person.birthday = Date()
        
        let person2 = NSManagedObject(entity: entity!, insertInto: getContext()) as! Person
        person2.name = "阿三"
        person2.height = 168
        person2.depart = android
        person2.birthday = Date()
        
        try? getContext().save()
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
    func storePerson(name:String, height: Float ,birthday: Date){
        let managerContext = getContext()
        // 定义一个entity，这个entity一定要在Xcdatamoded做好定义
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managerContext)
        let person = NSManagedObject(entity: entity!, insertInto: managerContext) as! Person
        person.setValue(name, forKey: "name")
        person.setValue(birthday, forKey: "birthday")
        person.setValue(height, forKey: "height")
        
        peoples.append(person)
        try? managerContext.save()
    }
    
    /// 获取某一entity的所有数据
    func getPerson() -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let searchResults = try? getContext().fetch(fetchRequest)
        print("numbers of \(searchResults!.count)")
//        for p in (searchResults as! [NSManagedObject]){
//            print("name:  \(p.value(forKey: "name")!) age: \(p.value(forKey: "height")!) birthday: \(p.value(forKey: "birthday")!)" )
//        }
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

