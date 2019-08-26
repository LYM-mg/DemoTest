//
//  MGOrigationViewController.swift
//  SwiftyDemo
//
//  Created by newunion on 2019/8/22.
//  Copyright © 2019 firestonetmt. All rights reserved.
//

import UIKit
import Kingfisher

class MGOrigationViewController: UIViewController {

    var imageView = UIImageView()
    var imageView1 = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        self.view.addSubview(imageView1)
        imageView.frame = CGRect(x: 50, y: 100, width: 300, height: 300)
        imageView1.frame = CGRect(x: 50, y: imageView.frame.maxY + 20, width: 300, height: 300)

        let urlStr = "https://dev-api.longxins.com/api/v2/file/7114150cc3e111e9879d42010af00002.JPEG?file_id=400&file_folder=message/2019/08/21&active_time=2019-08-21T12:57:32Z&signature=d53c86319944e2a2d62f091860581b078e6530c921e2615181e02ccb6ef8e958&file_name=20190821205730.JPEG&access_user_ids_str=4537652_5887676&user_id=5887676&device_id=23&width=200"
        let url = URL(string: urlStr)
        imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (reslut) in
            switch reslut{
            case .success(let value):
                self.imageView.image = value.image.mg_fixOrientation(orientation: 6)
                break
            case .failure(let error):

                break
            }
        }

        let urlStr1 = "https://dev-api.longxins.com/api/v2/file/7114150cc3e111e9879d42010af00002.JPEG?access_user_ids_str=4537652_5887676&file_id=386&file_folder=message/2019/08/21&active_time=2019-08-21T11:27:21Z&signature=25e0136f7d16db9746de448a2af5bcd75fedd10ba284ac44d05b2fb8a6d7ff08&file_name=20190821192720.JPEG&user_id=5887676&device_id=23"

        let url1 = URL(string: urlStr1)
        imageView1.kf.setImage(with: url1, placeholder: nil, options: nil, progressBlock: nil) { (reslut) in
            switch reslut{
            case .success(let value):

                break
            case .failure(let error):

                break
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
        }
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        return img
    }

    func mg_fixOrientation(orientation: Int) -> UIImage {

        if orientation == 6 {
            let image = UIImage(cgImage: self.cgImage!, scale: UIScreen.main.scale, orientation: UIImage.Orientation.right)
            return image
        }

        return self
    }

    func fixOrientation(orientation: Int) -> UIImage {
        let orientation = orientation
        if orientation == 1 {
            return self
        }
        var transform = CGAffineTransform.identity
        switch orientation {
        case 1, 5:
            //            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            //            transform = transform.rotated(by: .pi)
            break

        case 2, 6:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break

        case 3, 7:
            //            transform = transform.translatedBy(x: 0, y: self.size.height)
            //            transform = transform.rotated(by: -.pi / 2)
            break

        default:
            break
        }

//        switch orientation {
//        case 4, 5:
//            //            transform = transform.translatedBy(x: self.size.width, y: 0)
//            //            transform = transform.scaledBy(x: -1, y: 1)
//            break
//        case 6, 7:
//            transform = transform.translatedBy(x: self.size.height, y: 0)
//            transform = transform.scaledBy(x: -1, y: 1)
//            break
//        default:
//            break
//        }
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch orientation {
        case 2, 6:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
        }
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        return img
    }
}
