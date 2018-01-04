//
//  CameraToolBarView.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/25.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

@objc protocol CameraToolBarViewDelegate: NSObjectProtocol {
    @objc optional func cancel(_ toolBarView: CameraToolBarView,_ cancelBtn: UIButton)
    @objc optional func retake(_ toolBarView: CameraToolBarView,_ retakeBtn: UIButton)
    @objc optional func takePhoto(_ toolBarView: CameraToolBarView,_ takePhotoBtn: UIButton)
    @objc optional func flash(_ toolBarView: CameraToolBarView,_ flashBtn: UIButton)
    @objc optional func switchCamera(_ toolBarView: CameraToolBarView,_ switchCameraBtn: UIButton)
}

class CameraToolBarView: UIView {
    //照相按钮
    var photoBtn:UIButton!
    //取消按钮/重拍
    var cancelBtn:UIButton!
    //保存按钮
    var switchCameraBtn:UIButton!
    
    var delegate: CameraToolBarViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setUpUI() {
        self.cancelBtn = UIButton(type: .custom)
//        cancelBtn.frame = CGRect(x: ((WIDTH / 2.0) - 30) / 2.0, y: (82 - 30) / 2.0, width: 50, height: 50)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.addTarget(self, action: #selector(self.cancelAction), for: .touchUpInside)
        cancelBtn.sizeToFit()
        self.addSubview(cancelBtn)
        
        self.photoBtn = UIButton(type: .custom)
        photoBtn.setTitle("拍照", for: .normal)
        photoBtn.setBackgroundImage(#imageLiteral(resourceName: "拍摄"), for: .normal)
//        photoBtn.frame = CGRect(x: (WIDTH - 50) / 2.0, y: (82 - 50) / 2.0, width: 50, height: 50)
        photoBtn.addTarget(self, action: #selector(self.takePhotoAction), for: .touchUpInside)
        //        photoBtn.setImage(UIImage(named: "cameraPhoto"), for: .normal)
        self.addSubview(photoBtn)
        
        self.switchCameraBtn = UIButton(type: .custom)
        switchCameraBtn.setTitle("切换", for: .normal)
        switchCameraBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        switchCameraBtn.addTarget(self, action: #selector(self.saveAction), for: .touchUpInside)
        switchCameraBtn.sizeToFit()
        self.addSubview(switchCameraBtn)
        
        // 闪光灯
//        let flashBtn = UIButton(type: .custom)
//        flashBtn.frame = CGRect(x: ((WIDTH / 2.0) - 30) / 2.0 + (WIDTH / 2.0), y: (82 - 30) / 2.0, width: 60, height: 30)
//        flashBtn.setTitle("闪光灯", for: .normal)
        //        lampBtn.setImage(UIImage(named: "openFlish"), for: .selected)
        //        lampBtn.setImage(UIImage(named: "closeFlish"), for: .normal)
//        flashBtn.addTarget(self, action: #selector(self.flashButtonClick), for: .touchUpInside)
//        self.addSubview(flashBtn)
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.centerY.equalToSuperview()
        }
        photoBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        switchCameraBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
        }
    }
    
    
    //取消按钮 ／重拍
    func cancelAction(){
        if delegate != nil,(delegate?.responds(to: #selector(CameraToolBarViewDelegate.cancel(_:_:))))! {
            delegate!.cancel!(self, cancelBtn)
        }
    }
    
    //保存按钮-保存到相册,使用照片
    func saveAction(){
        if delegate != nil,(delegate?.responds(to: #selector(CameraToolBarViewDelegate.switchCamera(_:_:))))! {
            delegate!.switchCamera!(self, switchCameraBtn)
        }
    }
    
    //照相按钮
    func takePhotoAction() {
        if delegate != nil,(delegate?.responds(to: #selector(CameraToolBarViewDelegate.takePhoto(_:_:))))! {
            delegate!.takePhoto!(self, photoBtn)
        }
    }
    
    //闪光灯按钮
    func flashButtonClick() {
        if delegate != nil,(delegate?.responds(to: #selector(CameraToolBarViewDelegate.flash(_:_:))))! {
//            delegate!.flash(self, flash)
        }
    }
}
