//
//  View.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/3/26.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// 在对 MGTypeWrapperProtocol 这个协议做 extension 时， where 后面的 WrappedType 约束可以使用 == 或者 :，两者是有区别的。如果扩展的是值类型，比如 String，Date 等，就必须使用 ==，如果扩展的是类，则两者都可以使用，区别是如果使用 == 来约束，则扩展方法只对本类生效，子类无法使用。如果想要在子类也使用扩展方法，则使用 : 来约束。
extension String: MGTypeWrapperProtocol { }
extension View: MGTypeWrapperProtocol {}
extension MGNameSpaceWrappable where Base : View {
//    @discardableResult
    func sss() {
        print("ssss")
    }
}

extension MGNameSpaceWrappable where Base == String {
    func ddd() {
        print("dddd")
    }
}

extension View:  LYMNamespacePotocol { }
extension String:  LYMNamespacePotocol { }
extension  LYMTypeWrapperProtocol where WrappedType == String {
    var test: String {
        return wrappedValue
    }
}

extension  LYMTypeWrapperProtocol where WrappedType : View {
    func sss() {
        print("ssss")
    }
}
