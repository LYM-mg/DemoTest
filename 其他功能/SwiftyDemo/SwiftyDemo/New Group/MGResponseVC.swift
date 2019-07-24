//
//  MGResponseVC.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/12.
//  Copyright © 2019 firestonetmt. All rights reserved.
//

import UIKit
import Alamofire
import MJExtension

class MGResponseVC: UIViewController {

    var btn: UIButton!
    var btn1: UIButton!
    var touchIDSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "模拟网络请求"
        view.backgroundColor = UIColor.randomColor()

        let btn = UIButton()
        btn.setTitle("frame小红点 点击弹出TouchID", for: .normal)
        btn.frame = CGRect(x: 10, y: 90, width: 300, height: 45)
        btn.backgroundColor = UIColor.randomColor()
        btn.addTarget(self, action: #selector(self.requestJSON), for: .touchUpInside)
        view.addSubview(btn)
        self.btn = btn
        btn.showBadge()

        let btn1 = UIButton()
        btn1.setTitle("Layout小红点", for: .normal)
        btn1.backgroundColor = UIColor.randomColor()
        btn1.addTarget(self, action: #selector(self.AFNRequestJSON), for: .touchUpInside)
        view.addSubview(btn1)
        self.btn1 = btn1
        btn1.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(150)
            make.left.equalTo(view).offset(30)
        }
        btn1.showBadge(12)
        let Arr:[String] = [String]()
        for (i,dict) in Arr.enumerated() {
            
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(self.rightClick))
    }

    deinit {
        print("\(self) deinit")
    }

    @objc func rightClick() {
        self.navigationController?.pushViewController(MGSearchTableViewController(), animated: true)
    }

    @objc func requestJSON() {
        let parameters: [String: Any] = ["method":"baidu.ting.billboard.billCategory","kflag":"1","from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json"]

        MGSessionManager.default.request("http://tingapi.ting.baidu.com/v1/restserver/ting", method: .post, parameters: parameters).responseDecodableObject { (response:DataResponse<MGSong>) in
            switch response.result {
            case .success(let value):
                print(value)
                break
            case .failure(let error):
                print(error)
                break

            }
        }
        MGSessionManager.default.request("http://tingapi.ting.baidu.com/v1/restserver/ting", method: .post, parameters: parameters).mgResponseDecodableObject { (response:DataResponse<MGSong>) in
            switch response.result {
            case .success(let value):
                print(value)
                break
            case .failure(let error):
                print(error)
                break

            }
        }


        API.Home.Base.getHomeList(parameters: parameters).progressTitle("正在加载。。。").perform(successed: { (reslut, err) in
            let song = LYMSong.mj_object(withKeyValues: reslut)
        }) { (err) in
            print(err)
        }
    }

    @objc func AFNRequestJSON() {
        let parameters: [String: Any] = ["method":"baidu.ting.billboard.billCategory","kflag":"1","from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json"]
        SessionManager.default.request("http://tingapi.ting.baidu.com/v1/restserver/ting", method: .post, parameters: parameters).lym.responseObject { (response:DataResponse<LYMSong>) in
            switch response.result {
                case .success(let song):
                    print(song)
                    break
                case .failure(let error):
                    print(error)
                    break
            }
        }
        SessionManager.default.request("http://tingapi.ting.baidu.com/v1/restserver/ting", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
            print(response)
            // 1.将result转成字典类型
            guard let resultDict = response as? [String : Any] else { return }
            })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let parameters: [String: Any] = ["method":"baidu.ting.billboard.billCategory","kflag":"1","from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json"]
        MGSessionManager.default.request("http://tingapi.ting.baidu.com/v1/restserver/ting", method: .post, parameters: parameters).lym.responseObject { (response: DataResponse<LYMSong>) in
            print(response)
        }

        MJJSON()



//        let jsonData = json.data(using: .utf8)!
//        let decoder = JSONDecoder()
//        do {
//            let user_data2 = try decode(of: json1, type: YYSong.self)
//            let user_data3 = try decoder.decode(YYSong.self, from: json1.data(using: .utf8)!)
//            let user_data = try decoder.decode(SSSSong.self, from: jsonData)
//            print(user_data)
//        } catch {
//            print("error on decode: \(error.localizedDescription)")
//        }
//
//        let jsonData1 = str.data(using: .utf8)!
//
//        do {
//            let user_data = try decoder.decode(RegisteredUser.self, from: jsonData1)
//            print(user_data)
//        } catch {
//            print("error on decode: \(error.localizedDescription)")
//        }
    }
}

func encode<T>(of model: T) throws where T: Codable {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let encodedData = try encoder.encode(model)
    print(String(data: encodedData, encoding: .utf8)!)
}
func decode<T>(of jsonString: String, type: T.Type) throws -> T? where T: Codable {
    let data = jsonString.data(using: .utf8)!
    let decoder = JSONDecoder()
    let model = try? decoder.decode(T.self, from: data)
    return model
}


struct RegisteredUser: Codable {
    let error: Int
    let name: String
    let mail: String
    let password: String
    let user_type: String
}


struct Student: Codable {
    let name: String
    let age: Int
    let sex: SexType
    let bornIn: String

    enum SexType: String, Codable {
        case male
        case female
    }

    enum CodingKeys: String, CodingKey {
        case name
        case age
        case sex
        case bornIn = "born_in"
    }
}


let json1 = """
{
    "name": "热歌榜",
    "type": 2,
    "count": 4,
    "comment": "该榜单是根据千千音乐平台歌曲每周播放量自动生成的数据榜单，统计范围为千千音乐平台上的全部歌曲，每日更新一次",
    "students" : [
        {
            "age" : 17,
            "sex" : "male",
            "born_in" : "China",
            "name" : "ZhangSan"
        },
        {
            "age" : 18,
            "sex" : "male",
            "born_in" : "Japan",
            "name" : "LiSi"
        }
    ]
}
"""

let json2 = """
    {
    "name": "热歌榜",
    "type": 2,
    "count": 4,
    "comment": "该榜单是根据千千音乐平台歌曲每周播放量自动生成的数据榜单，统计范围为千千音乐平台上的全部歌曲，每日更新一次",
"students" : {
        "age" : 17,
        "sex" : "male",
        "born_in" : "China",
        "name" : "ZhangSan"
    }
}
"""

