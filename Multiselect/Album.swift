//
//  Album.swift
//  Multiselect
//
//  Created by woowabrothers on 2017. 7. 20..
//  Copyright © 2017년 yerin. All rights reserved.
//
import Photos
import Foundation

class Album {
    
    public private(set) var allPhotos: PHFetchResult<AnyObject>
    public private(set) var allImages: [UIImage]
    
    init() {
        allPhotos = PHFetchResult<AnyObject>()
        allImages = []
    }

    func getPhotos() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status
            {
            case .authorized:
                print("Good to proceed")
                let fetchOptions = PHFetchOptions()
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions) as! PHFetchResult<AnyObject>
                print("Found \(self.allPhotos.count) images")
                for index in 0..<self.allPhotos.count {
                    self.allImages.append(self.getAssetThumbnail(asset: self.allPhotos.object(at: index) as! PHAsset))
                }
                
                NotificationCenter.default.post(name: Notification.Name("PHOTOS"), object: nil)
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            }
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 640, height: 480),
                             contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                                thumbnail = result!
        })
        return thumbnail
    }

}
