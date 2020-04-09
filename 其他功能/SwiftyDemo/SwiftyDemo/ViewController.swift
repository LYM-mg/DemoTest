//
//  ViewController.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/3/26.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

#if DEBUG // 调试

#else     // 其他环境

#endif

class ViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var ceshiLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    lazy var players: NSMutableArray = {
       var temporaryPlayers = NSMutableArray()
        temporaryPlayers.add("jiali,Mike Buss")
        return temporaryPlayers
    }()

    lazy var players1:[String] = {
        var temporaryPlayers = [String]()
        temporaryPlayers.append("jiali,Mike Buss")
        return temporaryPlayers
    }()

    lazy var players2 = { () -> [String] in
        var temporaryPlayers = [String]()
        temporaryPlayers.append("jiali,Mike Buss")
        return temporaryPlayers
    }
    
    func ceshi() {
        var testString = "I am China form Beijing, you are going to eat dinna,wha is it, it is very delicidious. hello,I usually like to play basketball"
        let audio = "[audio]"

        var totalAStr = ""
        totalAStr = testString + audio
        tipLabel.text = totalAStr
        ceshiLabel.text = totalAStr
        
        let number = tipLabel.needLines(withWidth: tipLabel.frame.size.width)
        if number > 2{
            let totalEndIndex = ceshiLabel.getSeparatedLines(from: ceshiLabel)
            var finallyText = ceshiLabel.text!
            finallyText = finallyText.subString(from: 0, to: (totalEndIndex - 5 - 5 - audio.count))
            finallyText += " ... \(audio)"
            ceshiLabel.text = finallyText
        }else {
            
        }
        print("行数：\(number)")
        
//        print("calculateNewline行数：\(calculateNewline(totalAStr))")
    }
    
//    func calculateNewline(_ str: String?) -> Int {
//
//        let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tipLabel.frame.size.width, height: 0))
//        tempLabel.text = str // ?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//
//        let constrain = CGSize(width: tempLabel.bounds.size.width, height: CGFloat(MAXFLOAT))
//
//
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.lineBreakMode = .byCharWrapping
//        let attribute = [
//            NSAttributedString.Key.paragraphStyle: paragraph
//        ]
//        let retSize = tempLabel.text?.boundingRect(with: constrain, options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading,.usesDeviceMetrics], attributes: attribute, context: nil).size
//
//        let lineNumbers = ceil((retSize?.height ?? 0.0) / tempLabel.font.lineHeight)
//
//        return Int(lineNumbers)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let ivarsNames = self.ClassIvarsNames(c: UIView.self)
        print(ivarsNames)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(self.leftClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.rightClick))
        let btn = UIButton()
        btn.mg.sss()
        view.lym.sss()
        btn.lym.sss()

        setUpMainView()
        let request = SettingRequest(password: "123")
        MGSessionManager.default.request(request).mgResponseDecodableObject { (response: DataResponse<HSUserData>) in
            print(response)
        }
        MGSessionManager.default.request("Room/GetNewRoomOnline?page=1", method: .get, parameters: nil).mgResponseDecodableObject { (response: DataResponse<MGServicelData1>) in
            print(response)
        }
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.lineBreakMode = .byCharWrapping
        self.ceshiLabel.numberOfLines = 2;
        self.ceshiLabel.lineBreakMode = .byCharWrapping
        self.tipLabel.sizeToFit()
        self.tipLabel .text = "dsaaaaaaaaaahklhlfas"
        self.imageView.image = MGCreatTiool().creatQRCode()

    }

    func setUpMainView() {
        // 如何给UITextView设置placeHodler(占位文字)
        let ideaTextView = UITextView()
        ideaTextView.delegate = self
        ideaTextView.isEditable = false
        ideaTextView.isSelectable = true
//        ideaTextView.dataDetectorTypes = [.phoneNumber]
        ideaTextView.backgroundColor = UIColor.orange
        ideaTextView.frame =  CGRect(x: 20, y: 400, width: 300, height: 200)
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = "写下你的问题或建议，我们将及时跟进解决（建议上传截图帮助我们解决问题，感谢！）"
        placeHolderLabel.numberOfLines = 0
        placeHolderLabel.font = UIFont.systemFont(ofSize: 15)
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.sizeToFit()
        ideaTextView.addSubview(placeHolderLabel)
        ideaTextView.setValue(placeHolderLabel, forKeyPath: "_placeholderLabel")
        ideaTextView.font = placeHolderLabel.font

        view.addSubview(ideaTextView);


        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.lineBreakMode = .byCharWrapping
        let numberStr = "（852）2233 3000"
        let str = "1、增加家人列表，主人可管理家人列表 \n2、修复状态栏在注册界面和忘记密码界面不显示的BUG\n3、修复状态栏在注册界面和忘记密码界面不显示的BUG\n4、修复状态栏在注册界面和忘记密码界面不显示的BUG 5、修复状态栏在注册界面和忘记密码界面不显示的BUG （852）2233 3000"
        let contentString = NSMutableAttributedString(string: str, attributes: [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ])
        let range = str.range(of: numberStr)
        let numberRange = str.nsRange(from: range!)
        contentString.addAttributes([NSAttributedString.Key.link : numberStr], range: numberRange)

        ideaTextView.attributedText = contentString
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return false
    }

    
    @objc func leftClick() {
        self.navigationController?.pushViewController(LeftViewController(), animated: true)
    }

    @objc func rightClick() {
        self.navigationController?.pushViewController(BViewController(), animated: true)
    }
    
//    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "打电话", style: .done, target: self, action: #selector(phoneCall))
//    }
    
    @objc func phoneCall() {
        let url = URL(string: "tel:13750537659")
        UIApplication.shared.open(url!, options: [:]) { (bo) in
            print(url)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ceshi()
//        self.phoneCall()
//        SessionManager.default.request(URL(string: "http://live.9158.com/Room/GetNewRoomOnline?page=1")!, method: .get, parameters: nil).mgResponseObject { (response: DataResponse<MGServicelData>) in
//            switch response.result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        test()
        
//        let shareView1 = TeacherShareView.loadFromNib();
//        shareView1.updateUI()
//        shareView1.center =  UIApplication.shared.keyWindow!.center
//        UIApplication.shared.keyWindow?.addSubview(shareView1)
        
//        let shareView1 = imageView.snapshotView(afterScreenUpdates: true)
//        shareView1!.center =  UIApplication.shared.keyWindow!.center
//        UIApplication.shared.keyWindow?.addSubview(shareView1!)
//        if let shareView1  = shareView1 {
//            shareView1.center =  UIApplication.shared.keyWindow!.center
//            UIApplication.shared.keyWindow?.addSubview(shareView1)
//        }
//        print(isProtraitLockOn())
    }

    func test() {
        var popularDic:[String:[String]] = [
            "arabic":["EG", "SY", "JO", "TN", "PS", "YE", "LB", "LY", "MA", "SA"],
            "arabic(egyptian)": ["EG"],
            "arabic(modernstandard)" : ["EG"],
            "bulgarian": ["BG"],
            "catalan": ["ES"],
            "chinese": ["CN", "TW"],
            "chinese(cantonese)": ["CN", "HK"],
            "czech": ["CZ"],
            "danish": ["DK"],
            "dutch": ["NL"],
            "english": ["US", "GB", "CA", "AU", "ZA", "IE", "NZ"],
            "filipino(tagalog)": ["PH"],
            "french": ["FR", "CA", "BE"],
            "german": ["DE", "AT"],
            "greek": ["GR"],
            "hebrew": ["IL"],
            "hindi": ["IN"],
            "hungarian": ["HU"],
            "indonesian": ["ID"],
            "italian": ["IT"],
            "japanese": ["JP"],
            "korean": ["KR"],
            "norwegian": ["NO"],
            "persian(farsi)": ["IR"],
            "polish": ["PL"],
            "portuguese": ["BR", "PT"],
            "romanian": ["RO"],
            "russian": ["RU", "UA", "BY"],
            "serbian": ["RS"],
            "spanish": ["ES", "VE", "MX", "CO", "AR", "PE", "CL", "EC", "CR"],
            "swedish": ["SE"],
            "thai": ["TH"],
            "turkish": ["TR"],
            "ukrainian": ["UA"],
            "vietnamese": ["VN"],
            ]

        let valueses = popularDic.values
        var other:[String] = [String]()
        for values in valueses{
            for value in values{
                other.append(value)
            }
        }

        // 取得key , 举个🌰："english":["US", "GB", "CA", "AU", "ZA", "IE", "NZ"]
        other = other.sorted()
        let popular = popularDic["english".lowercased()]


        let set1 = Set.init(other) // 全部
        if let popular = popular {
            let set2 = Set.init(popular) // 流行
            let set3 = set1.subtracting(set2) // 其他
            print(set3)

            let sortSetArray:[String] = set3.sorted()
            print(sortSetArray)
        }


        if let popular = popular,valueses.contains(popular) {
            for popularValue in popular {
                if other.contains(popularValue),let index = other.index(of: popularValue) {
                    other.remove(at: index)
                }
            }

            print(other)

            var dataSource:[Any] = [Any]()
            dataSource.append(popular.sorted())
            dataSource.append(other)
            print(dataSource)

        }
    }

    func isProtraitLockOn() -> Bool {
        let app = UIApplication.shared
        var foregroundView:UIView?
        var cls:UIView.Type?
        (app.value(forKeyPath: "statusBar") as! UIView).layoutIfNeeded()
        if UIDevice().userInterfaceIdiom == .pad {
//            let _ = self.ClassIvarsNames(c: ((app.value(forKeyPath: "statusBar") as! UIView).value(forKeyPath: "statusBar") as! UIView).classForCoder)
            foregroundView = ((app.value(forKeyPath: "statusBar") as! UIView).value(forKeyPath: "statusBar") as! UIView).value(forKeyPath: "foregroundView") as? UIView
            cls = NSClassFromString("待定") as? UIView.Type
        }else {
//            let _ = self.ClassIvarsNames(c: (app.value(forKeyPath: "statusBar") as! UIView).classForCoder)
            foregroundView = (app.value(forKeyPath: "statusBar") as! UIView).value(forKeyPath: "foregroundView") as? UIView
            cls = NSClassFromString("UIStatusBarIndicatorItemView") as? UIView.Type
        }

        foregroundView?.layoutIfNeeded()
        var isOn = false

        for child in foregroundView?.subviews ?? [] {
            if let cls1 = cls, child.isKind(of: cls1) {
//                isOn = true
                break
            }
        }
        return isOn
    }
}


struct SettingRequest: MGRequestable {
    var password: String
    var method: HTTPMethod {
        return .get
    }

    var urlPath: String {
        return "setpasswordbytoken"
    }

    var parameters: [String : Any]? {
        return ["password": password]
    }
}

struct HSUserData: Codable {
    /**
     *  health只有有值就代表台灯未使用过或者损坏 (-1)
     */
    var health: Int?
    //* 日期
    var day = ""
    //* start
    var start: Int?
    //* end
    var end: Int?
    //* end
    var minutes = ""
    //* distance
    var distance: Int?
    //* posture
    var posture: Int?
}

class Son: NSObject {
    /**
     *  health只有有值就代表台灯未使用过或者损坏 (-1)
     */
    var health: Int?
    //* 日期
    var day = ""
    //* start
    var start: Int?
    //* end
    var end: Int?
    //* end
    var minutes = ""
    //* distance
    var distance: Int?
    //* posture
    var posture: Int?
}

class MGServicelData<T>: MGModel {
    var msg:String = ""
    var code: String = ""
    var data: T?

}

class MGData: MGModel {
    var totalPage:Int = 0
    var list: [MGHot]?
}

class MGHot: MGModel {
    // MARK: - 属性
    /** 直播图 */
    var bigpic: String!
    /** 主播头像 */
    var smallpic: String!
    /** 直播流地址 */
    var flv: String!
    /** 所在城市 */
    var gps: String!
    /** 主播名 */
    var myname: String!
    /** 个性签名 */
    var signatures: String!
    /** 用户ID */
    var userId: String!
    /** 民族 */
    var nation : String!
    /** 民族Flag */
    var nationFlag : String!

    /** 用户IDX */
    var useridx: NSNumber!
    /** 星级 */
    var starlevel: NSNumber! {
        didSet {
            if ((self.starlevel) != nil) {
                starImage = UIImage(named: "girl_star\(starlevel!)_40x19")
            }
        }
    }

    /** 朝阳群众数目 */
    var allnum: NSNumber!
    /** 这玩意未知 */
    var lrCurrent: NSNumber!
    /** 直播房间号码 */
    var roomid: NSNumber!
    /** 所处服务器 */
    var serverid: NSNumber!

    var isSign: NSNumber!
    var level: NSNumber!
    var grade: NSNumber!
    /** 排名 */
    var pos: NSNumber!
    /** starImage */
    var starImage: UIImage!

    // MARK: - 属性
    // MARK: String
    /** 直播地址 */
    //    var flv: String?
    /** 昵称 */
    var nickname: String?
    /** 照片地址 */
    var photo: String?
    /** 所在地区 */
    var position: String?


    // MARK: NSNumber
    var newField: NSNumber!
    /** 性别 */
    var sex: NSNumber!
    /** 是否是新人 */
    var newStar: NSNumber!

    // MARK: - 属性
}

struct MGServicelData1: Codable {
    var msg:String?
    var code: String?
    var data: MGData1?
}

struct MGData1: Codable {
    var totalPage:Int?
    var list: [MGHot12]?
}

struct MGHot12: Codable {
    // MARK: - 属性
    /** 直播图 */
    var bigpic: String?
    /** 主播头像 */
    var smallpic: String?
    /** 直播流地址 */
    var flv: String?
    /** 所在城市 */
//    var gps: String?
//    /** 主播名 */
//    var myname: String?
//    /** 个性签名 */
//    var signatures: String?
//    /** 用户ID */
//    var userId: String?
//    /** 民族 */
//    var nation : String?
//    /** 民族Flag */
//    var nationFlag : String?
//
//    /** 用户IDX */
//    var useridx: NSNumber?
//    /** 星级 */
//    var starlevel: NSNumber?
////    {
////        didSet {
////            if ((self.starlevel) != nil) {
////                starImage = UIImage(named: "girl_star\(starlevel!)_40x19")
////            }
////        }
////    }
//
//    /** 朝阳群众数目 */
//    var allnum: NSNumber?
//    /** 这玩意未知 */
//    var lrCurrent: NSNumber?
//    /** 直播房间号码 */
//    var roomid: NSNumber?
//    /** 所处服务器 */
//    var serverid: NSNumber?
//
//    var isSign: NSNumber?
//    var level: NSNumber?
//    var grade: NSNumber?
//    /** 排名 */
//    var pos: NSNumber?
//    /** starImage */
//    var starImage: UIImage?
//
//    // MARK: - 属性
//    // MARK: String
//    /** 直播地址 */
//    //    var flv: String?
//    /** 昵称 */
//    var nickname: String?
//    /** 照片地址 */
//    var photo: String?
//    /** 所在地区 */
//    var position: String?
//
//
//    // MARK: NSNumber
//    var newField: NSNumber?
//    /** 性别 */
//    var sex: NSNumber?
//    /** 是否是新人 */
//    var newStar: NSNumber?
//
//    // MARK: - 属性
}


func  ssafdasfdsax(){
//            // 创建一个并发队列
//            let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
//            //初始化信号量为1
//            let semaphore = DispatchSemaphore(value: 1)
//            // 异步操作加入第一个网络请求
//            concurrentQueue.async() {
//                semaphore.wait()
//                self.boVM.requsetBoutique_list(1, {
//                    print("1-----------1")
//                    semaphore.signal()
//                })
//            }
//
//            // 异步操作加入第二个网络请求
//
//            concurrentQueue.async() {
//                semaphore.wait()
//                self.boVM.requsetBoutique_list(1, {
//                    print("2")
//                    semaphore.signal()
//                })
//            }
//
//            // 异步操作加入第三个网络请
//            concurrentQueue.async() {
//                semaphore.wait()
//                self.chVM.requestChildList(.Subscription, {
//                    print("3")
//                    semaphore.signal()
//                })
//            }
            
        /// 栅栏函数要求队列参数为. concurrent
        let queue = DispatchQueue(label: "text.queue")
        queue.async {
            for i in 0 ... 10 {
                debugPrint(i , Thread.current , "------1")
            }
        }
        queue.async {
            for i in 0 ... 10 {
                debugPrint(i , Thread.current , "-----2")
            }
        }
        /// 栅栏函数，前面的执行完，再执行栅栏函数里面的代码，执行完，再执行后面的任务
        queue.async(flags: .barrier) {
            for i in 0 ... 10 {
                debugPrint(i , Thread.current , "------3")
            }
        }
}

extension String {
    func toNSRange(_ range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
    
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}

extension UILabel {
    func needLines(withWidth width: CGFloat) -> Int {
        //创建一个labe
        let label = UILabel()
        //font和当前label保持一致
        label.font = font
        guard let text = self.text else {
            return 0
        }
        var sum = 0
        //总行数受换行符影响，所以这里计算总行数，需要用换行符分隔这段文字，然后计算每段文字的行数，相加即是总行数。
        let splitText = text.components(separatedBy: "\n")
        for sText in splitText {
            label.text = sText
            //获取这段文字一行需要的size
            let textSize = label.systemLayoutSizeFitting(CGSize.zero)
            //size.width/所需要的width 向上取整就是这段文字占的行数
            var lines = ceil((Float(textSize.width / width)))
            //当是0的时候，说明这是换行，需要按一行算。
            lines = lines == 0 ? 1 : lines
            sum += Int(lines)
        }
        return sum
    }
    
    func getSeparatedLines(from label: UILabel?) -> Int {
        guard let text = label?.text else { return 0 }
        guard let font = label?.font else { return 0 }
        guard let rect = label?.bounds else { return 0 }
        var myFont: CTFont? = nil
        if let font1 = (font.fontName) as CFString? {
            myFont = CTFontCreateWithName(font1, font.pointSize, nil)
        }
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(NSAttributedString.Key(kCTFontAttributeName as String), value: myFont!, range: NSRange(location: 0, length: attStr.length))
        var frameSetter: CTFramesetter? = nil
        if let str = attStr as? CFAttributedString {
            frameSetter = CTFramesetterCreateWithAttributedString(str)
        }
        guard let frameSetter1 = frameSetter else { return 0 }
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: CGFloat(MAXFLOAT)), transform: .identity)
        let frame = CTFramesetterCreateFrame(frameSetter1, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame) as? [CTLine]
        var linesArray: [String] = []
        for line in lines ?? [] {
            let lineRef = line
            let lineRange = CTLineGetStringRange(lineRef)
            let lineString = text.subString(from: lineRange.location, length: lineRange.length)
            linesArray.append(lineString)
            
//            let range = NSRange(location: lineRange.location, length: lineRange.length)
//            if let range1 = text.range(from: range) {
//                let lineString = text.substring(with: range1)
//                linesArray.append(lineString)
//            }
        }

        if linesArray.count > 2 {
            print("第一行字数 \( linesArray[0].count)： \(linesArray[0]) \n  第儿行字数 \( linesArray[1].count)： \(linesArray[1])")
            return linesArray[0].count + linesArray[1].count
        }
        return  0
    }
}
