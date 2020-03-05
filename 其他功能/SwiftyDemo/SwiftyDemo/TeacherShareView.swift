//
//  TeacherShareView.swift
//  TeacherModule
//
//  Created by jiali on 2020/3/2.
//  Copyright © 2020 italki. All rights reserved.
//

import UIKit

final class TeacherShareView: UIView {

    @objc @IBOutlet weak var avatarImage: UIImageView!
    @objc @IBOutlet weak var flagImage: UIImageView!
    @objc @IBOutlet weak var teacherType: UILabel!
    @objc @IBOutlet weak var nickName: UILabel!
    @objc @IBOutlet weak var lessonNum: UILabel!
    @objc @IBOutlet weak var studentsNum: UILabel!
    
    @objc func updateUI() {
        
        
         teacherType.text = "职业教师"
         nickName.text = "辣手摧花"
        
        lessonNum.text = "0" + " 课时"
        studentsNum.text = "0" + " 学生"
    }
    
    func makeImageWithView() -> UIImage? {
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: currentContext)
        } else {
            return nil
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension TeacherShareView {
    @objc static func loadFromNib() -> TeacherShareView {
        let nib = UINib.init(nibName: "TeacherShareView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! TeacherShareView
    }
}
