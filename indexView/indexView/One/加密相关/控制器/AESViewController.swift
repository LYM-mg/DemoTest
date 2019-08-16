//
//  AESViewController.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/20.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class AESViewController: UIViewController {
    fileprivate lazy var imageView: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
        img.center = CGPoint(x: MGScreenW/2, y: MGScreenH/2)
        img.isUserInteractionEnabled = true
        img.image = #imageLiteral(resourceName: "ming1")
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AESViewController.tapClick(_:))))
        return img
    }()
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.center = CGPoint(x: MGScreenW/2, y: MGScreenH/2)
        pageControl.isUserInteractionEnabled = true
        pageControl.numberOfPages = 4
        pageControl.tintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.brown
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.setValue(UIImage(named: "current"), forKey: "_currentPageImage")
        pageControl.setValue(UIImage(named: "other"), forKey: "_pageImage")
        pageControl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AESViewController.tapClick(_:))))
        return pageControl
    }()
    // 自定义属性
    fileprivate lazy var i: Int = 0
    var direction: UIPanGestureRecognizerDirection = .undefined
    fileprivate lazy var prePoint: CGPoint = .zero
    
    lazy var timer =  DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.main)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(imageView)
        
        let testAESBtn = UIButton(frame: CGRect(x: 0, y: 100, width: 70, height: 30))
        testAESBtn.backgroundColor = UIColor.magenta
        testAESBtn.center = CGPoint(x: MGScreenW/2, y: 85)
        testAESBtn.setTitle("测试", for: .normal)
        testAESBtn.addTarget(self, action: #selector(AESViewController.btnClick(_:)), for: .touchUpInside)
        view.addSubview(testAESBtn)
        
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(AESViewController.handlePanGesture(pan:))))
        imageView.addSubview(pageControl)
        pageControl.center = CGPoint(x: imageView.frame.size.width/2, y: imageView.frame.size.height-10)
        addTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.cancel()
    }
    deinit {
        print("AESViewController--deinit")
    }
    
    // 添加定时器
    fileprivate func addTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.main)
        timer.scheduleRepeating(deadline: .now(), interval: 5.0)
        timer.setEventHandler { [unowned self] in
            self.i += 1
            if self.i <= 0 {
                self.i = 4
            }
            if self.i > 4 {
                self.i = 1
            }
            self.pageControl.currentPage = self.i - 1
            let transition = CATransition()
            transition.duration = 1.5
            transition.type = CATransitionType(rawValue: "cameraIrisHollowClose")  // suckEffect  rippleEffect cameraIrisHollowOpen reveal
            transition.subtype = CATransitionSubtype.fromLeft
            self.imageView.layer.add(transition, forKey: nil)
            self.imageView.image = UIImage(named: "ming\(self.i)")
        }
        timer.resume()  //定时器开始激活
    }
    
    @objc fileprivate func moveLeft(_ tap: UISwipeGestureRecognizer) {
        i -= 1
        if i <= 0 {
            i = 4
        }
        transition(i: i)
    }
    @objc fileprivate func moveRight(_ tap: UISwipeGestureRecognizer) {
        i += 1
        if i > 4 {
            i = 1
        }
        transition(i: i)
    }
    func transition(i: Int) {
        self.pageControl.currentPage = i - 1
        let transition = CATransition()
        transition.type = CATransitionType(rawValue: "rippleEffect")   // rippleEffect
        transition.duration = 1.0
        imageView.layer.add(transition, forKey: nil)
        imageView.image = UIImage(named: "ming\(i)")
    }
    
    @objc fileprivate func tapClick(_ tap: UISwipeGestureRecognizer) {
        imageView.layer.removeAllAnimations()
        let transition = CATransition()
        if tap.location(in: tap.view).y > imageView.frame.size.height/2 {
            i -= 1
            transition.type = CATransitionType(rawValue: "pageCurl")
        } else {
            i += 1
            transition.type = CATransitionType(rawValue: "pageUnCurl")
        }
        
        
        if i <= 0 {
            i = 4
        }
        if i > 4 {
            i = 1
        }
        
        self.pageControl.currentPage = i - 1
        transition.duration = 1.5
        imageView.layer.add(transition, forKey: nil)
        imageView.image = UIImage(named: "ming\(i)")
    }
}


// MARK: - pan手势代替轻扫手势
enum UIPanGestureRecognizerDirection{
    case undefined,up,down,left,right
}

extension AESViewController {
    //加载手势
    @objc func handlePanGesture(pan: UIPanGestureRecognizer){
        switch(pan.state){
            case .began:
                  timer.suspend() // 暂停定时器
                prePoint = pan.location(in: pan.view!)
            case .changed:
                let curP = pan.location(in: pan.view!)
                let isVerticalGesture = fabs(curP.y) > fabs(prePoint.y)   // 上下之分
                let isHorizontalGesture = fabs(curP.x) > fabs(prePoint.x) // 左右之分
                let isHelpDirection = fabs((curP.y - prePoint.y)/(curP.x - prePoint.x)) <= 1
                if isHorizontalGesture &&  isHelpDirection{
                    direction = .right
                } else if !isHorizontalGesture && isHelpDirection {
                    direction = .left
                } else if isVerticalGesture && !isHelpDirection {
                    direction = .down
                } else if !isVerticalGesture && !isHelpDirection{
                    direction = .up
                }else {
                    direction = .undefined
                }
                break
            case .ended:
                switch direction {
                    case .up:
                        i += 1
                        handleUpwardsGesture()
                    case .down:
                        i -= 1
                        handleDownwardsGesture()
                    case .right:
                        i += 1
                        handleRightwardsGesture()
                    case .left:
                        i -= 1
                        handleLeftwardsGesture()
                    default:
                        break
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    self.timer.resume() //定时器继续执行；
                }
            default:
                break
            
        }
        if i <= 0 {
            i = 4
        }
        if i > 4 {
            i = 1
        }
        pageControl.currentPage = i - 1
        let transition = CATransition()
        transition.type = CATransitionType(rawValue: "rippleEffect")   // rippleEffect
        transition.duration = 1.0
        imageView.layer.add(transition, forKey: nil)
        imageView.image = UIImage(named: "ming\(i)")
    }
    
    fileprivate func handleUpwardsGesture() {
        print("Up")
    }
    
    fileprivate func handleDownwardsGesture() {
        print("Down")
    }
    fileprivate func handleRightwardsGesture() {
        print("Right")
    }
    fileprivate func handleLeftwardsGesture() {
        print("left")
    }
    
    // 轻扫手势
    func handleSwipeGesture(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(AESViewController.moveLeft(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        imageView.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(AESViewController.moveRight(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        imageView.addGestureRecognizer(rightSwipe)
    }
}



// MARK: - 测试
extension AESViewController {
    @objc fileprivate func btnClick(_ btn: UIButton) {
        self.view.endEditing(true)
        NSData.test()
        Data.test1()
    }
}

// MARK: - NSData测试
extension NSData{
    // AES128Crypt加密
    func AES128Crypt(operation:CCOperation,keyData:NSData) -> NSData? {
        
        let keyBytes        = keyData.bytes
        let keyLength       = Int(kCCKeySizeAES256)
        
        let dataLength      = self.length
        let dataBytes       = self.bytes
        
        let cryptLength     = Int(dataLength+kCCBlockSizeAES128)
        let cryptPointer    = UnsafeMutablePointer<UInt8>.allocate(capacity: cryptLength)
        
        let algoritm:  CCAlgorithm = CCAlgorithm(kCCAlgorithmAES128)
        let option:   CCOptions    = CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding)
        
        let numBytesEncrypted = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        numBytesEncrypted.initialize(to: 0)
        
        let cryptStatus = CCCrypt(CCOperation(operation), algoritm, option, keyBytes, keyLength, nil, dataBytes, dataLength, cryptPointer, cryptLength, numBytesEncrypted)
        
        if CCStatus(cryptStatus) == CCStatus(kCCSuccess) {
            let len = Int(numBytesEncrypted.pointee)
            let data:NSData = NSData(bytesNoCopy: cryptPointer, length: len)
            numBytesEncrypted.deallocate()
            return data
            
        } else {
            numBytesEncrypted.deallocate()
            cryptPointer.deallocate()
            return nil
        }
    }
    
    static func test(){
        let keyString     = "12345678901234567890123456789012"
        let keyData: NSData! = (keyString as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?
        let message       = "你是大傻瓜吗？你才是"
        let data: NSData! = (message as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?
        
        print("要加密的字符串：" + message)
        let result:NSData? = data.AES128Crypt(operation: CCOperation(kCCEncrypt), keyData: keyData)
        print("encrypt = \(result!)")
        
        let oldData = result!.AES128Crypt(operation: CCOperation(kCCDecrypt), keyData: keyData)
        print("decrypt = \(oldData!)")
        print(String(data: oldData as! Data, encoding: String.Encoding.utf8)!)
        
        
        
        let enData = data.enCrypt(algorithm: .AES, keyData: keyData)
        let deData = enData?.deCrypt(algorithm: .AES, keyData: keyData)
        print("通过解密后的字符串：" + String(data: deData as! Data, encoding: String.Encoding.utf8)!)
        let enData1 = data.enCrypt(algorithm: .DES, keyData: keyData)
        let deData1 = enData1?.deCrypt(algorithm: .DES, keyData: keyData)
        print("通过解密后的字符串：" + String(data: deData1 as! Data, encoding: String.Encoding.utf8)!)
        let enData2 = data.enCrypt(algorithm: .RC2, keyData: keyData)
        let deData2 = enData2?.deCrypt(algorithm: .RC2, keyData: keyData)
        print("通过解密后的字符串：" + String(data: deData2 as! Data, encoding: String.Encoding.utf8)!)
        print("enData-AES: + \(enData!)")
        print("enData-DES: + \(enData1!)")
        print("enData-RC2: + \(enData2!)")
        print("deData-AES: + \(deData!)")
        print("deData-DES: + \(deData1!)")
        print("deData-RC2: + \(deData2!)")
    }
}


// MARK: - Data测试
extension Data {
    static func test1(){
        let keyString        = "123"
        let message          = "you are so stuip"
        let keyData = keyString.data(using: String.Encoding.utf8)
        var data = message.data(using: String.Encoding.utf8)
        
        var result = data?.enCrypt(algorithm: CryptoAlgorithm.AES, keyData: keyData!)
        print("result = \(result!)")
        let data1 = NSData(data: result!)
        print(data1)
        print(NSString(data: result!, encoding: String.Encoding.utf8.rawValue))
        
        let oldData = result?.deCrypt(algorithm: CryptoAlgorithm.AES, keyData: keyData!)
        print("oldData = \(oldData! as NSData)")
        print(String(data: oldData!, encoding: String.Encoding.utf8)!)
    }
}





