//
//  ImageHandler.swift
//  BuildMyPC
//
//  Created by Beke Zoltán on 2020. 01. 10..
//  Copyright © 2020. Zoltán Beke. All rights reserved.
//

import UIKit
import SDWebImage

class ImageHandler: NSObject {

    static let handler  = ImageHandler()
    
    private override init() {
        super.init()


    }
    
    static func clearCache(){
        
        let cache = SDImageCache.shared
        cache.clearMemory()
        cache.clearDisk(onCompletion: nil)
    }
    
    static func downloadImage(withURL imageURL: String?, completionBlock: @escaping (_ image: UIImage?,_ error: Error?) -> Void){
        
        guard let urlString = imageURL,let url = URL(string: urlString) else {
            
            let errorTemp = NSError(domain:"com.ZoltanBeke.BuildMyPC", code:1, userInfo:nil)
            completionBlock(nil,errorTemp)
            return
        }
        
        let cache = SDImageCache.shared
        
        cache.diskImageExists(withKey: urlString) { (isInCache) in
            
            if isInCache, let image = cache.imageFromDiskCache(forKey: urlString){
                
                completionBlock(image,nil)
            }
            else{
                
                SDWebImageDownloader.shared.downloadImage(with: url, options: .highPriority, progress: { (receivedSize, expectedSize, targetURL) in
                    
                    let tUrl = targetURL?.absoluteString ?? "not valid"
                    print("receivedSize: " + String(receivedSize) + "    expectedSize: " + String(expectedSize) + "   targetURL" + tUrl)
                    
                }) { (image, data, error, finished) in
                    
                    if finished{
                        
                        if image != nil {
                            cache.store(image, forKey: urlString, toDisk: true, completion: nil)
                        }
                        
                        completionBlock(image,error)
                    }
                }
            }
            
        }
        
        print("")

    }
}
