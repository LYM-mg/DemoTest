//
//  PhotoClipView.swift
//  MGBookViews
//
//  Created by newunion on 2017/12/27.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class PhotoClipView: UIView {
    /** 图片加载后的初始位置 */
    fileprivate var norRect = CGRect.zero
    /** 裁剪框frame */
    fileprivate var showRect = CGRect.zero
    fileprivate var imageV: UIImageView?
    
    fileprivate var YMaxOffset: CGFloat = 0.0  //Y最大偏移
    fileprivate var YMinOffset: CGFloat = 0.0  //Y最小偏移
    fileprivate var YTotalOffset: CGFloat = 0.0
    
    fileprivate var XMaxOffset: CGFloat = 0.0  //X最大偏移
    fileprivate var XMinOffset: CGFloat = 0.0  //X最小偏移
    fileprivate var XTotalOffset: CGFloat = 1.0
    
    fileprivate let MaxSCale: CGFloat = 2.0  //最大缩放比例
    fileprivate let MinScale: CGFloat = 0.5  //最小缩放比例
    fileprivate var totalScale: CGFloat = 1.0
    
    /** 重新拍照block */
    var remakeBlock: (() -> Void)? = nil
    /** 裁剪完成block */
    var sureUseBlock: ((_ image: UIImage) -> Void)? = nil
    /** 用于裁剪的原始图片 */
    var image: UIImage? {
        didSet {
            if (image != nil) {
                let ret: CGFloat = image!.size.height / image!.size.width
                imageV!.height = imageV!.width * ret
                imageV!.center = center
                norRect = imageV!.frame
                imageV!.image = image
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpUI() {
        imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width))
        imageV!.isUserInteractionEnabled = true
        addSubview(imageV!)
        
        let coverView = PhotoClipCoverView(frame: bounds)
        coverView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGR(_:))))
        coverView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.pinGR(_:))))
        showRect = CGRect(x: 1, y: frame.size.height * 0.15, width: frame.size.width - 2, height: frame.size.width - 2)
        coverView.showRect = showRect
        addSubview(coverView)
        
        let bottomView = UIView(frame: CGRect(x: 0, y: frame.size.height - 60, width: frame.size.width, height: 60))
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        coverView.addSubview(bottomView)
        //重拍
        let remarkBtn = UIButton(type: .custom)
        remarkBtn.frame = CGRect(x: 10, y: 15, width: 60, height: 30)
        remarkBtn.setTitle("重拍", for: .normal)
        remarkBtn.setTitleColor(UIColor.white, for: .normal)
        remarkBtn.backgroundColor = UIColor.clear
        remarkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        remarkBtn.addTarget(self, action: #selector(self.remarkAction), for: .touchUpInside)
        bottomView.addSubview(remarkBtn)
        //使用照片
        let sureBtn = UIButton(type: .custom)
        sureBtn.frame = CGRect(x: bottomView.frame.size.width - 90, y: 15, width: 80, height: 30)
        sureBtn.setTitle("使用照片", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.backgroundColor = UIColor.clear
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sureBtn.addTarget(self, action: #selector(self.usePhotoAction), for: .touchUpInside)
        bottomView.addSubview(sureBtn)
    }
    
    func panGR(_ sender: UIPanGestureRecognizer) {
        XMinOffset = self.imageV!.width/4
        YMinOffset = self.imageV!.height/4

        let point: CGPoint = sender.translation(in: self)
        XTotalOffset += point.x
        YTotalOffset += point.y
        print("XMinOffset=\(XMinOffset)  YMinOffset =\(YMinOffset)")
        print("\(point.x) \(point.y)")
        print("XTotalOffset=\(XTotalOffset)  YTotalOffset =\(YTotalOffset)")
        if  (fabsf(Float(XTotalOffset))>Float(XMinOffset)) {
            XTotalOffset -= point.x
            YTotalOffset -= point.y
            return
        }
        if  (fabsf(Float(YTotalOffset))>Float(YMinOffset)) {
            XTotalOffset -= point.x
            YTotalOffset -= point.y
            return
        }
        
        imageV!.center = CGPoint(x: imageV!.center.x + point.x, y:  imageV!.center.y + point.y)
        sender.setTranslation(CGPoint.zero, in: self)
    }
    
    func pinGR(_ sender: UIPinchGestureRecognizer) {
        //重新设置缩放比例 1是正常缩放.小于1时是缩小(无论何种操作都是缩小),大于1时是放大(无论何种操作都是放大)
        let scale = sender.scale
        if scale > 1.0,totalScale > MaxSCale{
            return
        }
        //缩小情况
        if scale < 1.0,totalScale < MinScale{
            return
        }
        //每次缩放以上一次为标准
        imageV!.transform =  imageV!.transform.scaledBy(x: scale, y: scale)
        totalScale *= scale
        sender.scale = 1.0
    }


    // 重拍
    func remarkAction(){
        if remakeBlock != nil {
            remakeBlock!()
        }
    }
    
    // 使用照片
    func usePhotoAction(){
        guard self.image != nil else { return }
        let w: CGFloat = self.image!.size.width
        let h: CGFloat = self.image!.size.height
        let originX: CGFloat = (1 - showRect.size.width / norRect.size.width) / 2.0 * w
        let originY: CGFloat = (showRect.origin.y - norRect.origin.y) / norRect.size.height * h
        let clipW: CGFloat = showRect.size.width / norRect.size.width * w
        let clipH: CGFloat = showRect.size.height / norRect.size.height * h
        let clipRect = CGRect(x: originX, y: originY, width: clipW, height: clipH)
        let image: UIImage? = self.image(from: self.image!, in: clipRect)
        imageV?.image = image
        if sureUseBlock != nil {
            sureUseBlock!(image!)
        }
    }
    
    func image(from image: UIImage, in rect: CGRect) -> UIImage {
        //将UIImage转换成CGImageRef
        let sourceImageRef = image.cgImage
        //按照给定的矩形区域进行剪裁
        let newImageRef = sourceImageRef?.cropping(to: rect)
        //将CGImageRef转换成UIImage
        let newImage = UIImage(cgImage: newImageRef!)
        //返回剪裁后的图片
        return newImage
    }
}
