//
//  MGPhotoConfig.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/5.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit

/// 相机胶卷
let ConfigurationCameraRoll : String = "Camera Roll"
/// iOS10.2后将Camera Roll变为了All Photos
let ConfigurationAllPhotos : String = "All Photos"
/// 隐藏
let ConfigurationHidden : String = "Hidden"
/// 慢动作
let ConfigurationSlo_mo : String = "Slo-mo"
/// 屏幕快照
let ConfigurationScreenshots : String = "Screenshots"
/// 视频
let ConfigurationVideos : String = "Videos"
/// 全景照片
let ConfigurationPanoramas : String = "Panoramas"
/// 定时拍照
let ConfigurationTime_lapse : String = "Time-lapse"
/// 最近添加
let ConfigurationRecentlyAdded : String = "Recently Added"
/// 最近删除
let ConfigurationRecentlyDeleted : String = "Recently Deleted"
/// 快照连拍
let ConfigurationBursts : String = "Bursts"
/// 喜欢
let ConfigurationFavorite : String = "Favorite"
/// 自拍
let ConfigurationSelfies : String = "Selfies"


class MGPhotoConfig: NSObject {
    /// 配置选项，默认为如下
    static var groupNames : [String] = [

        NSLocalizedString(ConfigurationCameraRoll, comment: ""),
        NSLocalizedString(ConfigurationAllPhotos, comment: ""),
        NSLocalizedString(ConfigurationSlo_mo, comment: ""),
        NSLocalizedString(ConfigurationScreenshots, comment: ""),
        NSLocalizedString(ConfigurationVideos, comment: ""),
        NSLocalizedString(ConfigurationPanoramas, comment: ""),
        NSLocalizedString(ConfigurationRecentlyAdded, comment: ""),
        NSLocalizedString(ConfigurationSelfies, comment: ""),

        ]


    /// 获得的配置选项
    var groups : [String]{

        get{
            return MGPhotoConfig.groupNames
        }

    }


    override init()
    {
        super.init()
    }


    convenience init(groupnames:[String]!)
    {
        self.init()

        MGPhotoConfig.groupNames = groupnames
        //本地化
        localizeHandle()

    }



    /// 本地化语言处理
    func localizeHandle()
    {
        let localizedHandle = MGPhotoConfig.groupNames

        let finalHandle = localizedHandle.map { (configurationName) -> String in

            return NSLocalizedString(configurationName, comment: "")

        }

        MGPhotoConfig.groupNames = finalHandle
    }
}

