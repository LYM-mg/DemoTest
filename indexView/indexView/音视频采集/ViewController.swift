//
//  ViewController.swift
//  切换镜头&聚焦&写入文件
//
//  Created by i-Techsys.com on 16/12/1.
//  Copyright © 2016年 i-Techsys. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var videoOutput: AVCaptureVideoDataOutput?
    var videoInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var movieFileOutput: AVCaptureMovieFileOutput?
    // 1.创建捕捉会话
    lazy var session: AVCaptureSession? = AVCaptureSession()

    var closeBolck:(() ->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "需要真机测试"
        self.closeBolck = {
            print("dsadas")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func startSession(_ sender: UIButton) {
        if session == nil {
            self.showInfo(info: "session为nil")
            return
        }
        // 1.设置视频输入输出
        setupVideoSource(session: session!)
        
        // 2.添加文件输出
//        let movieFileoutput = AVCaptureMovieFileOutput()
//        self.movieFileOutput = movieFileoutput
//        session?.addOutput(movieFileoutput)
        // 获取视频的connection
//        let connection = movieFileoutput.connection(withMediaType: AVMediaTypeVideo)
        // 设置视频的稳定模式
//        connection?.preferredVideoStabilizationMode = .auto
        
        // 3.设置音频输入输出
        setupAudioSource(session: session!)
        
        #if TARGET_IPHONE_SIMULATOR  //模拟器
            self.showInfo(info: "需要真机测试,模拟器没有摄像头")
        #elseif TARGET_OS_IPHONE  //真机
            // 4.添加预览图层
            setupPreviewLayer(session: session!)
        
        
            // 5.开始扫描
            session?.startRunning()
        
            // 6.开始写入视频‘
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "ming.mp4"
//        movieFileOutput?.startRecording(toOutputFileURL: URL(string: path), recordingDelegate: self)
        #endif
    }

    @IBAction func stopVideo(_ sender: UIButton) {
        // 1.移除图层
        previewLayer?.removeFromSuperlayer()
        // 2.停止扫描
        session?.stopRunning()
        // 3.将对象重置为nil
        session = nil
        
        // 4.停止写入
//        movieFileOutput?.stopRecording()
    }
    
    
    @IBAction func switchScene(_ sender: UIButton) {
        // 0.执行动画
        let rotaionAnim = CATransition()
        rotaionAnim.type = "oglFlip"
        rotaionAnim.subtype = "fromLeft"
        rotaionAnim.duration = 0.5
        view.layer.add(rotaionAnim, forKey: nil)
        // 1.校验videoInput是否有值
        guard let videoInput = videoInput else { return }
        // 2.获取当前镜头
        let position : AVCaptureDevicePosition = videoInput.device.position == .front ? .back : .front
        // 3.创建新的input
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else { return }
        guard let newDevice = devices.filter({$0.position == position}).first else { return }
        guard let newVideoInput = try? AVCaptureDeviceInput(device: newDevice) else { return }
        // 4.移除旧输入，添加新输入
        session?.beginConfiguration()
        session?.removeInput(videoInput)
        session?.addInput(newVideoInput)
        session?.commitConfiguration()
        // 5.保存新输入
        self.videoInput = newVideoInput
    }

}


extension ViewController {
    // 给会话设置视频源（输入源&输出源）
    func setupVideoSource(session: AVCaptureSession) {
        // 1.创建输入
        // 1.1获取所有 的设备
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else {
            return
        }
        
        // 1.2取出前置摄像头
        guard let d = devices.filter({ $0.position == .front }).first else {
            self.showInfo(info: "需要真机测试,模拟器没有摄像头")
            return
        }
        
        
        // 1.3通过前置摄像头创建设备
        guard let videoInput = try? AVCaptureDeviceInput(device: d) else {
            return
        }
        self.videoInput = videoInput
        
        // 2.创建输出源
        // 2.1 创建视频输出源
        let videoOutput = AVCaptureVideoDataOutput()
         self.videoOutput = videoOutput
        
        // 2.2设置代理，以及代理方法的执行队列（在代理方法中拿到采集的数据）
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        // 3.添加输入输出到会话中
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        // 4.给connect赋值
        videoOutput.connection(withMediaType: AVMediaTypeVideo)
    }
    
    // 给会话设置音频源（输入源&输出源）
    fileprivate func setupAudioSource(session : AVCaptureSession) {
        // 1.创建输入
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) else { return }
        guard let audioInput = try? AVCaptureDeviceInput(device: device) else { return }
        // 2.创建输出源
        let audioOutput = AVCaptureAudioDataOutput()
        let queue = DispatchQueue.global()
        audioOutput.setSampleBufferDelegate(self, queue: queue)
        // 3.将输入&输出添加到会话中
        if session.canAddInput(audioInput) {
            session.addInput(audioInput)
        }
        if session.canAddOutput(audioOutput) {
            session.addOutput(audioOutput)
        }
    }
    
    fileprivate func setupPreviewLayer(session : AVCaptureSession) {
        // 1.创建预览图层
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: session) else { return }
        // 2.设置图层的属性
        previewLayer.frame = view.bounds
        self.previewLayer = previewLayer
        // 3.将图层添加到view中
        view.layer.insertSublayer(previewLayer, at: 0)
    }
}

extension ViewController : AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if connection == videoOutput?.connections.first!  as! AVCaptureConnection{
            print("视频数据")
        } else {
            print("音频数据")
        }
    }
}

extension ViewController : AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("开始录制")
    }
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("停止录制")
    }
}
