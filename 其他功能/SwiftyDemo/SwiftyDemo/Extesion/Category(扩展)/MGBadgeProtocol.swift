//
//  MGBadgeProtocol.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/10.
//  Copyright © 2019 firestonetmt. All rights reserved.
//

import UIKit

/**
 priority: number > custom view > red dot
 */
#if !MGBadgeProtocol_h

protocol MGBadgeProtocol: NSObjectProtocol {
    var badge: UILabel? { get set }
    var badgeFont: UIFont? { get set }
    /* default bold size 9 */
    var badgeTextColor: UIColor? { get set }
    /* default white color */
    var badgeBgColor: UIColor? { get set }
    var badgeRadius: CGFloat { get set }
    /* for red dot mode */
    var badgeOffset: CGPoint { get set }
    // offset from right-top */
    var badgeCustomView: UIView? { get set }
    /**
     convenient interface:
     create 'cusomView' (UIImageView) using badgeImage
     view's size would simply be set as half of image.
     */
    var badgeImage: UIImage? { get set }
    func showBadge() // badge with red dot
    func hideBadge()
    // badge with number, pass zero to hide badge
    func showBadge(_ value: Int)
}
#endif
