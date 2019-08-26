//
//  UIImage.swift
//  message
//
//  Created by newunion on 2019/8/12.
//  Copyright © 2019 italki. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC
import MobileCoreServices

private var mg_imageSourceKey: Void?
private var mg_animatedImageDataKey: Void?

func mg_getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

func  mg_setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

extension UIImage {

    private(set) var animatedImageData: Data? {
        get { return mg_getAssociatedObject(self, &mg_animatedImageDataKey) }
        set { mg_setRetainedAssociatedObject(self, &mg_animatedImageDataKey, newValue) }
    }

    #if os(macOS)
    var cgImage: CGImage? {
        return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }

    var scale: CGFloat {
        return 1.0
    }

    private(set) var images: [Image]? {
        get { return mg_getAssociatedObject(self, &imagesKey) }
        set { mg_setRetainedAssociatedObject(self, &imagesKey, newValue) }
    }

    private(set) var duration: TimeInterval {
        get { return getAssociatedObject(self, &durationKey) ?? 0.0 }
        set { setRetainedAssociatedObject(self, &durationKey, newValue) }
    }

    var size: CGSize {
        return self.representations.reduce(.zero) { size, rep in
            let width = max(size.width, CGFloat(rep.pixelsWide))
            let height = max(size.height, CGFloat(rep.pixelsHigh))
            return CGSize(width: width, height: height)
        }
    }
    #else

    private(set) var imageSource: CGImageSource? {
        get { return mg_getAssociatedObject(self, &mg_imageSourceKey) }
        set { mg_setRetainedAssociatedObject(self, &mg_imageSourceKey, newValue) }
    }
    #endif

    // Bitmap memory cost with bytes.
    var cost: Int {
        let pixel = Int(size.width * size.height * scale * scale)
        guard let cgImage = cgImage else {
            return pixel * 4
        }
        return pixel * cgImage.bitsPerPixel / 8
    }

    /**
     *  获取GIF图片的每一帧 有关的东西  比如：每一帧的图片、每一帧的图片执行的时间
     */
    public func mg_animatedGIFWithData(data: Data) -> UIImage {

        let gifSource = CGImageSourceCreateWithData(data as CFData, nil)
        let imageCount = CGImageSourceGetCount(gifSource!)

        if imageCount <= 1 {
            return UIImage(data: data) ?? UIImage()
        }
        var imageArr = [UIImage]()
        var totalTime: Float = 0.0
        for i in 0..<imageCount {
            let imageRef = CGImageSourceCreateImageAtIndex(gifSource!, i, nil) // 取得每一帧的图片
            guard imageRef != nil else {
                continue
            }
            imageArr.append(UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up))

            guard let sourceDict = CGImageSourceCopyPropertiesAtIndex(gifSource!, i, nil) as? [String: Any] else {
                continue
            }
            guard let gifDict = sourceDict[String(kCGImagePropertyGIFDictionary)] as? [String: Any] else {
                continue
            }
            guard let time = gifDict[String(kCGImagePropertyGIFUnclampedDelayTime)] as? NSNumber  else {
                continue
            }// 每一帧的动画时间
            totalTime += time.floatValue

            // 获取图片的尺寸 (适应)
            //            let imageWitdh = sourceDict[String(kCGImagePropertyPixelWidth)] as! NSNumber
            //            let imageHeight = sourceDict[String(kCGImagePropertyPixelHeight)] as! NSNumber
        }
        return UIImage.animatedImage(with: imageArr, duration: TimeInterval(totalTime)) ?? UIImage()
    }

    public static func mg_animatedImage(data: Data, options: MGImageCreatingOptions) -> UIImage? {
        let info: [String: Any] = [
            kCGImageSourceShouldCache as String: true,
            kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF
        ]

        guard let imageSource = CGImageSourceCreateWithData(data as CFData, info as CFDictionary) else {
            return nil
        }
        var image: UIImage?
        if options.preloadAll || options.onlyFirstFrame {
            // Use `images` image if you want to preload all animated data
            guard let animatedImage = MGGIFAnimatedImage(from: imageSource, for: info, options: options) else {
                return nil
            }
            if options.onlyFirstFrame {
                image = animatedImage.images.first
            } else {
                let duration = options.duration <= 0.0 ? animatedImage.duration : options.duration
                image = .animatedImage(with: animatedImage.images, duration: duration)
            }
            image?.animatedImageData = data
        } else {
            image = UIImage(data: data, scale: options.scale)
            image?.imageSource = imageSource
            image?.animatedImageData = data
        }

        return image
    }
}

// Represents the decoding for a GIF image. This class extracts frames from an `imageSource`, then
// hold the images for later use.
class MGGIFAnimatedImage {
    let images: [UIImage]
    let duration: TimeInterval

    init?(from imageSource: CGImageSource, for info: [String: Any], options: MGImageCreatingOptions) {
        let frameCount = CGImageSourceGetCount(imageSource)
        var images = [UIImage]()
        var gifDuration = 0.0

        for i in 0 ..< frameCount {
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, info as CFDictionary) else {
                return nil
            }

            if frameCount == 1 {
                gifDuration = .infinity
            } else {
                // Get current animated GIF frame duration
                gifDuration += MGGIFAnimatedImage.getFrameDuration(from: imageSource, at: i)
            }
            images.append(UIImage(cgImage: imageRef, scale: options.scale, orientation: UIImage.Orientation.up))
            if options.onlyFirstFrame { break }
        }
        self.images = images
        self.duration = gifDuration
    }

    // Calculates frame duration for a gif frame out of the kCGImagePropertyGIFDictionary dictionary.
    static func getFrameDuration(from gifInfo: [String: Any]?) -> TimeInterval {
        let defaultFrameDuration = 0.1
        guard let gifInfo = gifInfo else { return defaultFrameDuration }

        let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
        let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
        let duration = unclampedDelayTime ?? delayTime

        guard let frameDuration = duration else { return defaultFrameDuration }
        return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : defaultFrameDuration
    }

    // Calculates frame duration at a specific index for a gif from an `imageSource`.
    static func getFrameDuration(from imageSource: CGImageSource, at index: Int) -> TimeInterval {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil)
            as? [String: Any] else { return 0.0 }

        let gifInfo = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any]
        return getFrameDuration(from: gifInfo)
    }
}

/// Represents a set of image creating options used in Kingfisher.
public struct MGImageCreatingOptions {

    /// The target scale of image needs to be created.
    public let scale: CGFloat

    /// The expected animation duration if an animated image being created.
    public let duration: TimeInterval

    /// For an animated image, whether or not all frames should be loaded before displaying.
    public let preloadAll: Bool

    /// For an animated image, whether or not only the first image should be
    /// loaded as a static image. It is useful for preview purpose of an animated image.
    public let onlyFirstFrame: Bool

    /// Creates an `ImageCreatingOptions` object.
    ///
    /// - Parameters:
    ///   - scale: The target scale of image needs to be created. Default is `1.0`.
    ///   - duration: The expected animation duration if an animated image being created.
    ///               A value less or equal to `0.0` means the animated image duration will
    ///               be determined by the frame data. Default is `0.0`.
    ///   - preloadAll: For an animated image, whether or not all frames should be loaded before displaying.
    ///                 Default is `false`.
    ///   - onlyFirstFrame: For an animated image, whether or not only the first image should be
    ///                     loaded as a static image. It is useful for preview purpose of an animated image.
    ///                     Default is `false`.
    public init(
        scale: CGFloat = 1.0,
        duration: TimeInterval = 0.0,
        preloadAll: Bool = false,
        onlyFirstFrame: Bool = false) {
        self.scale = scale
        self.duration = duration
        self.preloadAll = preloadAll
        self.onlyFirstFrame = onlyFirstFrame
    }
}

enum MGImageFormat: String {
    case Unknow = ".UnKnow"
    case JPEG   = ".JPEG"
    case PNG    = ".PNG"
    case GIF    = ".GIF"
    case TIFF   = ".TIFF"
    case WebP   = ".WebP"
    case HEIC   = ".HEIC"
    case HEIF   = ".HEIF"

    struct HeaderData {
        static var PNG: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
        static var JPEG_SOI: [UInt8] = [0xFF, 0xD8]
        static var JPEG_IF: [UInt8] = [0xFF]
        static var GIF: [UInt8] = [0x47, 0x49, 0x46]
    }
}
extension Data {
    func mg_getImageTypeFormat() -> MGImageFormat {
        var buffer = [UInt8](repeating: 0, count: 8)
        self.copyBytes(to: &buffer, count: 8)
        
        switch buffer {
        case [0xFF, 0xD8]: return .JPEG
        case [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]: return .PNG
        case [0x47, 0x49, 0x46]: return .GIF
        case [0x49], [0x4D]: return .TIFF
        case [0x52] where self.count >= 12:
            if let str = String(data: self[0...11], encoding: .ascii), str.hasPrefix("RIFF"), str.hasSuffix("WEBP") {
                return .WebP
            }
        case [0x00] where self.count >= 12:
            if let str = String(data: self[8...11], encoding: .ascii) {
                let HEICBitMaps = Set(["heic", "heis", "heix", "hevc", "hevx"])
                if HEICBitMaps.contains(str) {
                    return .HEIC
                }
                let HEIFBitMaps = Set(["mif1", "msf1"])
                if HEIFBitMaps.contains(str) {
                    return .HEIF
                }
            }
        default: break
        }
        return .Unknow
    }

    /// Gets the image format corresponding to the data.
    func mg_getImageFormat() -> MGImageFormat {
        var buffer = [UInt8](repeating: 0, count: 8)
        (self as NSData).getBytes(&buffer, length: 8)
        if buffer == MGImageFormat.HeaderData.PNG {
            return .PNG
        } else if buffer[0] == MGImageFormat.HeaderData.JPEG_SOI[0] &&
            buffer[1] == MGImageFormat.HeaderData.JPEG_SOI[1] &&
            buffer[2] == MGImageFormat.HeaderData.JPEG_IF[0] {
            return .JPEG
        } else if buffer[0] == MGImageFormat.HeaderData.GIF[0] &&
            buffer[1] == MGImageFormat.HeaderData.GIF[1] &&
            buffer[2] == MGImageFormat.HeaderData.GIF[2] {
            return .GIF
        }
        return .Unknow
    }
}
