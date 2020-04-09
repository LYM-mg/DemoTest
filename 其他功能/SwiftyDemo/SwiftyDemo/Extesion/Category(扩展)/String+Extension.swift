//  String+Extension.swift
//  解释
/*
- mutating：
    1、关键字修饰方法是为了能在该方法中修改 struct 或是 enum 的变量,在设计接口的时候,也要考虑到使用者程序的
 
- subscript:
    1.可以使用在类，结构体，枚举中
    2.提供一种类似于数组或者字典通过下标来访问对象的方式
 
 - final关键字:
    1、可以通过把方法，属性或下标标记为final来防止它们被重写，只需要在声明关键字前加上final修饰符即可（例如：final var，final func，final class func，以及final subscript）。如果你重写了final方法，属性或下标，在编译时会报错。
 
*/

import UIKit
import Foundation
//import CommonDigest
//import <CommonCrypto/CommonDigest.h>

// MARK: - 沙盒路径
public extension String {
    /// 沙盒路径之document
    func document() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        return (documentPath as NSString).appendingPathComponent((self as NSString).pathComponents.last!)
    }
    
    /// 沙盒路径之cachePath
    func cache() -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        return (cachePath as NSString).appendingPathComponent((self as NSString).pathComponents.last!)
    }
    
    /// 沙盒路径之temp
    func temp() -> String {
        let tempPath = NSTemporaryDirectory()
        return (tempPath as NSString).appendingPathComponent((self as NSString).pathComponents.last!)
    }
}

// MARK: - 和基本数据类型转换等
public extension String {
    func toFloat() -> Float? {
        if let number = NumberFormatter().number(from: self) {
            return number.floatValue
        }
        return nil
    }
    
    func toInt() -> Int? {
        if let number = NumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
    
    func toDouble(locale: Locale = Locale.current) -> Double? {
        let nf = NumberFormatter()
        nf.locale = locale as Locale!
        if let number = nf.number(from: self) {
            return number.doubleValue
        }
        return nil
    }
    
    func toBool() -> Bool? {
        let trimmed = self.trim().lowercased()
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return nil
    }
    
    func toDate(format: String = "yyyy-MM-dd") -> NSDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) as NSDate?
    }
    
    func toDateTime(format: String = "yyyy-MM-dd HH:mm:ss") -> NSDate? {
        return toDate(format: format)
    }
}


// MARK: - 通过扩展来简化一下,截取字符串
public extension String {
    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }

    ///（如果backwards参数设置为true，则返回最后出现的位置）
    func positionOf(sub:String, backwards:Bool = false)->Int {
        // 如果没有找到就返回-1
        var pos = -1
        if let range = range(of:sub, options: backwards ? .backwards : .literal ) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }

    /// You can remove last word using this,(返回的是一个词组，或者一个单词)
    /// 例子：1、"他是笨蛋".removeLastWord() 结果是 "笨蛋"
    /// 例子：2、"他是蛋".removeLastWord()   结果是 "蛋"
    func removeLastWord() -> String {
        if self.count <= 0 {
            return self
        }
        var range = self.startIndex..<self.endIndex

        let opts:NSString.EnumerationOptions = [.byWords, .reverse]
        self.enumerateSubstrings(in: range, options: opts) {
            (substring, substringRange, enclosingRange, stop) -> () in
            range = substringRange
            stop = true
        }

        return String(self[range])
    }

    func removeLastCharacter() -> String {
        if self.count <= 0 {
            return self
        }
        var range = self.startIndex..<self.endIndex

        let opts:NSString.EnumerationOptions = [.byComposedCharacterSequences, .reverse]
        self.enumerateSubstrings(in: range, options: opts) {
            (substring, substringRange, enclosingRange, stop) -> () in
            range = substringRange
            stop = true
        }

        return String(self[range])
    }

    /// 使用下标截取字符串 例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            if (r.lowerBound > count) || (r.upperBound > count) { return "截取超出范围" }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }set {
            if (r.lowerBound > count) || (r.upperBound > count) { return }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            self.replaceSubrange(startIndex..<endIndex, with: newValue)
        }
    }

    func subString(from: Int) -> String {
        let end = self.count
        return self[from..<end]
    }
    func subString(from: Int, length: Int) -> String {
        let end = from + length
        return self[from..<end]
    }
    func subString(from:Int, to:Int) ->String {
        return self[from..<to]
    }

    func replace(_ string: String, with withString: String) -> String {
        return replacingOccurrences(of: string, with: withString)
    }

    func truncate(_ length: Int, suffix: String = "...") -> String {
        return self.count > length
            ? substring(to: characters.index(startIndex, offsetBy: length)) + suffix
            : self
    }

    func split(_ delimiter: String) -> [String] {
        let components = self.components(separatedBy: delimiter)
        return components != [""] ? components : []
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
// MARK: - 判断手机号  隐藏手机中间四位  正则匹配用户身份证号15或18位  正则RegexKitLite框架
extension String {
    /// 字符串为是否为nil
    func isBlankString() -> Bool{
        if self == nil || (self is NSNull) {
            return true
        }
        if (self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count) == 0 {
            return true
        }
        return false
    }
    
    // 利用正则表达式判断是否是手机号码
    mutating func checkTelNumber() -> Bool {
        let pattern = "^((13[0-9])|(147)|(15[0-3,5-9])|(18[0,0-9])|(17[0-3,5-9]))\\d{8}$"
        let pred      = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    // 正则匹配用户身份证号15或18位
    func validateIdentityCard(identityCard: String) -> Bool {
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|[0-9a-zA-Z])$)"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: identityCard)
    }
    
    // 隐藏手机敏感信息
    mutating func phoneNumberhideMid() {
        let startIndex = self.index("".startIndex, offsetBy: 4)
        let endIndex = self.index("".startIndex, offsetBy: 7)
        self.replaceSubrange(startIndex...endIndex, with: "****")
    }
    
    // 隐藏敏感信息
    mutating func numberHideMidWithOtherChar(form: Int, to: Int,char: String) {
        // 判断
        var form = form;   var to = to
        if form < 0 || form > self.characters.count {
            form = 0
        }
        if to > self.characters.count {
            to = self.characters.count
        }
        var star = ""
        for _ in form...to {
            star.append(char)
        }
        
        let startIndex = self.index("".startIndex, offsetBy: form)
        let endIndex = self.index("".startIndex, offsetBy: to)
        self.replaceSubrange(startIndex...endIndex, with: star)
    }
}

// MARK: - 汉字转拼音
extension String {
    func transform(chinese: String) -> String{
        
        //将NSString装换成NSMutableString
        let pinyin = NSMutableString(string: chinese)as CFMutableString
        //将汉字转换为拼音(带音标)
        CFStringTransform(pinyin, nil, kCFStringTransformMandarinLatin, false)

        //去掉拼音的音标
        CFStringTransform(pinyin, nil, kCFStringTransformStripCombiningMarks, false)
 
        //返回最近结果
        return pinyin as String
    }
}


// MARK: - 计算高度
extension String {
    /**
     取得输入的文字高度
     - parameter width: 控件的宽度
     - parameter font: 要计算的文字代销
     - parameter Float: 返回计算好的高度
     */
    func getSpaceLabelHeight(with font: UIFont, withWidth width: CGFloat) -> CGFloat {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        paraStyle.alignment = .left
        /** 行高 */
        paraStyle.lineSpacing = 15
        paraStyle.hyphenationFactor = 1.0
        paraStyle.firstLineHeadIndent = 0.0
        paraStyle.paragraphSpacingBefore = 0.0
        paraStyle.headIndent = 0
        paraStyle.tailIndent = 0
        let dic: [AnyHashable: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paraStyle, NSAttributedString.Key.kern: 1.5]
        let size = self.boundingRect(with: CGSize(width: width, height: CGFloat(HUGE)), options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
        return size.height
    }
    
    /**
     取得输入的文字高度
     - parameter width: 控件的宽度
     - parameter strText: 要计算的文字
     - parameter Float: 返回计算好的高度
     */
    public func inputTextHeight(for width: CGFloat) -> Float {
        let constraint = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let size: CGRect = self.boundingRect(with: constraint, options: ([.usesLineFragmentOrigin, .usesFontLeading]), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        let textHeight: Float = Float(size.size.height + 22.0)
        return textHeight
    }
}

