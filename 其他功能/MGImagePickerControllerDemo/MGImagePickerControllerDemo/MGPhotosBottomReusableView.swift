//
//  MGPhotosBottomReusableView.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit

class MGPhotosBottomReusableView: UICollectionReusableView {
    /// 资源的数目
    var mg_numberOfAsset = 0 {
        willSet{
            self.mg_assetLabel.text = "共有\(newValue)张照片"
        }
    }


    /// 在标签上的自定义文字
    var mg_customText = "" {
        willSet{
            self.mg_assetLabel.text = newValue
        }
    }


    /// 显示title的标签
    lazy var mg_assetLabel : UILabel = {
        let assetLabel = UILabel()
        assetLabel.font = .systemFont(ofSize: 14)
        assetLabel.textAlignment = .center
        assetLabel.textColor = 0x6F7179.mg_color
        return assetLabel
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        mg_customText = ""
    }


    // MARK: private

    fileprivate func setUpUI() {
        self.addSubview(mg_assetLabel)
        //layout
        mg_assetLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
