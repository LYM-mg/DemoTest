//
//  UIView+MGBadge.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/10.
//  Copyright © 2019 firestonetmt. All rights reserved.
//

import UIKit

let kMGBadgeDefaultRadius: CGFloat = 3.0
let kMGBadgeDefaultMaximumBadgeNumber = 88
let kMGBadgeDefaultFont = UIFont.boldSystemFont(ofSize: 9)

extension UIView: MGBadgeProtocol {
    // MARK: - property
    var badge: UILabel? {
        get {
            var bLabel = objc_getAssociatedObject(self, RuntimeKey.mg_BadgeKey!) as? UILabel
            if (bLabel == nil) {
                let width: CGFloat = kMGBadgeDefaultRadius * 2
                let rect = CGRect(x: frame.width, y: -width, width: width, height: width)
                bLabel = UILabel(frame: rect)
                bLabel!.textAlignment = .center
                bLabel!.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
                bLabel!.textColor = UIColor.white
                bLabel!.font = kMGBadgeDefaultFont
                bLabel!.text = ""
                // CGFloat offsetX     = CGRectGetWidth(self.frame) + 2 + self.badgeOffset.x;
                // bLabel.center       = CGPointMake(offsetX, self.badgeOffset.y);

                bLabel!.layer.cornerRadius = kMGBadgeDefaultRadius
                bLabel!.layer.masksToBounds = true
                bLabel!.isHidden = true

                objc_setAssociatedObject(self, RuntimeKey.mg_BadgeKey!, bLabel, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                addSubview(bLabel!)
                bringSubviewToFront(bLabel!)
            }
            return bLabel
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.mg_BadgeKey!, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var badgeFont: UIFont? {
        get {
            let font = objc_getAssociatedObject(self, RuntimeKey.mg_BadgeFontKey!) as? UIFont
            return font ?? kMGBadgeDefaultFont
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.mg_BadgeFontKey!, badgeFont, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.badge?.font = badgeFont;
        }
    }

    var badgeTextColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.mg_BadgeTextColorKey!) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.mg_BadgeTextColorKey!, badgeTextColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.badge?.textColor = badgeTextColor;
        }
    }

    var badgeBgColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.mg_BadgeBgColorKey!) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.mg_BadgeBgColorKey!, badgeBgColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.badge?.backgroundColor = badgeBgColor;
        }
    }

    var badgeRadius: CGFloat {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.mg_BadgeRadiusKey!) as? CGFloat ?? kMGBadgeDefaultRadius
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.mg_BadgeRadiusKey!, badgeRadius, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.badge?.layer.cornerRadius = badgeRadius;
        }
    }

    var badgeOffset: CGPoint {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.mg_BadgeOffsetKey!) as? CGPoint ?? .zero
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.mg_BadgeOffsetKey!, badgeOffset, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }


    var badgeCustomView: UIView? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.mg_BadgeCustomViewKey!) as? UIView
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.mg_BadgeCustomViewKey!, badgeCustomView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var badgeImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.mg_BadgeImageKey!) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.mg_BadgeImageKey!, badgeImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }


    // MARK: - Function
    /// 隐藏
    func hideBadge() {
        if (badgeCustomView != nil) {
            badgeCustomView?.isHidden = true
        }
        badge?.isHidden = true
    }

    func showBadge() {
        if frame.equalTo(CGRect.zero) {
            layoutIfNeeded()
        }
        let offsetX: CGFloat = frame.width + 2 + badgeOffset.x
        let center = CGPoint(x: offsetX, y: badgeOffset.y)

        if let badgeCustomView = badgeCustomView {
            badgeCustomView.isHidden = false
            badge?.isHidden = true
            badgeCustomView.center = center
        } else {
            let w: CGFloat = (badgeRadius) * 2
            let r = CGRect(x: frame.width, y: -w, width: w, height: w)

            badge?.frame = r
            badge?.text = ""
            badge?.isHidden = false
            badge?.layer.cornerRadius = w / 2
            badge?.center = center
        }
    }

    func showBadge(_ value: Int) {
        if frame.equalTo(CGRect.zero) {
            layoutIfNeeded()
        }
        badgeCustomView?.isHidden = true

        if let badge = badge {
            badge.isHidden = value == 0
            badge.font = badgeFont
            badge.text = value > kMGBadgeDefaultMaximumBadgeNumber ? "\(NSNumber(value: kMGBadgeDefaultMaximumBadgeNumber))+" : "\(NSNumber(value: value))"
            adjustLabelWidth(badge)

            var width = badge.frame.size.width
            var height = badge.frame.size.height
            width += 4
            height += 4

            if width < height {
                width = height
            }else {
                 height = width
            }
            badge.frame.size.width = width
            badge.frame.size.height = height
            let offsetX: CGFloat = self.frame.width + 2 + badgeOffset.x
            badge.center = CGPoint(x: offsetX, y: badgeOffset.y)
            badge.layer.cornerRadius = badge.frame.height / 2.0
        }
    }

    func adjustLabelWidth(_ label: UILabel?) {
        label?.numberOfLines = 0
        let s = label?.text
        let font: UIFont? = label?.font
        let size = CGSize(width: 320, height: CGFloat.greatestFiniteMagnitude)
        var labelsize: CGSize = label?.frame.size ?? .zero

        let style = NSParagraphStyle.default
        label?.lineBreakMode = NSLineBreakMode.byWordWrapping
        if let font = font,let s = s {
            labelsize = s.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.paragraphStyle: style
                ], context: nil).size
        }


        labelsize = CGSize(width:CGFloat(ceilf(Float(labelsize.width))),
                             height: CGFloat(ceilf(Float(labelsize.height))))
        let r = CGRect(x: frame.width-labelsize.width/2, y: -labelsize.height/2, width: labelsize.width, height: labelsize.height)
        badge?.frame = r
    }
}

// 改进写法【推荐】
fileprivate struct RuntimeKey {
    static let mg_BadgeKey = UnsafeRawPointer.init(bitPattern: "badge".hashValue)
    static let mg_BadgeFontKey = UnsafeRawPointer.init(bitPattern: "badgeFont".hashValue)
    static let mg_BadgeTextColorKey = UnsafeRawPointer.init(bitPattern: "badgeTextColor".hashValue)
    static let mg_BadgeBgColorKey = UnsafeRawPointer.init(bitPattern: "badgeBgColor".hashValue)
    static let mg_BadgeRadiusKey = UnsafeRawPointer.init(bitPattern: "badgeRadius".hashValue)
    static let mg_BadgeOffsetKey = UnsafeRawPointer.init(bitPattern: "badgeOffset".hashValue)
    static let mg_BadgeCustomViewKey = UnsafeRawPointer.init(bitPattern: "badgeCustomView".hashValue)
    static let mg_BadgeImageKey = UnsafeRawPointer.init(bitPattern: "badgeImage".hashValue)
    /// ...其他Key声明
}
