//  MGProfileViewController.swift
//  MGBookViews
//  Created by i-Techsys.com on 2017/8/19.
//  Copyright © 2017年 i-Techsys. All rights reserved.
// https://github.com/LYM-mg
// http://www.jianshu.com/u/57b58a39b70e

import UIKit

class MGProfileViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate {

    weak var scrollView: MGScrollView?
    weak var dynamicTableView: MGTableView?
    weak var articleTableView: MGTableView?
    weak var moreTableView: MGTableView?
    weak var headerView:UIView?             // 头部
    weak var titleView:MGProfileTitlesView? // 头部下的titleView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = []
        setupContentView()
        setupHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print(#file, #function)
        MGLog(#file,#function,"\(#line)")
        MGLog("dsa")
    }
    
    func setupContentView() {
        let scrollView: MGScrollView = {
            let scrollView = MGScrollView(frame: self.view.frame)
            scrollView.delaysContentTouches = false
            view.addSubview(scrollView)
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            scrollView.contentSize = CGSize(width: MGScreenW * 3, height: 0)
            scrollView.backgroundColor = UIColor.red
            let _ = scrollView.subviews.map {
                $0.removeFromSuperview()
            }
            return scrollView
        }()
        self.scrollView = scrollView
        
        let tableHeaderView = UIView() // 占位的头部tableViewheaderView
//        tableHeaderView.alpha = 0.0
        tableHeaderView.frame = CGRect(x: 0, y: 0, width: MGScreenW, height: MGHeadViewHeight + MGTitleHeight)
        
        let dynamicTableView: MGTableView = MGTableView(type: .dynamic)
        scrollView.addSubview(dynamicTableView)
        dynamicTableView.delegate = self
        dynamicTableView.separatorStyle = .none
        dynamicTableView.tableHeaderView = tableHeaderView
        dynamicTableView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.width.equalTo(MGScreenW)
            make.top.bottom.equalTo(view)
        })
        self.dynamicTableView = dynamicTableView
        
        let articleTableView: MGTableView =  MGTableView(type: .art)
        scrollView.addSubview(articleTableView)
        articleTableView.delegate = self
        articleTableView.separatorStyle = .none
        articleTableView.tableHeaderView = tableHeaderView
        articleTableView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(MGScreenW)
            make.width.equalTo(MGScreenW)
            make.top.bottom.equalTo(view)
        })
        self.articleTableView = articleTableView
        
        
        let moreTableView: MGTableView = {
            let moreTableView = MGTableView(type: .more)
            scrollView.addSubview(moreTableView)
            moreTableView.delegate = self
            moreTableView.separatorStyle = .none
            moreTableView.tableHeaderView = tableHeaderView
            moreTableView.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(2*MGScreenW)
                make.width.equalTo(MGScreenW)
                make.top.bottom.equalTo(view)
            })
            return moreTableView
        }()
        self.moreTableView = moreTableView
    }
    
    func setupHeaderView() {
        let headerView: UIView = MGProfileHeaderView(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: MGHeadViewHeight + MGTitleHeight))
        view.addSubview(headerView)
        self.headerView = headerView
        let titleView = MGProfileTitlesView()
        headerView.addSubview(titleView)
        titleView.backgroundColor = UIColor.clear
        self.titleView = titleView
        titleView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(MGTitleHeight)
        }
       
        weak var weakSelf = self
        titleView.titles = ["动态", "文章", "更多"]
        titleView.selectedIndex = 0
        titleView.buttonSelected = {(_ index: Int) -> Void in
            weakSelf?.scrollView!.setContentOffset(CGPoint(x: MGScreenW * CGFloat(index), y: 0), animated: true)
        }
    }
}

extension MGProfileViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let contentOffsetX: CGFloat = scrollView.contentOffset.x
            let pageNum: Int = Int(contentOffsetX / MGScreenW + 0.5)
            titleView?.setSelectedIndex(selectedIndex: pageNum)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView  || (scrollView.window == nil){
            return
        }
        
        let offsetY: CGFloat = scrollView.contentOffset.y
        var originY: CGFloat = 0
        var otherOffsetY: CGFloat = 0
        if offsetY <= MGHeadViewHeight {
            originY = -offsetY
            if offsetY < 0 {
                otherOffsetY = 0
            }else {
                otherOffsetY = offsetY
            }
        }else {
            originY      = -MGHeadViewHeight
            otherOffsetY = MGHeadViewHeight
        }
        
        // 滚动时头部做相应变化
        self.headerView?.frame = CGRect(x: 0, y: originY, width: MGScreenW, height: MGHeadViewHeight + MGTitleHeight)
        
        // 其他不在窗口的2个tableView做相应的滚动
        for (i,contentView) in self.scrollView!.subviews.enumerated() {
            if (i != self.titleView!.selectedIndex) {
                let offset = CGPoint(x: 0, y: otherOffsetY)
                if contentView is UITableView {
                    let contentView = contentView as! UITableView
                    if contentView.contentOffset.y < MGHeadViewHeight || offset.y < MGHeadViewHeight {
                        contentView.setContentOffset(offset, animated: false)
//                        self.scrollView?.offset = offset
                        print("最后距离：\(originY)")
                    }
                    
                }
            }
        }
    }
}
