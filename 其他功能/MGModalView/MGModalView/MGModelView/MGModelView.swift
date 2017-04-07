//
//  MGModelView.swift
//  MGModalView
//
//  Created by i-Techsys.com on 17/4/7.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

typealias MGModalViewWillCloseBlock = ()->()

class MGModelView: UIView {
    
    // MARK: - 接口
    var modelViewWillCloseBlock:MGModalViewWillCloseBlock?
    var modelViewDidCloseBlock:MGModalViewWillCloseBlock?
    var baseViewController: UIViewController?
    var narrowedOff: Bool = false
    
    lazy var contentView: UIView = { [unowned self] in
        let contentView = UIView(frame: CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height))
        contentView.backgroundColor = UIColor.white
        return contentView
        }()
    
    // MARK: - LAZY
    fileprivate lazy var maskImageView: UIImageView = {
        let maskImageView = UIImageView(frame: CGRect(origin: .zero,size: self.frame.size))
        return maskImageView
    }()

    fileprivate lazy var closeControl: UIControl = { [unowned self] in
        let closeControl  = UIControl(frame: self.bounds)
        closeControl.isUserInteractionEnabled = false
        closeControl.backgroundColor = UIColor.clear
        closeControl.addTarget(self, action: #selector(close), for: .touchUpInside)
        return closeControl
    }()
    


    // MARK: - 系统方法、以及相关封装方法
    convenience init(size: CGSize, andBaseViewController baseViewController: UIViewController) {
        self.init()
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black
        addSubview(maskImageView)
        addSubview(closeControl)
        addSubview(contentView)
        self.contentView.frame  = contentViewFrameWithSize(size: size)
        self.baseViewController = baseViewController;
        if (self.baseViewController != nil) {
            self.baseViewController!.view.insertSubview(self, at: 0)
            self.baseViewController!.view.sendSubview(toBack: self)
        }
    }
    
    fileprivate func contentViewFrameWithSize(size: CGSize) -> CGRect {
        var size = size
        if (size.height > UIScreen.main.bounds.size.height) {
            size.height = UIScreen.main.bounds.size.height;
        }
        if (size.width > UIScreen.main.bounds.size.width) {
            size.width = UIScreen.main.bounds.size.width;
        }
        return CGRect(origin: CGPoint(x: 0,y: self.frame.size.height), size: size)
    }
}

// MARK: - 打开和关闭的方法
extension MGModelView {
    // 关闭🔚
    @objc fileprivate func close() {
        if ((self.modelViewWillCloseBlock) != nil) {
            self.modelViewWillCloseBlock!();
        }
        if (self.narrowedOff) {
            var t: CATransform3D = CATransform3DIdentity
            t.m34 = -0.005
            self.maskImageView.layer.transform = t
            self.closeControl.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25, animations: { 
                self.maskImageView.alpha = 1;
                self.contentView.frame = CGRect(x:0,
                                                y:self.frame.size.height,
                                                width:self.contentView.frame.size.width,
                                                height:self.contentView.frame.size.height)
                
                }, completion: { (_) in
                    if ((self.modelViewDidCloseBlock) != nil) {
                        self.modelViewDidCloseBlock!();
                    }
                    if ((self.baseViewController) != nil) {
                        if ((self.baseViewController?.navigationController) != nil) {
                            self.transNavigationBarToHide(hide: false)
                        }
                        self.baseViewController?.view.sendSubview(toBack: self)
                    }

            })
           
            UIView.animate(withDuration: 0.25, animations: {
                self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
                self.maskImageView.layer.transform = CATransform3DRotate(t, CGFloat(7/90.0 * M_PI_2), 1, 0, 0);
                }, completion: { (_) in
                   UIView.animate(withDuration: 0.2, animations: { 
                        self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, 0, 0);
                   })
            })

        } else {
            self.closeControl.isUserInteractionEnabled = false;
            UIView.animate(withDuration: 0.25, animations: { 
                self.maskImageView.alpha = 1;
                self.contentView.frame = CGRect(x:0,
                                                y:self.frame.size.height,
                                                width:self.contentView.frame.size.width,
                                               height:self.contentView.frame.size.height)            }, completion: { (_) in
                if ((self.modelViewDidCloseBlock) != nil) {
                    self.modelViewDidCloseBlock!();
                }
                if ((self.baseViewController) != nil) {
                    self.baseViewController?.view.sendSubview(toBack: self)
                    if ((self.baseViewController?.navigationController) != nil) {
                        self.baseViewController?.navigationController?.isNavigationBarHidden = false;
                    }
                }

            })
        }
    }
    
    
    /// 打开🔛
    public func open() {
        if (self.narrowedOff) {
            var t: CATransform3D = CATransform3DIdentity
            t.m34 = -0.005
            self.maskImageView.layer.transform = t
            self.maskImageView.layer.zPosition = -9999
            self.maskImageView.image = snapshotWithWindow()
            
            if ((self.baseViewController) != nil) {
                self.baseViewController?.view.bringSubview(toFront: self)
            }
            self.closeControl.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5, animations: { 
                self.maskImageView.alpha = 0.5;
                self.contentView.frame = CGRect(x:0,
                                                y:UIScreen.main.bounds.size.height - self.contentView.bounds.size.height,
                                                width:self.contentView.frame.size.width,
                                                height:self.contentView.frame.size.height);
            })
            
            UIView.animate(withDuration: 0.35, animations: {
                self.maskImageView.layer.transform = CATransform3DRotate(t, CGFloat(7/90.0 * M_PI_2), 1, 0, 0)
                if ((self.baseViewController) != nil) {
                    if ((self.baseViewController?.navigationController) != nil) {
                        self.transNavigationBarToHide(hide: true)
                    }
                }
            }, completion: { (_) in
                UIView.animate(withDuration: 0.23, animations: { 
                    self.maskImageView.layer.transform = CATransform3DTranslate(t, 0, -50, -50);
                })
            })
        }else {
            self.maskImageView.image = snapshotWithWindow()
            if ((self.baseViewController) != nil) {
                self.baseViewController?.view.bringSubview(toFront: self)
            }
            self.closeControl.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25, animations: { 
                self.maskImageView.alpha = 0.25;
                self.contentView.frame = CGRect(x:0,
                                                y:UIScreen.main.bounds.size.height - self.contentView.bounds.size.height,
                                                width:self.contentView.frame.size.width,
                                                height:self.contentView.frame.size.height);
                if ((self.baseViewController) != nil) {
                    if ((self.baseViewController?.navigationController) != nil) {
                        self.baseViewController!.navigationController!.isNavigationBarHidden = true
                    }
                }
            })
        }
    }
    
    /// 从窗口截取一张照片
    fileprivate func snapshotWithWindow() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(UIApplication.shared.keyWindow!.bounds.size, true, 1)
        UIApplication.shared.keyWindow?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    // 是否有导航栏判断偏移量
    fileprivate func transNavigationBarToHide(hide: Bool){
        if (hide) {
            let frame = self.baseViewController?.navigationController?.navigationBar.frame;
            setNavigationBarOriginY(y: -frame!.size.height, animated: false)
           
        } else {
            setNavigationBarOriginY(y: statusBarHeight(), animated: false)
        }
    }
    
    // 状态栏的高度
    fileprivate func statusBarHeight() -> CGFloat {
        let statuBarFrameSize = UIApplication.shared.statusBarFrame.size;
        if #available(iOS 8.0, *) {
            return statuBarFrameSize.height
        }
        return UIInterfaceOrientationIsPortrait(self.baseViewController!.interfaceOrientation) ? statuBarFrameSize.height : statuBarFrameSize.width;
    }
    
    
    fileprivate func setNavigationBarOriginY(y: CGFloat, animated: Bool) {
        let appKeyWindow                = UIApplication.shared.keyWindow
        let appBaseView                 = appKeyWindow?.rootViewController?.view
        let viewControllerFrame         = appBaseView?.convert((appBaseView?.bounds)!, to: appKeyWindow)
        let overwrapStatusBarHeight     = statusBarHeight() - (viewControllerFrame?.origin.y)!
        var frame                       = self.baseViewController!.navigationController!.navigationBar.frame
        frame.origin.y                  = y
        let navBarHiddenRatio           = overwrapStatusBarHeight > 0 ? (overwrapStatusBarHeight - frame.origin.y) / overwrapStatusBarHeight : 0
        let alpha                   = max(1 - navBarHiddenRatio, 0.000001)

        UIView.animate(withDuration: animated ? 0.1 : 0) { 
            self.baseViewController?.navigationController?.navigationBar.frame = frame;
            var index: Int = 0;
            for view in self.baseViewController!.navigationController!.navigationBar.subviews {
                index += 1;
                if (index == 1 || view.isHidden || view.alpha <= 0.0) {continue}
                view.alpha = alpha
            }
           
            if #available(iOS 7.0, *) {
                let tintColor = self.baseViewController?.navigationController?.navigationBar.tintColor
                if ((tintColor) != nil) {
                    self.baseViewController?.navigationController?.navigationBar.tintColor = tintColor?.withAlphaComponent(alpha)
                }
            }
        }
    }
}
