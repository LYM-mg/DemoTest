//
//  MGDocumentInteractionVC.swift
//  indexView
//
//  Created by i-Techsys.com on 17/3/21.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

class MGDocumentInteractionVC: UIViewController {
    // SB属性
    @IBOutlet weak var documentBtn: UIButton!
    @IBOutlet weak var ActivityViewBtn: UIButton!
    
    // 自定义属性
    fileprivate var i = 0
    fileprivate var documentController: UIDocumentInteractionController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentBtn.titleLabel?.numberOfLines = 2
        ActivityViewBtn.titleLabel?.numberOfLines = 2
        documentBtn.titleLabel?.textAlignment = .center
        ActivityViewBtn.titleLabel?.textAlignment = .center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let urlStr = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1044917946&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        guard let url = URL(string: urlStr) else { return }
        
        if UIApplication.shared.canOpenURL(url){
            if #available(iOS 10.0, *) {
                let options = [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : true]
                UIApplication.shared.open(url, options: options, completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

// MARK: - Action
extension MGDocumentInteractionVC {
    // DocumentInteraction读取PDF文档
    @IBAction func DocumentInteraction读取PDF文档() {
        if let url = Bundle.main.url(forResource: "Swift_Apprentice_v2.0.pdf", withExtension: nil) {
            documentController = UIDocumentInteractionController(url: url)
            documentController?.delegate = self
        }
        
        if i == 0 {
            presentPreview()
        } else if i == 1{
            presentOpenInMenu()
        } else {
            presentOptionsMenu()
        }
        
        i += 1
        if i > 2 {
            i = 0
        }
    }
    
     // ActivityView读取PDF文档
    @IBAction func ActivityView读取PDF文档() {
        let image = #imageLiteral(resourceName: "m_3_100")
        let str = "hello iOS9"
        let url = NSURL(string: "http://www.jianshu.com/u/57b58a39b70e")
        let items:[Any] = [image, str, url!]
        
        //
        let activity = UIActivityViewController(activityItems: items, applicationActivities: [MGCustomActivity(),WeiboActivity(),WechatSessionActivity(),WechatTimelineActivity(),CopyLinkActivity()])
        // .copyToPasteboard,.copyToPasteboard,.message,.print,UIActivityType.airDrop,,.postToWeibo,.postToVimeo,.postToTencentWeibo,.mail,.assignToContact,.postToFacebook,.openInIBooks,.postToTwitter
        // 不出现在活动项目
        if #available(iOS 9.0, *) {
            activity.excludedActivityTypes = [.addToReadingList]
        }
        let popver: UIPopoverPresentationController? = activity.popoverPresentationController
        if (popver != nil) {
            popver!.sourceView = self.ActivityViewBtn
            popver!.permittedArrowDirections = UIPopoverArrowDirection.left
        }
        self.present(activity, animated: true, completion: nil)
        

        activity.completionWithItemsHandler = { (type, completed, result, err)  in
            if completed {
                self.alert(msg: "成功")
            }
            activity.completionWithItemsHandler = nil
        }
    }
    
    func alert(msg: String!) {
        let alertControler = UIAlertController(title: "提示", message: msg, preferredStyle: UIAlertController.Style.alert)
        self.present(alertControler, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alertControler.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UIDocumentInteractionControllerDelegate
extension MGDocumentInteractionVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

// MARK: -
// MARK: - private
extension MGDocumentInteractionVC {
    // 直接打开文件
    fileprivate func presentPreview() {
        documentController?.presentPreview(animated: true)
    }
    
    fileprivate func presentOpenInMenu() {
        documentController?.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
    }
    
    // 可以快速查看，以及copy 打印操作
    fileprivate func presentOptionsMenu() {
        documentController?.presentOptionsMenu(from: self.view.bounds, in: self.view, animated: true)
    }
}


