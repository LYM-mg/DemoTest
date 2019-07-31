//
//  MGPhotosBrowseCell.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/8.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit

class MGPhotosBrowseCell: UICollectionViewCell {
    
    // MARK: public
    /// 显示图片的imageView
    lazy var mg_imageView : UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit

        return imageView
    }()


    /// 单击执行的闭包
    var mg_photoBrowerSimpleTapHandle:((Any)-> Void)?



    // MARK: private

    /// 是否已经缩放
    fileprivate var isScale = false

    /// 底部负责缩放的滚动视图
    lazy fileprivate var mg_scrollView : UIScrollView = {

        let scrollView = UIScrollView()

        scrollView.backgroundColor = .black
        scrollView.minimumZoomScale = CGFloat(self.minScaleZoome)
        scrollView.maximumZoomScale = CGFloat(self.maxScaleZoome)
        scrollView.delegate = self

        return scrollView
    }()

    /// 单击手势
    lazy fileprivate var mg_simpleTap : UITapGestureRecognizer = {

        let simpleTap = UITapGestureRecognizer()

        simpleTap.numberOfTapsRequired = 1
        simpleTap.require(toFail: self.mg_doubleTap)

        //设置响应
        simpleTap.action({ [weak self](sender) in

            if let strongSelf = self {
                if strongSelf.mg_photoBrowerSimpleTapHandle != nil {
                    //执行闭包
                    strongSelf.mg_photoBrowerSimpleTapHandle?(strongSelf)
                }
            }

            /********** 此处不再返回原始比例，如需此功能，请清除此处注释 2019/7/8 ***********/
            /*
             if strongSelf!.mg_scrollView.zoomScale != 1.0 {

             strongSelf!.mg_scrollView.setZoomScale(1.0, animated: true)
             }
             */
            /*************************************************************************/

        })


        return simpleTap
    }()

    /// 双击手势
    lazy fileprivate var mg_doubleTap : UITapGestureRecognizer = {

        let doubleTap = UITapGestureRecognizer()

        doubleTap.numberOfTapsRequired = 2

        doubleTap.action({ [weak self](sender) in

            let strongSelf = self

            //表示需要缩放成1.0
            guard strongSelf!.mg_scrollView.zoomScale == 1.0 else {

                strongSelf!.mg_scrollView.setZoomScale(1.0, animated: true); return
            }

            //进行放大
            let width = strongSelf!.frame.width
            let scale = width / CGFloat(strongSelf!.maxScaleZoome)
            let point = sender.location(in: strongSelf!.mg_imageView)

            //对点进行处理
            let originX = max(0, point.x - width / scale)
            let originY = max(0, point.y - width / scale)

            //进行位置的计算
            let rect = CGRect(x: originX, y: originY, width: width / scale, height: width / scale)

            //进行缩放
            strongSelf!.mg_scrollView.zoom(to: rect, animated: true)

        })

        return doubleTap
    }()

    /// 最小缩放比例
    fileprivate let minScaleZoome = 1.0

    /// 最大缩放比例
    fileprivate let maxScaleZoome = 2.0


    override init(frame: CGRect) {

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


    fileprivate func addAndLayoutSubViews() {
        contentView.addSubview(mg_scrollView)

        mg_scrollView.addSubview(mg_imageView)
        mg_scrollView.addGestureRecognizer(mg_simpleTap)
        mg_scrollView.addGestureRecognizer(mg_doubleTap)

        //layout
        mg_scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }

        mg_imageView.snp.makeConstraints { [weak self](make) in

            let strongSelf = self

            make.edges.equalToSuperview()
            make.width.equalTo(strongSelf!.mg_scrollView.snp.width)
            make.height.equalTo(strongSelf!.mg_scrollView.snp.height)
        }
    }
}



extension MGPhotosBrowseCell : UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mg_imageView
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {

        scrollView.setZoomScale(scale, animated: true)
    }
}

