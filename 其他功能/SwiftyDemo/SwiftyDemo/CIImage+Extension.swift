//
//  CIImage+Extension.swift
//  SwiftyDemo
//
//  Created by newunion on 2020/3/2.
//  Copyright © 2020 firestonetmt. All rights reserved.
//

import UIKit

extension CIImage {
    func createNonInterpolated(withSize size: CGFloat) -> UIImage? {
         let extent = self.extent
        let scale = min(size / extent.width, size / extent.height)
        
        // 1.创建bitmap;
        
        let width = size_t(extent.width * scale)
        
        let height = size_t(extent.height * scale)
        
        let cs = CGColorSpaceCreateDeviceGray()
        
        let context1 = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).rawValue)
        
        let ciContext = CIContext()
        guard let context = context1 else {
            return nil
        }
        guard let bitmapImage = ciContext.createCGImage(self, from: extent) else {
            return nil
        }
        context.interpolationQuality = CGInterpolationQuality.none
                   
        context.scaleBy(x: scale, y: scale)
        
        context.draw(bitmapImage, in: extent)
        
        // 2.保存bitmap到图片
        
        guard let scaledImage = context.makeImage() else { return nil }
        
//        free(context)
//        free(bitmapImage)
        
        return UIImage(cgImage: scaledImage)
    }
}

class MGCreatTiool {
    func creatQRCode() -> UIImage?{
        // 1.创建滤镜对象

        let filter = CIFilter(name: "CIQRCodeGenerator")

        // 2.恢复默认设置

        filter?.setDefaults()

        //3.链接字符串

        let str = "https://www.jianshu.com/u/4c669da2ffa3"

        // 4.将链接字符串转data格式

        let strData = str.data(using: .utf8)

        filter?.setValue(strData, forKeyPath: "inputMessage")

        // 5.生成二维码

        let outputImage = filter?.outputImage
        
        return outputImage?.createNonInterpolated(withSize: 80);
    }
}
