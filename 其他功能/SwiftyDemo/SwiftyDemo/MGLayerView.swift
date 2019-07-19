//
//  CVLayerView.swift
//  XMLYFM
//
//  Created by Domo on 2018/8/16.
//  Copyright © 2018年 知言网络. All rights reserved.
//

import UIKit

class MGLayerView: UIView {
    var pulseLayer : CAShapeLayer!  // 定义图层
    var repeatCount: Float = HUGE   // 动画次数
    var animateDuration: TimeInterval = 3  // 动画时长
    var tapBlock:(()->())?          // 点击事件交互
    var shareColor = UIColor.init(r: 213/255.0, g: 54/255.0, b: 13/255.0) {
        didSet {
            pulseLayer.fillColor = shareColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //创建手势添加到视图上
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(click(_:)))
        self.addGestureRecognizer(tapGesture)

        let width = self.bounds.size.width
        let height = self.bounds.size.height

        // 动画图层
        pulseLayer = CAShapeLayer()
        pulseLayer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        pulseLayer.position = CGPoint(x: width/2, y: height/2)
        pulseLayer.backgroundColor = UIColor.clear.cgColor
        // 用BezierPath画一个原型
        pulseLayer.path = UIBezierPath(ovalIn: pulseLayer.bounds).cgPath
        // 脉冲效果的颜色  (注释*1)
        pulseLayer.fillColor = shareColor.cgColor
        pulseLayer.opacity = 0.0
        
        // 关键代码
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        replicatorLayer.position = CGPoint(x: width/2, y: width/2)
        replicatorLayer.instanceCount = 3  // 三个复制图层
        replicatorLayer.instanceDelay = 1  // 频率
        replicatorLayer.addSublayer(pulseLayer)
//        self.layer.addSublayer(replicatorLayer)
        self.layer.insertSublayer(replicatorLayer, at: 0)

        self.isUserInteractionEnabled = true
    }

    // MARK: - 点击
    //* 点击事件
    @objc func click(_ tapGesture: UITapGestureRecognizer?) {
        let touchPoint = tapGesture?.location(in: self)
        if (tapBlock != nil) {
            tapBlock!()
        }
        //遍历当前视图上的子视图的presentationLayer 与点击的点是否有交集
        if self.layer.presentation()?.hitTest(touchPoint ?? CGPoint.zero) != nil {
            print("点击的是：\(String(describing: touchPoint))")
        }
    }

    
    func starAnimation() {
        if let keys = pulseLayer.animationKeys(),
            keys.contains("KMGGroupAnimationKey") {
            pulseLayer.removeAnimation(forKey: "KMGGroupAnimationKey")
        }


        // 透明
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0  // 起始值
        opacityAnimation.toValue = 0     // 结束值
        
        // 扩散动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        let t = CATransform3DIdentity
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DScale(t, 0.0, 0.0, 0.0))
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DScale(t, 1.0, 1.0, 0.0))
        
        // 给CAShapeLayer添加组合动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [opacityAnimation,scaleAnimation]
        groupAnimation.duration = animateDuration   //持续时间
        groupAnimation.autoreverses = false         //循环效果
        groupAnimation.repeatCount = repeatCount
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        pulseLayer.add(groupAnimation, forKey: "KMGGroupAnimationKey")
    }

    /// 移除(停止)动画
    func stopAnimation() {
        if let keys = pulseLayer.animationKeys(),
            keys.contains("KMGGroupAnimationKey") {
            self.layer .removeAnimation(forKey: "KMGGroupAnimationKey")
        }
    }

    /// 暂停动画
    public func pauseAnimation() {
        self.pauseAnimate(layer: pulseLayer)
//        let pausetime = pulseLayer.convertTime(CACurrentMediaTime(), from: nil)
//        pulseLayer.timeOffset = pausetime
//        pulseLayer.speed = 0
//        print(#function)
//        print("pause time: \(pausetime)")
//        print("系统时钟： \(CACurrentMediaTime())")
//        print("以GMT为标准的，2001年一月一日00：00：00这一刻的时间绝对值: \(CFAbsoluteTimeGetCurrent())")
    }

    /// 恢复动画
    public func resumeAnimation() {
        self.resumeAnimate(layer: pulseLayer)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - 私有方法
    private func pauseAnimate(layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    private func resumeAnimate(layer: CALayer) {
        let pausedTime = layer.timeOffset
        if pausedTime == 0 {
            return
        }
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}
