//
//  MGPhotosCell.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit

class MGPhotosCell: UICollectionViewCell {
    typealias MGPhotoCellOperationClosure = ((MGPhotosCell) -> Void)
    let mg_deselectedImage = UIImage(named: "MGDeselected")
    let mg_selectedImage  = UIImage(named: "MGSelected")

    /// control对象点击的闭包
    var chooseImageDidSelectHandle:MGPhotoCellOperationClosure?


    /// 显示图片的背景图片
    lazy var mg_imageView : UIImageView = {

        var imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white

        return imageView

    }()


    /// 显示信息的视图，比如视频的时间长度，默认hidden = true
    lazy var mg_messageView : UIView = {

        let view = UIView()

        view.isHidden = true
        view.backgroundColor = .black

        return view

    }()


    /// 显示在mg_messageView上显示时间长度的标签
    lazy var mg_messageLabel : UILabel = {

        var messageLabel = UILabel()
        messageLabel.font = .systemFont(ofSize: 11)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .right
        messageLabel.text = "00:25"

        return messageLabel

    }()


    /// 模拟显示选中的按钮
    lazy var mg_chooseImageView : UIImageView = {

        var chooseImageView = UIImageView()
        chooseImageView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        chooseImageView.layer.cornerRadius = 25 / 2.0
        chooseImageView.clipsToBounds = true
        chooseImageView.image = mg_deselectedImage

        return chooseImageView

    }()


    /// 模拟响应选中状态的control对象
    lazy var mg_chooseControl : UIControl = {

        var chooseControl = UIControl()
        chooseControl.backgroundColor = .clear

        chooseControl.action(at: .touchUpInside, handle: { [weak self](sender) in

            if let strongSelf = self,strongSelf.chooseImageDidSelectHandle != nil {
                //响应选择回调
                strongSelf.chooseImageDidSelectHandle?(strongSelf)
            }
        })

        return chooseControl

    }()


    override init(frame: CGRect){

        super.init(frame: frame)
        addAndLayoutSubViews()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }


    override func awakeFromNib() {

        super.awakeFromNib()
        addAndLayoutSubViews()
    }



    /// cell进行点击
    ///
    /// - Parameter isSelected: 当前选中的状态
    func selected(_ isSelected:Bool)
    {
        mg_chooseImageView.image = !isSelected ? mg_deselectedImage :mg_selectedImage

        if isSelected {
            animatedForSelected()
        }
    }


    // MARK: private

    /// 选中动画
    fileprivate func animatedForSelected() {
        UIView.animate(withDuration: 0.2, animations: {
            self.mg_chooseImageView.transform = CGAffineTransform(scaleX: 1.2,y: 1.2)
        }) { (finish) in
            UIView.animate(withDuration: 0.2, animations: {
                self.mg_chooseImageView.transform = CGAffineTransform.identity

            })
        }
    }



    override func prepareForReuse() {

        mg_imageView.image = nil
        mg_chooseImageView.isHidden = false
        mg_messageView.isHidden = true
        mg_messageLabel.text = nil
        mg_chooseImageView.image = mg_deselectedImage
    }


    fileprivate func addAndLayoutSubViews(){

        // subviews
        self.contentView.addSubview(mg_imageView)
        self.contentView.addSubview(mg_messageView)
        self.contentView.addSubview(mg_chooseControl)
        mg_chooseControl.addSubview(mg_chooseImageView)
        mg_messageView.addSubview(mg_messageLabel)

        //layout
        mg_imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        mg_chooseControl.snp.makeConstraints { (make) in
            make.width.height.equalTo(45)
            make.right.bottom.equalToSuperview().inset(3)

        }

        mg_chooseImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.right.bottom.equalToSuperview()

        }


        mg_messageView.snp.makeConstraints {(make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(20)

        }

        mg_messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.mg_messageView.snp.left)
            make.right.equalTo(self.mg_messageView).inset(3)
            make.bottom.equalTo(self.mg_messageView)
            make.height.equalTo(20)
        }
    }
}
