//
//  XLCameraViewController.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/22.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

import AVFoundation

let WIDTH = UIScreen.main.bounds.width

let HEIGHT = UIScreen.main.bounds.height

class XLCameraViewController: UIViewController {
    
    // 音视频采集会话
    
    let captureSession = AVCaptureSession()
    
    // 后置摄像头
    var backFacingCamera: AVCaptureDevice?
    
    // 前置摄像头
    var frontFacingCamera: AVCaptureDevice?
    
    // 当前正在使用的设备
    var currentDevice: AVCaptureDevice?
    
    // 静止图像输出端
    var stillImageOutput: AVCaptureStillImageOutput?
    
    // 相机预览图层
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    /**
     *  记录开始的缩放比例
     */
    
    var beginGestureScale: CGFloat = 1.0
    /**
     * 最后的缩放比例
     */
    var effectiveScale: CGFloat = 1.0
    
    var toolView = CameraToolBarView()
    var timer: Timer?
    /** 焦点view */
    fileprivate lazy var focusView: UIView = {
        let focusView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        focusView.layer.borderWidth = 1.0
        focusView.layer.borderColor = UIColor.green.cgColor
        focusView.backgroundColor = UIColor.clear
        focusView.isHidden = true
        return focusView
    }()
    
    //照片拍摄后预览视图
    fileprivate lazy var clipView: PhotoClipView  = {
        let clipView = PhotoClipView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        return clipView
    }()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        // 创建拍照按钮
        self.createCameraTooBar()
        
        //获取设备，创建UI
        self.createUI()
        
        //给当前view创建手势
        self.setUpGesture()
        
    
        self.view.addSubview(focusView)
        setupFocusPointManual()
        
        timer = Timer.every(2.0) { [unowned self] in
            self.setupFocusPointManual()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if timer != nil {
            timer?.invalidate()
        }
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func setupFocusPointManual(isAuto: Bool = true) {
        if cameraPreviewLayer != nil {
            let point = CGPoint(x: MGScreenW / 2.0, y: 35 + (cameraPreviewLayer?.bounds.size.height)! / 2.0)
            focus(at: point,isAuto: isAuto)
        }
    }

    
    @objc fileprivate func focusGesture(_ gesture: UITapGestureRecognizer) {
        let point: CGPoint = gesture.location(in: gesture.view)
        let frame: CGRect = cameraPreviewLayer!.frame
        //去除预览区以外的点
        if (point.x >= frame.origin.x && point.x <= frame.origin.x + frame.size.width) && (point.y >= frame.origin.y && point.y <= frame.origin.y + frame.size.height) {
            focus(at: point,isAuto: false)
        }
    }
    
    func cameraSupportsTapToFocus() -> Bool {
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)?.isFocusPointOfInterestSupported ?? false
    }
    
    func focus(at point: CGPoint,isAuto: Bool = true) {
        guard let device: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        let size: CGSize = view.bounds.size
        let focusPoint = CGPoint(x: point.y / size.height, y: 1 - point.x / size.width)
        if try! device.lockForConfiguration() != nil {
            if device.isFocusPointOfInterestSupported {
                if device.isFocusModeSupported(.autoFocus) {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .autoFocus
                }
            }
            
            if device.isExposurePointOfInterestSupported {
                if device.isExposureModeSupported(.autoExpose) {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = .autoExpose
                }
            }
            device.unlockForConfiguration()
            if isAuto == false {
                focusView.center = point
                focusView.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {() -> Void in
                    self.focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                }, completion: {(_ finished: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        self.focusView.transform = .identity
                    }, completion: {(_ finished: Bool) -> Void in
                        self.focusView.isHidden = true
                    })
                })
            }
        }
    }
    
    //MARK: - 获取设备,创建自定义视图
    
    func createUI(){
        // 将音视频采集会话的预设设置为高分辨率照片--选择照片分辨率
        self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720
        
        // 获取设备
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for device in devices {
            if device.position == AVCaptureDevicePosition.back {
                self.backFacingCamera = device
            }else if device.position == AVCaptureDevicePosition.front {
                self.frontFacingCamera = device
            }
        }
        
        //设置当前设备为前置摄像头
        self.currentDevice = self.backFacingCamera
        
        do {
            // 当前设备输入端
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
            self.stillImageOutput = AVCaptureStillImageOutput()
            
            // 输出图像格式设置
            self.stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            self.captureSession.addInput(captureDeviceInput)
            
            self.captureSession.addOutput(self.stillImageOutput)
        }catch {
            print(error)
            return
        }
        
        // 创建预览图层
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.masksToBounds = true
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.cameraPreviewLayer?.frame = CGRect(x: 0, y: 0, width: MGScreenW, height: MGScreenH-82)
        self.view.layer.addSublayer(cameraPreviewLayer!)
       
        // 启动音视频采集的会话
        self.captureSession.startRunning()
        
        view.bringSubview(toFront: toolView)
    }
    
    //MARK: - 创建手势
    fileprivate func setUpGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.focusGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchGesture))
        pinch.delegate = self
        view.addGestureRecognizer(pinch)
    }
    
    func createCameraTooBar(){
        toolView.backgroundColor = UIColor.black
        toolView.delegate = self
        toolView.alpha = 0.8
        view.addSubview(toolView)
        
        toolView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(82)
        }
    }
    
    
    //照相按钮
    func takePhotoAction(){
        // 获得音视频采集设备的连接
        guard let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) else {
            debugPrint("拍照失败，请重试")
            return
        }
        let curDeviceOrientation: UIDeviceOrientation = UIDevice.current.orientation
        let avcaptureOrientation: AVCaptureVideoOrientation = avOrientation(for: curDeviceOrientation)
        videoConnection.videoOrientation = avcaptureOrientation
        videoConnection.videoScaleAndCropFactor = self.effectiveScale
        
        // 输出端以异步方式采集静态图像
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: {[unowned self] (imageDataSampleBuffer, error) -> Void in
            if imageDataSampleBuffer == nil {
                return
            }
            
            // 获得采样缓冲区中的数据
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            
            // 将数据转换成UIImage
            if let stillImage = UIImage(data: imageData!) {

                self.view.addSubview(self.clipView)
                self.clipView.image = stillImage
                //重新拍照
                self.clipView.remakeBlock = {() -> Void in
                    self.clipView.removeFromSuperview()
                    self.captureSession.startRunning()
                }
                //使用图片
                self.clipView.sureUseBlock = {(_ clipImage: UIImage) -> Void in
                    UIImageWriteToSavedPhotosAlbum(clipImage, nil, nil, nil)
                    self.dismiss(animated: true, completion: {() -> Void in
//                        if self.takePhotoBlock {
//                            self.takePhotoBlock(clipImage)
//                        }
                    })
                }
            }
        })
    }
    
    func avOrientation(for deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        var result: AVCaptureVideoOrientation? = AVCaptureVideoOrientation(rawValue: deviceOrientation.rawValue)
        if deviceOrientation == .landscapeLeft {
            result = .landscapeRight
        }
        else if deviceOrientation == .landscapeRight {
            result = .landscapeLeft
        }
        
        return result!
    }

    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer) {
        var msg: String? = nil
        if error != nil {
            msg = "保存图片失败"
        }
        else {
            msg = "保存图片成功"
        }
        print("\(String(describing: msg))")
    }
    
    // 重拍
    func cancelAction(){
        captureSession.startRunning()
    }
    
    //保存按钮-保存到相册
    func saveAction(){
        //保存照片到相册
//        UIImageWriteToSavedPhotosAlbum(self.photoImageview.image!, nil, nil, nil)
        self.cancelAction()
    }
}

extension XLCameraViewController: UIGestureRecognizerDelegate{
    
    //MARK: - 缩放手势 用于调整焦距
    func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        var allTouchesAreOnThePreviewLayer = true
        let numTouches: Int = recognizer.numberOfTouches
        for i in 0..<numTouches {
            let location: CGPoint = recognizer.location(ofTouch: i, in: view)
            let convertedLocation: CGPoint = cameraPreviewLayer!.convert(location, from: cameraPreviewLayer!.superlayer)
            if !cameraPreviewLayer!.contains(convertedLocation) {
                allTouchesAreOnThePreviewLayer = false
                break
            }
        }
        
        if allTouchesAreOnThePreviewLayer {
            effectiveScale = beginGestureScale * recognizer.scale
            if effectiveScale < 1.0 {
                effectiveScale = 1.0
            }
            print("effectiveScale=\(effectiveScale)-------------->beginGestureScale=\(beginGestureScale)------------recognizerScale=\(recognizer.scale)")
            let maxScaleAndCropFactor: CGFloat? = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo).videoMaxScaleAndCropFactor
        
            if effectiveScale > maxScaleAndCropFactor! {
                effectiveScale = maxScaleAndCropFactor!
            }
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.025)
            cameraPreviewLayer!.setAffineTransform(CGAffineTransform(scaleX: effectiveScale, y: effectiveScale))
            CATransaction.commit()
        }
        setupFocusPointManual(isAuto: false)
    }
    
    //MARK: - 切换摄像头
    func toggleCamera() {
        captureSession.beginConfiguration()
        
        let animation = CATransition()
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "oglFlip"
        
        if (currentDevice?.position == AVCaptureDevicePosition.back) {
             animation.subtype = kCATransitionFromRight;//动画翻转方向
        }else {
             animation.subtype = kCATransitionFromLeft;//动画翻转方向
        }
        // 在前置和后置之间切换摄像头
        let newDevice = (currentDevice?.position == AVCaptureDevicePosition.back) ? frontFacingCamera : backFacingCamera
        
        cameraPreviewLayer?.add(animation, forKey: nil)
        // 移除之前所有的输入会话
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }
        
        // 将输入端切换到新的采集设备
        let cameraInput: AVCaptureDeviceInput
        
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        }catch {
            print(error)
            return
        }
        
        // 添加输入端
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        currentDevice = newDevice
        cameraPreviewLayer!.transform = CATransform3DIdentity
        
        // 提交配置
        captureSession.commitConfiguration()
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {() -> Void in
            self.setupFocusPointManual(isAuto: false)
        })
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UIPinchGestureRecognizer) {
            self.beginGestureScale = self.effectiveScale
        }
        return true
    }

    //打开闪光灯
    func flashButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            //打开闪光灯
            let captureDevice: AVCaptureDevice? = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

            if captureDevice?.hasTorch ?? false {
                let locked: Bool = ((try? captureDevice?.lockForConfiguration()) != nil)
                if locked {
                    captureDevice?.torchMode = .on
                    captureDevice?.unlockForConfiguration()
                }
            }
        }
        else {
            //关闭闪光灯
            let device: AVCaptureDevice? = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            if device?.hasTorch ?? false {
                try? device?.lockForConfiguration()
                device?.torchMode = .off
                device?.unlockForConfiguration()
            }
        }
    }
}


extension XLCameraViewController: CameraToolBarViewDelegate {
    func cancel(_ toolBarView: CameraToolBarView, _ cancelBtn: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func takePhoto(_ toolBarView: CameraToolBarView, _ takePhotoBtn: UIButton) {
        takePhotoAction()
    }
    
    func switchCamera(_ toolBarView: CameraToolBarView, _ switchCameraBtn: UIButton) {
        toggleCamera()
    }
}


// 自动聚焦、曝光
//    func resetFocusAndExposureModes() -> Bool{
//        if let device: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) {
//            let exposureMode = AVCaptureExposureMode.autoExpose
//            let canResetExposure = device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode)
//
//
//            let focusMode = AVCaptureFocusMode.autoFocus
//            let canResetFocus = device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode)
//
//            let centerPoint = CGPoint(x: 0.5, y: 0.5)
//            do  {
//                try device.lockForConfiguration()
//                if canResetFocus {
//                    device.focusMode = focusMode
//                    device.focusPointOfInterest = centerPoint
//                }
//                if canResetExposure {
//                    device.exposureMode = exposureMode
//                    device.exposurePointOfInterest = centerPoint
//                }
//                device.unlockForConfiguration()
//                return true
//            }catch {
//                print("\(error)")
//                return false
//            }
//        }
//        return false
//    }
