//
//  MGNameSpaceWrappable.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/3/26.
//  Copyright © 2019年 firestonetmt. All rights reserved.
//

import UIKit

#if os(macOS)
import AppKit
public typealias Image = NSImage
public typealias View = NSView
public typealias Color = NSColor
public typealias ImageView = NSImageView
public typealias Button = NSButton
#else
import UIKit
public typealias Image = UIImage
public typealias Color = UIColor
#if !os(watchOS)
public typealias ImageView = UIImageView
public typealias View = UIView
public typealias Button = UIButton
#else
import WatchKit
#endif
#endif

// MARK: -
// MARK: - MG
public struct MGNameSpaceWrappable<Base>:MGTypeWrapperProtocol {
    public let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol MGTypeWrapperProtocol {

}

extension MGTypeWrapperProtocol {
    public var mg: MGNameSpaceWrappable<Self> {
        get {
            return MGNameSpaceWrappable(self)
        }
        set {
            
        }
    }
}


#if !os(watchOS)
#else
extension WKInterfaceImage: MGTypeWrapperProtocol { }
#endif


// MARK: -
// MARK: - LYM
public protocol LYMNamespacePotocol {
    associatedtype WrapperType
    var lym: WrapperType { get }
    static var lym: WrapperType.Type { get }
}

public extension LYMNamespacePotocol {
    var lym:  LYMNamespaceWrapper<Self> {
        return  LYMNamespaceWrapper(value: self)
    }

    static var lym:  LYMNamespaceWrapper<Self>.Type {
        return  LYMNamespaceWrapper.self
    }
}

public protocol  LYMTypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct  LYMNamespaceWrapper<T>:  LYMTypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
