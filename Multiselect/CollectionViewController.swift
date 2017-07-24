//
//  CollectionViewController.swift
//  Multiselect
//
//  Created by woowabrothers on 2017. 7. 20..
//  Copyright © 2017년 yerin. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

private let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController {
    
    let myAlbum = Album()
    var list = [UIImage]()
    var selectList = [Int]()

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBAction func touchButtonDone(_ sender: Any) {
        print("video")
        let uiImages = getSelectedImages()
        let settings = CXEImagesToVideo.videoSettings(codec: AVVideoCodecH264, width: 640, height: 480)
        let movieMaker = CXEImagesToVideo(videoSettings: settings)
        movieMaker.createMovieFrom(images: uiImages){ (fileURL:URL) in
            let video = AVAsset(url: fileURL)
            let playerItem = AVPlayerItem(asset: video)
            let player = AVPlayer.init(playerItem: playerItem)
//            player.setPlayerItem(playerItem: playerItem)
            player.play()
            
            print("play", playerItem)
//            self.playerView.player = player
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        
//        if let layout = collectionView?.collectionViewLayout as? CollectionViewLayout {
//            layout.delegate = self
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(getNoti(notification:)), name: Notification.Name("PHOTOS"), object: nil)

        myAlbum.getPhotos()

        collectionView!.backgroundColor = UIColor.clear
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getNoti(notification: Notification){
        list = myAlbum.allImages
        collectionView.reloadData()
    }
    
    func getSelectedImages() -> [UIImage] {
        var results = [UIImage]()
        
        list.forEach { object in
            if selectList.contains(object.hash) {
                results.append(object)
            }
        }
        
        return results
    }
}

extension CollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! CollectionViewCell
        let image = list[indexPath.row]
        cell.imageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var isSelected = true
        for index in 0..<selectList.count {
            if selectList[index] == list[indexPath.row].hash {
                selectList.remove(at: index)
                isSelected = false
                break
            }
        }
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        if isSelected {
            selectList.append(list[indexPath.row].hash)
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.imageView?.alpha = 0.5
        } else {
            cell.layer.borderWidth = 0
            cell.imageView?.alpha = 1
        }
        
        print(selectList)
 
    }
    
    
    /*
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
