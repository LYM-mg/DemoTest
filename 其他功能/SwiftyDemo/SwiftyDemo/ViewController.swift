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

class ViewController: UIViewController {

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
    }

    func setUpMainView() {
        // 如何给UITextView设置placeHodler(占位文字)
        let ideaTextView = UITextView()
        ideaTextView.backgroundColor = UIColor.orange
        ideaTextView.frame =  CGRect(x: 20, y: 200, width: 300, height: 200)
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
        let contentString = NSMutableAttributedString(string: "1、增加家人列表，主人可管理家人列表 \n2、修复状态栏在注册界面和忘记密码界面不显示的BUG\n3、修复状态栏在注册界面和忘记密码界面不显示的BUG\n4、修复状态栏在注册界面和忘记密码界面不显示的BUG", attributes: [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ])

        ideaTextView.attributedText = contentString
    }

    @objc func leftClick() {
        self.navigationController?.pushViewController(LeftViewController(), animated: true)
    }

    @objc func rightClick() {
        self.navigationController?.pushViewController(BViewController(), animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        SessionManager.default.request(URL(string: "http://live.9158.com/Room/GetNewRoomOnline?page=1")!, method: .get, parameters: nil).mgResponseObject { (response: DataResponse<MGServicelData>) in
//            switch response.result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        test()
        print(isProtraitLockOn())
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
