//
//  LeftViewController.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/3/26.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit
import Alamofire
import LocalAuthentication

class LeftViewController: UIViewController {

    var btn: UIButton!
    var btn1: UIButton!
    var touchIDSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "网络测试小红点"
        view.backgroundColor = UIColor.randomColor()

        var ivarNum: Int8 = 0
        let xx = XXX()
        let ivars = class_getInstanceVariable(XXX.self, &ivarNum)
        var ivarNum1: UInt32 = 0
        let ivars11 = class_copyIvarList(XXX.self, &ivarNum1)

        let touchIDSwitch = UISwitch()
        touchIDSwitch.frame = CGRect(x: 200, y: 200, width: 80, height: 30)
        view.addSubview(touchIDSwitch)
        touchIDSwitch.addTarget(self, action: #selector(self.change(_:)), for: UIControl.Event.valueChanged)
        let isOn: Bool? = UserDefaults.standard.object(forKey: "kTouchID") as? Bool
        if let isOn = isOn {
            touchIDSwitch.isOn = isOn;
            if (isOn) {
                touchID()
            }
        }


        let btn = UIButton()
        btn.setTitle("frame小红点 点击弹出TouchID", for: .normal)
        btn.frame = CGRect(x: 10, y: 90, width: 300, height: 45)
        btn.backgroundColor = UIColor.randomColor()
        btn.addTarget(self, action: #selector(self.touchID), for: .touchUpInside)
        view.addSubview(btn)
        self.btn = btn
        btn.showBadge()

        let btn1 = UIButton()
        btn1.setTitle("Layout小红点", for: .normal)
        btn1.backgroundColor = UIColor.randomColor()
        btn1.addTarget(self, action: #selector(self.requestVC), for: .touchUpInside)
        view.addSubview(btn1)
        self.btn1 = btn1
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(150)
            make.left.equalTo(view).offset(30)
        }
        btn1.showBadge(12)

        ClassroomNetworkListener.getInstance().delegate = self
        ClassroomNetworkListener.getInstance().starListener()


        MGRequest<Person>.requestService(success: { (reslut) in
            print(reslut)
            //    reslut.name
            print()
        }) {

        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.rightClick))

        setUpMainView()
    }

    func setUpMainView() {
        // 如何给UITextView设置placeHodler(占位文字)
        let ideaTextView = UITextView()
        ideaTextView.backgroundColor = UIColor.orange
        ideaTextView.frame =  CGRect(x: 20, y: 230, width: 300, height: 200)
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
        let contentString1 = NSMutableAttributedString(string: "1、增加家人列表，主人可管理家人列表 \n2、修复状态栏在注册界面和忘记密码界面不显示的BUG\n3、修复状态栏在注册界面和忘记密码界面不显示的BUG\n4、修复状态栏在注册界面和忘记密码界面不显示的BUG")
        contentString1.setUnderline("1、增加家人列表，主人可管理家人列表", color: UIColor.purple,style:NSUnderlineStyle(rawValue: NSUnderlineStyle.single.rawValue))
        ideaTextView.attributedText = contentString1


        contentString1.setStrikethrough("修复状态栏") // , color: UIColor.randomColor()
        let lb = UILabel(frame: CGRect(x: 10, y: ideaTextView.frame.maxY + 10, width: 300, height: 0))
        view.addSubview(lb);
        lb.numberOfLines = 0
        lb.backgroundColor = UIColor.lightGray
        lb.attributedText = contentString1
        lb.sizeToFit()


    }


    deinit {
        ClassroomNetworkListener.removeListener(delegate: self)
        print("\(self) deinit")
    }

    @objc func rightClick() {
        ClassroomNetworkListener.removeListener(delegate: self)
       self.back(toController: "ViewController", animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        btn.showBadge(22)
        btn1.hideBadge()
        testLocalTime()
    }

    @objc func testLocalTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        //dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"]; // 这里是用小写的 h
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"

        print(DateFormatter.formatterMMddHHmm.string(from: Date()))
        print(dateFormatter.string(from: Date()))
        print(dateFormatter1.string(from: Date()))
    }

    @objc func change(_ sw: UISwitch) {
        sw.isOn = !sw.isOn
        UserDefaults.standard.setValue(sw.isOn, forKey: "kTouchID")
        UserDefaults.standard.synchronize()
    }
    @objc func requestVC(_ sw: UISwitch) {
        self.navigationController?.pushViewController(MGResponseVC(), animated: true)
    }


    @objc func touchID() {
        if !MGTouchIDManager.isSupportTouchID {
            return
        }
        MGTouchIDManager.userFingerprintTipStr(withtips: "通过验证手机已有指纹解锁",withIsPwdBtn:false , block: { (result:MGTouchIDManager.MGCheckResult) in
            switch result{
            case .success:
                print("用户解锁成功")
                //进行操作，回到主线程，否则可能会有延时
                break
            case .failed:
                    print("连续三次输入错误，身份验证失败。")
                    DispatchQueue.main.async(execute: {
                        
                    })
                break
            case .passwordNotSet:
                print("未设置密码")
                break
            case .touchidNotSet:
                print("未设置指纹")
                break
            case .touchidNotAvailable:
                print("系统不支持")
                break
            case .touchIDLockout:
                print("touchID输入次数过多验证被锁")
                break
            default:
                break
            }
        })

//        BiometricService.share().usesBiometric(success: {
//            print("成功")
//        }) { (error) in
//            guard let error = error else {
//                return
//            }
//            switch (error) {
//                case .biometryNotEnrolled:
//                    print("iPhone没录入指纹")
//                    break
//                case .notAvailable:
//                    print("设备不支持")
//                    break
//                case .passcodeNotSet:
//                    print("未设置密码")
//                    break
//                case .authenticationFailed:
//                    print("认证失败了3次，提示请输入支付密码支付")
//                    break
//                case .biometryLockout:
//                     print("touchID不正确")
//                    break
//                default:
//                    break
//            }
//        }
    }

    @objc func touchID1() {
        //首先判断版本
        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0 {
            print("系统版本不支持TouchID")
            return
        }


        let context = LAContext()
        context.localizedFallbackTitle = "输入密码"
        if #available(iOS 10.0, *) {
            context.localizedCancelTitle = "取消";
        } else {
            
        }
        var error1: NSError? = nil

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error1) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "通过Home键验证已有手机指纹", reply: { (success, error) in
                if success {
                    DispatchQueue.main.async(execute: {
                        print("TouchID 验证成功")
                    })
                }else {
                    switch (error as NSError?)?.code {
                        case LAError.Code.authenticationFailed.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("TouchID 验证失败")
                            })
                        case LAError.Code.userCancel.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("TouchID 被用户手动取消")
                            })
                        case LAError.Code.userFallback.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("用户不使用TouchID,选择手动输入密码")
                            })
                        case LAError.Code.systemCancel.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)")
                            })
                        case LAError.Code.passcodeNotSet.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("TouchID 无法启动,因为用户没有设置密码")
                            })
                        case LAError.Code.touchIDNotAvailable.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("TouchID 无效")
                            })
                        case LAError.Code.touchIDLockout.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)")
                            })
                        case LAError.Code.appCancel.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("当前软件被挂起并取消了授权 (如App进入了后台等)")
                            })
                        case LAError.Code.invalidContext.rawValue?:
                            DispatchQueue.main.async(execute: {
                                print("当前软件被挂起并取消了授权 (LAContext对象无效)")
                            })
                        default:
                            break
                    }
                }
            })
        }else {
             print("设备不支持指纹")
        }
    }
}

extension LeftViewController: ClassRoomNetWorkListenerDelegate {
    func netWorkChanged(status: MGNetWorkStatus) {
        print("网络状态\(status)")
    }
}

extension DateFormatter {
    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        return formatter
    }

    // Jan 20, 13:30
    static let formatterMMddHHmm: DateFormatter = {
        let formatter = dateFormatter()
        // 获取系统时区
        //        formatter.timeZone = NSTimeZone.system

        let format = "MMM dd, hh:mm a" // usesAMPM() ? "MMM dd, hh:mm a" : "MMM dd, HH:mm"
        formatter.setLocalizedDateFormatFromTemplate(format)
        return formatter
    }()

    static func usesAMPM() -> Bool {
        if let formatString = dateFormat(fromTemplate: "yMMMMd", options: 0, locale: Locale.current) {
            return formatString.contains("a")
        }
        return true
    }
}


class XXX: MGModel {
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

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Person: Codable {
    let age:Int
    let name:String
    let user_id:String
    let ttt:String?
}

struct MGRequest <T : Codable> {

}
public typealias GenericClosure<T> = (T) -> ()
extension MGRequest {
    static func requestService(decoder: JSONDecoder = JSONDecoder(), success:@escaping (Any)->(),fail: @escaping ()->()) {
        let dict:[String:Any] = ["age":10,"name":"笨蛋","user_id":"MG"]
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted) else {
            fail()
            return ;
        }
        let object = try? decoder.decode(T.self, from: data)
        success(object as Any)


       let str = "{\"meta\": {\"performance\": 243, \"server_time\": 1554265566531, \"ver\": \"2.2.0\"}, \"data\": {\"packages_active\": [{\"package_status\": \"5\", \"package_id\": 2154457205, \"package_label\": \"accepted\", \"package_expiration\": \"2019-05-09T07:29:59+00:00\", \"session_language\": \"english\", \"session_duration\": 2, \"course_title\": \"Business English - All Levels\", \"teacher_id\": 1056370, \"sessions_total\": 10, \"sessions_unarranged\": 0, \"teacher_avatar\": \"4T010563700\"}, {\"package_status\": \"5\", \"package_id\": 2154457250, \"package_label\": \"accepted\", \"package_expiration\": \"2019-05-15T06:53:59+00:00\", \"session_language\": \"english\", \"session_duration\": 2, \"course_title\": \"Business English - All Levels\", \"teacher_id\": 1056370, \"sessions_total\": 10, \"sessions_unarranged\": 4, \"teacher_avatar\": \"4T010563700\"}, {\"package_status\": \"5\", \"package_id\": 2154457268, \"package_label\": \"accepted\", \"package_expiration\": \"2019-05-16T09:47:15+00:00\", \"session_language\": \"english\", \"session_duration\": 2, \"course_title\": \"Business English - All Levels\", \"teacher_id\": 1056370, \"sessions_total\": 10, \"sessions_unarranged\": 0, \"teacher_avatar\": \"4T010563700\"}, {\"package_status\": \"5\", \"package_id\": 2154457269, \"package_label\": \"accepted\", \"package_expiration\": \"2019-06-20T00:00:00+00:00\", \"session_language\": \"english\", \"session_duration\": 2, \"course_title\": \"Business English - All Levels\", \"teacher_id\": 1056370, \"sessions_total\": 10, \"sessions_unarranged\": 9, \"teacher_avatar\": \"4T010563700\"}, {\"package_status\": \"5\", \"package_id\": 2154457270, \"package_label\": \"accepted\", \"package_expiration\": \"2019-05-17T03:32:28+00:00\", \"session_language\": \"bosnian\", \"session_duration\": 4, \"course_title\": \"\", \"teacher_id\": 1072323, \"sessions_total\": 20, \"sessions_unarranged\": 19, \"teacher_avatar\": \"4T010723237\"}], \"paging\": {\"page\": 1, \"page_size\": 5, \"active_package_count\": 17, \"active_has_next\": true}}, \"success\": 1, \"paging\": {\"page\": 1, \"page_size\": 5, \"active_package_count\": 17, \"active_has_next\": true}}"
        let dataStr = str.data(using: .utf8)
        guard let dict22:NSDictionary? = try? JSONSerialization.jsonObject(with: dataStr ?? Data(), options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else {
            fail()
            return ;
        }

        print(dict22 as Any)
    }
}

