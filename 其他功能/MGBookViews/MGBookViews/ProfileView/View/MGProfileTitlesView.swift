//  MGProfileTitlesView.swift
//  MGBookViews
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// https://github.com/LYM-mg
// http://www.jianshu.com/u/57b58a39b70e

import UIKit
import SnapKit

class MGProfileTitlesView: UIView {
    
    var titles = [String]() {
        didSet {
            let _ = subviews.map {
                $0.removeFromSuperview()
            }

            let width: CGFloat = UIScreen.main.bounds.size.width / CGFloat(titles.count)
            for i in 0..<titles.count {
                let titleButton: UIButton = self.titleButton(titles[i])
                titleButton.tag = i
                titleButton.backgroundColor = UIColor.mg_randomColor()
                addSubview(titleButton)
                titleButton.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: MGTitleHeight)
                if i != 0 {
                    titleButton.isSelected = true
                }else {
                    selectedButton = titleButton
                }
            }
            let button: UIButton? = subviews[0] as? UIButton
            let title: String = titles[0]
            let sliderWidth: CGFloat = (button!.titleLabel?.font?.pointSize)! * CGFloat(title.characters.count)
            addSubview(sliderView)
            sliderView.frame = CGRect(x: 0, y: MGTitleHeight-2, width: sliderWidth, height: 2)
            sliderView.center = CGPoint(x: (button?.center.x)!, y:  MGTitleHeight-sliderView.frame.height)
        }
    }
    var buttonSelected: ((_ index: Int) -> Void)? = nil
    
    var selectedIndex: Int = 0
    
    func setSelectedIndex(selectedIndex: Int) {
        self.selectedIndex = selectedIndex
        let button: UIButton? = subviews[selectedIndex] as? UIButton
        titleButtonClicked(button!)
    }
    
    
    lazy var sliderView: UIView = {
        let sliderView = UIView()
        sliderView.backgroundColor = UIColor.red
        sliderView.layer.cornerRadius = 2
        sliderView.clipsToBounds = true
        return sliderView
    }()
    lazy var selectedButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sliderView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 按钮点击
    func titleButtonClicked(_ button: UIButton) {
        selectedIndex = button.tag
        selectedButton.isSelected = true
        button.isSelected = false
        selectedButton = button
        if (buttonSelected != nil) {
            buttonSelected!(button.tag)
        }
        
        let title: String = titles[button.tag]
        let sliderWidth: CGFloat = (button.titleLabel?.font?.pointSize)! * CGFloat(title.characters.count)
        UIView.animate(withDuration: 0.25) { 
            self.sliderView.frame = CGRect(x: 0, y: MGTitleHeight-2, width: sliderWidth, height: 2)
            self.sliderView.center = CGPoint(x: button.center.x, y: MGTitleHeight-self.sliderView.frame.height)
        }
    }
    
    func titleButton(_ title: String) -> UIButton {
        let titleButton = UIButton()
        titleButton.addTarget(self, action: #selector(self.titleButtonClicked), for: .touchUpInside)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        titleButton.setTitleColor(UIColor.red, for: .normal)
        titleButton.setTitleColor(UIColor.gray, for: .selected)
        titleButton.setTitle(title, for: .normal)
        return titleButton
    }
    
    
    override func draw(_ rect: CGRect) {
        makelineStartPoint(sliderView.bottom, andEndPoint: sliderView.bottom)
        makelineStartPoint(selectedButton.top, andEndPoint: selectedButton.top)
//        makelineStartPoint(sliderView.frame.maxY, andEndPoint: sliderView.frame.maxY)
//        makelineStartPoint(selectedButton.frame.minY, andEndPoint: selectedButton.frame.minY)
    }
    
    func makelineStartPoint(_ statPoint: CGFloat, andEndPoint endPoint: CGFloat) {
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return }
        context.setLineCap(.round)
        context.setLineWidth(0.5)
        //线宽
        context.setAllowsAntialiasing(true)
        context.setStrokeColor(UIColor.gray.cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: statPoint))
        //起点坐标
        context.addLine(to: CGPoint(x: frame.size.width, y: endPoint))
        //终点坐标
        context.strokePath()
    }
}



extension UIView {
//    var bottom: CGFloat {
//        get {
//           return self.frame.origin.y + self.frame.size.height
//        }set {
//            var newframe = self.frame;
//            newframe.origin.y = newValue - self.frame.size.height;
//            self.frame = newframe;
//        }
//    }
//    
//    var top: CGFloat {
//        get {
//            return self.frame.origin.y
//        }set {
//            var newframe = self.frame;
//            newframe.origin.y = newValue
//            self.frame = newframe;
//        }
//    }
}
