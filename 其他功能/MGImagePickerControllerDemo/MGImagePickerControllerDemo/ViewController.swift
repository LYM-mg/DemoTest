//
//  ViewController.swift
//  MGImagePickerControllerDemo
//
//  Created by newunion on 2019/7/5.
//  Copyright © 2019 MG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var collectionView : UICollectionView = {
        let collectionView : UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = 0xF6FFB7.mg_color

        collectionView.register(MGPhotosCell.self, forCellWithReuseIdentifier: "Cell")

        return collectionView
    }()


    var images = [UIImage]()

    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(collectionView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "图片", style: UIBarButtonItem.Style.plain, target: self, action: #selector(presentPhotoViewController(_:)))
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func __refreshCollectionView(_ sender: Any) {

        self.images.removeAll()
        self.collectionView.reloadData()
    }

    /// 弹出图片控制器
    ///
    /// - Parameter sender: Photo Barbutton
    @objc func presentPhotoViewController(_ sender: Any)
    {

        let vc = MGPhotoGroupViewController()

        // 获得图片
        vc.mg_completeUsingImage = {(images) in

            self.images = images
            self.collectionView.reloadData()
        }

        // 获得资源的data数据
        vc.mg_completeUsingData = {(datas) in
            //coding for data ex: uploading..
            print("data = \(datas)")
        }

        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }

}





extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = collectionView.frame.size.width

        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 1.0
    }
}





extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return images.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MGPhotosCell

        cell.mg_imageView.image = UIImage(data: self.images[indexPath.item].jpegData(compressionQuality: 1.0)!) 
        cell.mg_chooseImageView.isHidden = true

        return cell
    }
}


