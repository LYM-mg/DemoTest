//
//  MGPhotoGroupCell.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/5.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit
import SnapKit

class MGPhotoGroupCell: UITableViewCell {

    /// 显示图片的imageview
    lazy var mg_imageView: UIImageView = UIImageView()

    /// 分组名称
    lazy var mg_titleLabel: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        photoGroupCellInitlize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        photoGroupCellInitlize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    override func prepareForReuse() {
        super.prepareForReuse()

        self.mg_imageView.image = nil
        self.mg_titleLabel.text = ""
    }


    private func photoGroupCellInitlize() {
        setUpUI()
    }



    private func setUpUI() {
        mg_imageView.contentMode = .scaleAspectFill
        mg_imageView.clipsToBounds = true
        mg_imageView.isUserInteractionEnabled = true
        contentView.addSubview(mg_imageView)

        mg_titleLabel.font = .systemFont(ofSize: 15)
        contentView.addSubview(mg_titleLabel)

        mg_imageView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.width.equalTo(mg_imageView.snp.height)
        })


        mg_titleLabel.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
        make.left.equalTo(mg_imageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)

        })
    }

}
