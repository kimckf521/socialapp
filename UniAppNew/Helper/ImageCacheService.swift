//
//  ImageCacheService.swift
//  UniAppNew
//
//  Created by Kim on 7/12/20.
//

import Foundation
import UIKit

class ImageCacheService {
    
    static var imageCache = [String:UIImage]()
    
    static func saveImage(url:String?, image:UIImage?) {
        
        if url == nil || image == nil {
            return
        }
        
        imageCache[url!] = image!
    }
    
    static func getImage(url:String?) -> UIImage? {
        
        // Check that url isn't nil
        if url == nil {
            return nil
        }
        
        // Check the image cache for the url
        return imageCache[url!]
        
    }
    
}
