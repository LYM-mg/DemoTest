//
//  MGRequestModel.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/12.
//  Copyright © 2019 firestonetmt. All rights reserved.
//

import Foundation
import UIKit
//import HandyJSON
//import SwiftyJSON
import SwiftyJSON

struct MGSong:Codable {
    let content: [Song]?
    let error_code:String?

    enum CodingKeys: String, CodingKey {
        case error_code
        case content
    }
}

struct Song:Codable  {
    let type: Int?
    let count: Int?
    let name:String?
    let comment:String?
    let web_url:String?
    let pic_s192:String?
    let pic_s444:String?
    let pic_s260:String?
    let pic_s210:String?

    let color:String?
    let bg_color:String?
    let bg_pic:String?
    let content:[Content]  = [Content]()

    enum CodingKeys: String, CodingKey {
        case type
        case count
        case name
        case comment
        case web_url
        case pic_s192
        case pic_s444
        case pic_s260
        case pic_s210

        case color
        case bg_color
        case bg_pic
        case content
    }
}

struct Content:Codable  {
    let title:String?
    let author:String?
    let song_id:String?
    let album_id:String?
    let album_title:String?
    let rank_change:String?
    let all_rate:String?
    let biaoshi:String?
    let pic_big:String?
    let pic_small:String?

    enum CodingKeys: String, CodingKey {
        case title
        case author
        case song_id
        case album_id
        case album_title
        case rank_change
        case all_rate
        case biaoshi
        case pic_big
        case pic_small
    }
}

class LYMSong:NSObject,MGModelProtocol {

    var content: [LSong]? = nil
    var error_code:Int? = 0

    required override init() {
        super.init()
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required convenience init(_ json: JSON!) {
        self.init()
        if json.isEmpty{
            return
        }
        error_code = json["error_code"].intValue
        content = [LSong]()
        let contentArray = json["content"].arrayValue
        for contentJson in contentArray{
            let value = LSong(contentJson)
            content!.append(value)
        }
    }
}

class LSong:NSObject,MGModelProtocol  {
    var type: Int? = nil
    var count: Int? = nil
    var name:String? = nil
    var comment:String? = nil
    var web_url:String? = nil
    var pic_s192:String? = nil
    var pic_s210:String? = nil
    var pic_s260:String? = nil
    var pic_s328:String? = nil
    var pic_s444:String? = nil
    var pic_s640:String? = nil

    var color:String? = nil
    var bg_color:String? = nil
    var bg_pic:String? = nil
    var content:[LYMContent]? = nil


    required override init() {
        super.init()
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    required convenience init(_ json: JSON!) {
        self.init()
        if json.isEmpty{
            return
        }

        color = json["color"].stringValue
        comment = json["comment"].stringValue

        count = json["count"].intValue
        name = json["name"].stringValue
        pic_s192 = json["pic_s192"].stringValue
        pic_s210 = json["pic_s210"].stringValue
        pic_s260 = json["pic_s260"].stringValue
        pic_s328 = json["pic_s328"].stringValue
        pic_s444 = json["pic_s444"].stringValue
        pic_s640 = json["pic_s640"].stringValue
        type = json["type"].intValue
        bg_color = json["bg_color"].stringValue
        bg_pic = json["bg_pic"].stringValue
        web_url = json["web_url"].stringValue

        content = [LYMContent]()
        let contentArray = json["content"].arrayValue
        for contentJson in contentArray{
            let value = LYMContent(contentJson)
            content!.append(value)
        }
    }
}

class LYMContent:NSObject,MGModelProtocol {
    var title:String? = nil
    var author:String? = nil
    var song_id:String? = nil
    var album_id:String? = nil
    var album_title:String? = nil
    var rank_change:String? = nil
    var all_rate:String? = nil
    var biaoshi:String? = nil
    var pic_big:String? = nil
    var pic_small:String? = nil

    required override init() {
        super.init()
    }

    required convenience init(_ json: JSON!) {
        self.init()
        if json.isEmpty{
            return
        }
        album_id = json["album_id"].stringValue
        album_title = json["album_title"].stringValue
        all_rate = json["all_rate"].stringValue
        author = json["author"].stringValue
        biaoshi = json["biaoshi"].stringValue
        pic_big = json["pic_big"].stringValue
        pic_small = json["pic_small"].stringValue
        rank_change = json["rank_change"].stringValue
        song_id = json["song_id"].stringValue
        title = json["title"].stringValue
    }
}


let json22222 =
"""
{
    "content": [
    {
    "name": "热歌榜",
    "type": 2,
    "count": 4,
    "comment": "该榜单是根据千千音乐平台歌曲每周播放量自动生成的数据榜单，统计范围为千千音乐平台上的全部歌曲，每日更新一次",
    "web_url": "",
    "pic_s192": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_1452f36a8dc430ccdb8f6e57be6df2ee.jpg",
    "pic_s444": "http://hiphotos.qianqian.com/ting/pic/item/c83d70cf3bc79f3d98ca8e36b8a1cd11728b2988.jpg",
    "pic_s260": "http://hiphotos.qianqian.com/ting/pic/item/838ba61ea8d3fd1f1326c83c324e251f95ca5f8c.jpg",
    "pic_s210": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_734232335ef76f5a05179797875817f3.jpg",
    "content": [
    {
    "title": "卡路里（电影《西虹市首富》插曲）",
    "author": "火箭少女101",
    "song_id": "601427388",
    "album_id": "601427384",
    "album_title": "卡路里（电影《西虹市首富》插曲）",
    "rank_change": "0",
    "all_rate": "96,224,128,320,flac",
    "biaoshi": "lossless,perm-3",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/8d356491f24692ff802cc49c80f51fee/612356223/612356223.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/8d356491f24692ff802cc49c80f51fee/612356223/612356223.jpg@s_2,w_150,h_150"
    }
    ],
    "color": "0xDC5900",
    "bg_color": "0xFBEFE6",
    "bg_pic": "http://business0.qianqian.com/qianqian/file/5bfe4e9aa7496_218.png"
    },
    {
    "name": "新歌榜",
    "type": 1,
    "count": 4,
    "comment": "该榜单是根据千千音乐平台歌曲每日播放量自动生成的数据榜单，统计范围为近期发行的歌曲，每日更新一次",
    "web_url": "",
    "pic_s192": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_9a4fbbbfa50203aaa9e69bf189c6a45b.jpg",
    "pic_s444": "http://hiphotos.qianqian.com/ting/pic/item/78310a55b319ebc4845c84eb8026cffc1e17169f.jpg",
    "pic_s260": "http://hiphotos.qianqian.com/ting/pic/item/e850352ac65c1038cb0f3cb0b0119313b07e894b.jpg",
    "pic_s210": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_dea655f4be544132fb0b5899f063d82e.jpg",
    "content": [
    {
    "title": "为悦己者容（弦乐版）（电视剧《面具背后》片尾曲）",
    "author": "崔子格",
    "song_id": "613440970",
    "album_id": "613440967",
    "album_title": "为悦己者容（弦乐版）（电视剧《面具背后》片尾曲）",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "first,lossless,vip,perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/fe8308782dbb1c4daadd3e5716763ecf/613451063/613451063.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/fe8308782dbb1c4daadd3e5716763ecf/613451063/613451063.jpg@s_2,w_150,h_150"
    },
    {
    "title": "少女年华（电影《过春天》粤语版青春共鸣曲）",
    "author": "刘惜君",
    "song_id": "613237527",
    "album_id": "613237525",
    "album_title": "少女年华",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "first,lossless,perm-3",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/f46eabeb389515a87f9dfbef46bfbe9c/613243638/613243638.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/f46eabeb389515a87f9dfbef46bfbe9c/613243638/613243638.jpg@s_2,w_150,h_150"
    }
    ],
    "color": "0x5B9400",
    "bg_color": "0xEFF5E6",
    "bg_pic": "http://business0.qianqian.com/qianqian/file/5c3d586d234b4_292.png"
    },
    {
    "name": "网络歌曲榜",
    "type": 25,
    "count": 4,
    "comment": "实时展现千千音乐最热门网络歌曲排行",
    "web_url": "",
    "pic_s192": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_6b67628d46638bccdc6bd8c9854b759b.jpg",
    "pic_s444": "http://hiphotos.qianqian.com/ting/pic/item/738b4710b912c8fca95d9ecbfe039245d688210d.jpg",
    "pic_s260": "http://hiphotos.qianqian.com/ting/pic/item/6c224f4a20a44623d567cd649a22720e0cf3d703.jpg",
    "pic_s210": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_e58a5196bcd49d77d4a099b60b0bc03b.jpg",
    "content": [
    {
    "title": "为悦己者容（弦乐版）（电视剧《面具背后》片尾曲）",
    "author": "崔子格",
    "song_id": "613440970",
    "album_id": "613440967",
    "album_title": "为悦己者容（弦乐版）（电视剧《面具背后》片尾曲）",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "first,lossless,vip,perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/fe8308782dbb1c4daadd3e5716763ecf/613451063/613451063.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/fe8308782dbb1c4daadd3e5716763ecf/613451063/613451063.jpg@s_2,w_150,h_150"
    },
    {
    "title": "至少还有你爱我",
    "author": "龙梅子,王娜",
    "song_id": "602980311",
    "album_id": "602980305",
    "album_title": "至少还有你爱我",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "lossless,perm-3",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/015c6c99e1ced5261f624ef20cd7912f/609142152/609142152.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/015c6c99e1ced5261f624ef20cd7912f/609142152/609142152.jpg@s_2,w_150,h_150"
    },
    {
    "title": "缘为冰",
    "author": "龙梅子",
    "song_id": "611717057",
    "album_id": "611717054",
    "album_title": "缘为冰",
    "rank_change": "0",
    "all_rate": "96,224,128,320,flac",
    "biaoshi": "lossless,perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/3e6581f50cac570485718a4d7473fc13/611718813/611718813.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/3e6581f50cac570485718a4d7473fc13/611718813/611718813.jpg@s_2,w_150,h_150"
    }
    ],
    "color": "0x21BFA6",
    "bg_color": "0xE9F9F6",
    "bg_pic": "http://business0.qianqian.com/qianqian/file/5bfe4eacbcea8_225.png"
    },
    {
    "name": "原创音乐榜",
    "type": 200,
    "count": 3,
    "comment": "",
    "web_url": "",
    "pic_s192": "http://y.baidu.com/cms/app/192-192.jpg",
    "pic_s444": "http://business0.qianqian.com/qianqian/file/5b1616af74b79_903.jpg",
    "pic_s260": "http://business0.qianqian.com/qianqian/file/5b1616af74b79_903.jpg",
    "pic_s210": "http://business0.qianqian.com/qianqian/file/5b1616af74b79_903.jpg",
    "pic_s328": "http://business0.qianqian.com/qianqian/file/5b1616c9bc63d_740.jpg",
    "pic_s640": "http://business0.qianqian.com/qianqian/file/5b1616be0e3f9_347.jpg",
    "content": [
    {
    "title": "半生无求--卿本佳人小说原创同人作品",
    "author": "琴酒蜀黍",
    "song_id": "74189487",
    "album_id": "611659437",
    "album_title": "半生无求--卿本佳人小说原创同人作品",
    "rank_change": "0",
    "all_rate": "96,128,224,320",
    "biaoshi": "perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/e6b03749d2e19c357e13b4d5910b2a42/523150905/523150905.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/e6b03749d2e19c357e13b4d5910b2a42/523150905/523150905.jpg@s_2,w_150,h_150"
    },
    {
    "title": "三体Opening Theme",
    "author": "野萨满王利夫",
    "song_id": "73830133",
    "album_id": "611638041",
    "album_title": "三体Opening Theme",
    "rank_change": "0",
    "all_rate": "96,128",
    "biaoshi": "perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/default_album.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/default_album.jpg@s_2,w_150,h_150"
    },
    {
    "title": "小提琴与钢琴--摇篮曲",
    "author": "老友潸然",
    "song_id": "74112702",
    "album_id": "611639593",
    "album_title": "小提琴与钢琴--摇篮曲",
    "rank_change": "0",
    "all_rate": "96,128,224,320",
    "biaoshi": "perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/dc331745d6bf112e1f6a0a885de2b2f3/560292722/560292722.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/dc331745d6bf112e1f6a0a885de2b2f3/560292722/560292722.jpg@s_2,w_150,h_150"
    }
    ],
    "color": "0x7B6CBE",
    "bg_color": "0xF2F1F9",
    "bg_pic": "http://business0.qianqian.com/qianqian/file/5bfe4ee203ee4_783.png"
    },
    {
    "name": "影视金曲榜",
    "type": 24,
    "count": 4,
    "comment": "实时展现千千音乐最热门影视歌曲排行",
    "web_url": "",
    "pic_s192": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_2347fb14878de20a3b972a8f44a5c3a8.jpg",
    "pic_s444": "http://hiphotos.qianqian.com/ting/pic/item/f703738da97739121a5aed67fa198618367ae2bc.jpg",
    "pic_s260": "http://hiphotos.qianqian.com/ting/pic/item/9f2f070828381f3052bae5afab014c086e06f011.jpg",
    "pic_s210": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_4de71fefad5f1fdb0a90b3c51b5a6f97.jpg",
    "content": [
    {
    "title": "大王叫我来巡山",
    "author": "贾乃亮,贾云馨",
    "song_id": "257535276",
    "album_id": "260368616",
    "album_title": "万万没想到 电影原声带",
    "rank_change": "0",
    "all_rate": "flac,320,128,224,96",
    "biaoshi": "lossless,perm-3",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/260368391/260368391.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/260368391/260368391.jpg@s_2,w_150,h_150"
    },
    {
    "title": "无敌",
    "author": "邓超",
    "song_id": "261498824",
    "album_id": "261498722",
    "album_title": "无敌",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "lossless,perm-3",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/261498695/261498695.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/261498695/261498695.jpg@s_2,w_150,h_150"
    },
    {
    "title": "不潮不用花钱",
    "author": "林俊杰",
    "song_id": "259242650",
    "album_id": "258953281",
    "album_title": "乌鸦嘴妙女郎 电视原声带",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "lossless,perm-3",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/1ac5b0f1c95c78be5dd1f17343380a8c/613318868/613318868.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/1ac5b0f1c95c78be5dd1f17343380a8c/613318868/613318868.jpg@s_2,w_150,h_150"
    },
    {
    "title": "被风吹过的夏天",
    "author": "林俊杰,金莎",
    "song_id": "246732955",
    "album_id": "246732962",
    "album_title": "最佳前男友 电视原声",
    "rank_change": "3",
    "all_rate": "flac,320,128,224,96",
    "biaoshi": "lossless,vip,perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/6e725d74079aa90476655effb1b7cbf3/611737404/611737404.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/6e725d74079aa90476655effb1b7cbf3/611737404/611737404.jpg@s_2,w_150,h_150"
    }
    ],
    "color": "0x967456",
    "bg_color": "0xF5F1EE",
    "bg_pic": "http://business0.qianqian.com/qianqian/file/5bfe4ed160c12_921.png"
    },
    {
    "name": "经典老歌榜",
    "type": 22,
    "count": 4,
    "comment": "实时展现千千音乐最热门经典老歌排行",
    "web_url": "",
    "pic_s192": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_e6b795613995b69b73861ca7e7732015.jpg",
    "pic_s444": "http://hiphotos.qianqian.com/ting/pic/item/6f061d950a7b0208b85e57e760d9f2d3572cc825.jpg",
    "pic_s260": "http://hiphotos.qianqian.com/ting/pic/item/0bd162d9f2d3572cd909f4da8813632763d0c3c9.jpg",
    "pic_s210": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_ecd2c13c57fb27574b9e758e4f707cef.jpg",
    "content": [
    {
    "title": "后来",
    "author": "刘若英",
    "song_id": "790142",
    "album_id": "190892",
    "album_title": "我等你",
    "rank_change": "0",
    "all_rate": "flac,320,128,224,96",
    "biaoshi": "lossless,perm-3",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/51677db1f7b51f1f1bacd1a2498665ff/190892/190892.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/51677db1f7b51f1f1bacd1a2498665ff/190892/190892.jpg@s_2,w_150,h_150"
    },
    {
    "title": "伤心太平洋",
    "author": "任贤齐",
    "song_id": "704195",
    "album_id": "173971",
    "album_title": "情义",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "lossless,perm-3",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/73a3804e1b971cbebc63d99260278136/173971/173971.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/73a3804e1b971cbebc63d99260278136/173971/173971.jpg@s_2,w_150,h_150"
    }
    ],
    "color": "0xD98E26",
    "bg_color": "0xFBF4EA",
    "bg_pic": "http://business0.qianqian.com/qianqian/file/5bfe4e5a1364a_423.png"
    },
    {
    "name": "欧美金曲榜",
    "type": 21,
    "count": 4,
    "comment": "实时展现千千音乐最热门欧美歌曲排行",
    "web_url": "",
    "pic_s192": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_9362a5a55277e6fb271010a45bc99e17.jpg",
    "pic_s444": "http://hiphotos.qianqian.com/ting/pic/item/8d5494eef01f3a291bf6bec89b25bc315c607cfd.jpg",
    "pic_s260": "http://hiphotos.qianqian.com/ting/pic/item/8b13632762d0f7035cb3feda0afa513d2697c5b7.jpg",
    "pic_s210": "http://business.cdn.qianqian.com/qianqian/pic/bos_client_ad19dd0cd653dbf9b2fca05b5ae6f87f.jpg",
    "content": [
    {
    "title": "New Silk Road",
    "author": "Maksim",
    "song_id": "573313333",
    "album_id": "573313330",
    "album_title": "New Silk Road",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "lossless,perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/d5dee954c872320a210a326180425cfc/591310208/591310208.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/d5dee954c872320a210a326180425cfc/591310208/591310208.jpg@s_2,w_150,h_150"
    },
    {
    "title": "Симфония № 4（交响乐4号）",
    "author": "Vitas",
    "song_id": "590762992",
    "album_id": "590762988",
    "album_title": "20",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "lossless,perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/4d475c81e4c562301e21c2d102165205/590761655/590761655.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/4d475c81e4c562301e21c2d102165205/590761655/590761655.jpg@s_2,w_150,h_150"
    },
    {
    "title": "因为爱情 (法语版)",
    "author": "弗雷德乐队",
    "song_id": "65626244",
    "album_id": "65626242",
    "album_title": "致青春 (法语版)",
    "rank_change": "0",
    "all_rate": "96,128,224,320",
    "biaoshi": "perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/88411609/88411609.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/88411609/88411609.jpg@s_2,w_150,h_150"
    },
    {
    "title": "Dogs",
    "author": "I WEAR* EXPERIMENT乐队",
    "song_id": "588688244",
    "album_id": "588688241",
    "album_title": "Dogs",
    "rank_change": "0",
    "all_rate": "96,128,224,320,flac",
    "biaoshi": "lossless,vip,perm-1",
    "pic_small": "http://qukufile2.qianqian.com/data2/pic/3aa6422af908cf869262f9c75f3c3530/588688242/588688242.jpg@s_2,w_90,h_90",
    "pic_big": "http://qukufile2.qianqian.com/data2/pic/3aa6422af908cf869262f9c75f3c3530/588688242/588688242.jpg@s_2,w_150,h_150"
    }
    ],
    "color": "0x4A90E2",
    "bg_color": "0xEDF4FC",
    "bg_pic": "http://business0.qianqian.com/qianqian/file/5bfe4e726acbc_309.png"
    }
    ],
    "error_code": 22000
}
"""

func MJJSON() {
    let jsonData22222 = json22222.data(using: .utf8)!
    let json222 = try? JSONSerialization.jsonObject(with: jsonData22222, options: JSONSerialization.ReadingOptions.allowFragments)
    let song = LYMSong(try? JSON(data: jsonData22222))
//    let song = LYMSong.mj_object(withKeyValues: json222)

    print(song)
}

