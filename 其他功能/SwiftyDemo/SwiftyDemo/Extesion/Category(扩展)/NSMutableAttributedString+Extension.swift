//
//  NSMutableAttributedString+Extension.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/4/12.
//  Copyright © 2019 firestonetmt. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {

    // MARK: - 设置字符串颜色
    func setForgroundColor(_ forgroundColor: UIColor) {
        setForgroundColor(forgroundColor, string: self.string)
    }

    func setForgroundColor(_ forgroundColor: UIColor, string: String) {

        addAttribute(.foregroundColor, value: forgroundColor, range: range(of: string))
    }

    // MARK: - 设置字符串背景颜色
    func setbackgroundColor(_ backgroundColor: UIColor) {
        setbackgroundColor(backgroundColor, string: string)
    }

    func setbackgroundColor(_ backgroundColor: UIColor, string: String) {
        addAttribute(.backgroundColor, value: backgroundColor, range: range(of: string))
    }

    // MARK: - 设置字符串大小
    func setFontSize(_ size: CGFloat) {
        setFontSize(size, string: string)
    }

    func setFontSize(_ size: CGFloat, string: String?) {
        let fontName = "PingFangSC-Light"
        let font = UIFont(name: fontName, size: size) ?? UIFont.boldSystemFont(ofSize: size)
        addAttribute(.font, value: font, range: range(of: string ?? ""))
    }

    func setBoldFontSize(_ size: CGFloat) {
        setBoldFontSize(size, string: string)
    }

    func setBoldFontSize(_ size: CGFloat, string: String?) {
        let fontName = "PingFangSC-Medium"
        let font = UIFont(name: fontName, size: size) ?? UIFont.boldSystemFont(ofSize: size)
        addAttribute(.font, value: font, range: range(of: string ?? ""))

    }

    // MARK: - 设置字符串间距
    func setKernOfSize(_ kernOfSize: CGFloat) {
        setKernOfSize(kernOfSize, string: self.string)
    }
    func setKernOfSize(_ kernOfSize: CGFloat, string: String?) {
        addAttribute(.kern, value: NSNumber(value: Float(kernOfSize)), range: range(of: string ?? ""))
    }

    // MARK: - 设置字符串描边宽度
    func setStrokeWidth(_ strokeWidth: CGFloat) {
        setStrokeWidth(strokeWidth, string: self.string)
    }

    func setStrokeWidth(_ strokeWidth: CGFloat, string: String?) {
        addAttribute(.strokeWidth, value: NSNumber(value: Float(strokeWidth)), range: range(of: string ?? ""))
    }

    func setStroke(_ strokeColor: UIColor) {
        self.setStroke(strokeColor, string: self.string)
    }

    func setStroke(_ strokeColor: UIColor, string: String?) {
        addAttribute(.strokeColor, value: strokeColor, range: range(of: string ?? ""))
    }

    // MARK: -  设置行间距
    func setLineSpacing(_ lineSpacing: CGFloat) {
        self.setLineSpacing(lineSpacing, string: self.string)
    }

    func setLineSpacing(_ lineSpacing: CGFloat, string: String?) {
        //设置行间距margin
        let pStyle = NSMutableParagraphStyle()
        pStyle.lineSpacing = lineSpacing
        addAttribute(.paragraphStyle, value: pStyle, range: range(of: string ?? ""))
    }

    // MARK: - 设置字符串倾斜度
    func setObliqueness(_ obliqueness: CGFloat) {
        setObliqueness(obliqueness, string: self.string)
    }

    func setObliqueness(_ obliqueness: CGFloat, string: String?) {
        addAttribute(.obliqueness, value: NSNumber(value: Float(obliqueness)), range: range(of: string ?? ""))
    }


    // MARK: - 设置字符串跳转超链接
    func setLinkUrl(_ url: String) {
        setLinkUrl(url, sring: self.string)
    }

    func setLinkUrl(_ url: String, sring string: String) {
        addAttribute(.link, value: URL(string: url), range: range(of: string))
    }

    // MARK: - 设置字符串删除线
    func setStrikethrough() {
        setStrikethrough(self.string, color: UIColor.black, style: NSUnderlineStyle.single)
    }

    func setStrikethrough(_ string: String) {
        setStrikethrough(string, color: UIColor.black, style: NSUnderlineStyle.single)
    }

    func setStrikethrough(_ string: String, color: UIColor) {
        setStrikethrough(string, color: color, style: .single)
    }

    func setStrikethrough(_ string: String, color: UIColor, style: NSUnderlineStyle,offset:CGPoint = CGPoint.zero) {
        addAttribute(.strikethroughStyle, value: style.rawValue, range: range(of: string))
        addAttribute(.strikethroughColor, value: color, range: range(of: string))
        addAttribute(.baselineOffset, value: style.rawValue, range: range(of: string))
    }

    // MARK: - 设置字符串下划线
    func setUnderline(_ string: String) {
        setUnderline(string, color: UIColor.black, style: NSUnderlineStyle.single)
    }

    func setUnderline(_ string: String, color: UIColor) {
        setUnderline(string, color: color, style: NSUnderlineStyle.single)
    }

    func setUnderline(_ string: String?, color: UIColor, style: NSUnderlineStyle) {
        addAttribute(NSAttributedString.Key.underlineStyle, value: style.rawValue, range: range(of: string ?? ""))
        addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range(of: string ?? ""))
    }

    // MARK: - 设置字符串段落样式
    func setParagraphStyle(_ paragraph: NSMutableParagraphStyle) {
        setParagraphStyle(paragraph, string: self.string)
    }

    func setParagraphStyle(_ paragraph: NSMutableParagraphStyle, string: String) {
        addAttribute(.paragraphStyle, value: paragraph, range: range(of: string))
    }

    // MARK: - 设置字符串阴影样式
    func setShadow(_ shadow: NSShadow) {
        setShadow(shadow, string: self.string)
    }
    func setShadow(_ shadow: NSShadow, string: String) {
        addAttribute(.shadow, value: shadow, range: range(of: string))
    }

    // MARk: - 字符串范围
    func range(of str: String) -> NSRange {
        if str == "" {
            return NSRange(location: 0, length: 0)
        }
        var string = self.string
        var tempRange = NSRange(location: 0, length: 0)

        //多次出现 只返回最后一次出现的range
        while true {
            let range: NSRange = (string as NSString).range(of: str)
            if range.location == NSNotFound {
                if countOccurencesOf(str) != 0 {
                    // 获取最后一次出现位置
                    tempRange = NSRange(location: tempRange.location + str.count * (countOccurencesOf(str) - 1), length: tempRange.length)
                    return tempRange;
                }
                return tempRange
            } else {
                string = (string as NSString).replacingCharacters(in: range, with: "")
                tempRange = range
            }
        }
    }

    // MARk: - 字符串范围 多次出现 返回数组[NSRange]
    func rangeArr(of str: String) -> [NSRange] {
        if str == "" {
            return [NSRange(location: 0, length: 0)]
        }
        var rangeArr: [NSRange] = [NSRange]()
        var string = self.string
        var tempRange = NSRange(location: 0, length: 0)

        var count = countOccurencesOf(str)
        while count>0 {
            let range: NSRange = (string as NSString).range(of: str)
            if range.location == NSNotFound {
                tempRange = NSRange(location: tempRange.location + str.count * (count - 1), length: tempRange.length)
            } else {
                tempRange = range
                var replacrStr = ""
                for _ in str {
                    replacrStr += " "
                }
                string = (string as NSString).replacingCharacters(in: range, with: replacrStr)
            }
            rangeArr.append(tempRange)
            count-=1;
        }
        return rangeArr
//        //多次出现 只返回最后一次出现的range
//        while true {
//            let range: NSRange = (string as NSString).range(of: str)
//            print("出现的次数\(mgCountOccurencesOf(str, superStr: string))")
//            if range.location == NSNotFound {
//                if mgCountOccurencesOf(str, superStr: string) != 0 {
//                    tempRange = NSRange(location: tempRange.location + str.count * (mgCountOccurencesOf(str, superStr: string) - 1), length: tempRange.length)
//                    rangeArr.append(tempRange)
//                }else {
//
//                }
//                return rangeArr
//            } else {
//                string = (string as NSString).replacingCharacters(in: range, with: "")
//                tempRange = range
//                rangeArr.append(tempRange)
//            }
//        }
    }

    //出现的次数
    func countOccurencesOf(_ searchString: String?) -> Int {
        if (searchString?.count ?? 0) == 0 || self.string.count == 0{
            return 0
        }
        let strCount: Int = string.count - (self.string.replacingOccurrences(of: searchString ?? "", with: "")).count
        return strCount / (searchString?.count ?? 0)
    }

    //出现的次数2
    func mgCountOccurencesOf(_ searchString: String?,superStr: String?) -> Int {
        if (searchString?.count ?? 0) == 0 || (superStr != nil) && superStr?.count == 0{
            return 0
        }
        let strCount: Int = string.count - (superStr!.replacingOccurrences(of: searchString ?? "", with: "")).count
        return strCount / (searchString?.count ?? 0)
    }

}
