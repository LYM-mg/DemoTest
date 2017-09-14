//
//  ViewController.swift
//  Demo
//
//  Created by i-Techsys.com on 2017/8/11.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityField: UITextField!
    fileprivate lazy var pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.dataSource = self;
        pv.delegate = self;
        return pv
    }()
    
    /** 选中省 */
    var selectIndex:NSInteger = 0
    /** 城市数组 */
    fileprivate lazy var areaArray = LoadDataTool.loadAreaData()
    fileprivate lazy var titleLabel: UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(titleLabel)
        titleLabel.frame = CGRect(x: 120, y: 380, width: 200, height: 100)
        titleLabel.textColor = UIColor.gray
        self.view.addGestureRecognizer(UITapGestureRecognizer(actionBlock: { [unowned self](tap) in
            // 要执行的代码
            debugPrint("我被点击了----")
            let att = NSMutableAttributedString(string: "释放查看，的撒会单据号塞到好似符号ID师父hi第三方his地方很多看撒娇的接口", attributes: [NSVerticalGlyphFormAttributeName: 1, NSFontAttributeName: UIFont.systemFont(ofSize: 9), NSForegroundColorAttributeName: UIColor.red])
            self.titleLabel.attributedText = att
            self.titleLabel.transform = CGAffineTransform(rotationAngle: .pi/2)
        }))
        
        cityField.inputView = pickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.show(MGDateViewController(), sender: nil)
    }
}

// MARK: - UIPickerViewDataSource ,UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0) { // 选中省，直接返回省份的个数
            return self.areaArray.count;
        }else { // 选中城市，需要先知道你选中了哪个省，所以要先获得选中省的下标
            let area = self.areaArray[selectIndex]
            return area.son.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0) { // 选中省，直接返回省份的名称
            let area = self.areaArray[row]
            return area.title;
        }else { // 选中城市，根据当前选中哪个省来显示哪个城市
            let area = self.areaArray[selectIndex]
            return area.son[row].title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            // 标记当前选中了那个省；
            selectIndex = row;
            // 刷新第一列 也就是刷新城市
            pickerView.reloadComponent(1)
            // 默认刷新的城市选中第0行
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        // 选中第一列
        let area = self.areaArray[selectIndex]
        let cityIndex = pickerView.selectedRow(inComponent: 1)
        let cityName = area.son[cityIndex].title
        self.cityField.text = "\(area.title) \(cityName)"
    }
}
