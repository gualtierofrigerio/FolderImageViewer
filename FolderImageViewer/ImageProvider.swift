//
//  ImageProvider.swift
//  FolderImageViewer
//
//  Created by Gualtiero Frigerio on 30/01/2019.
//

import UIKit

// for internal use
private struct ImageEntry {
    var image:UIImage!
    var url:URL!
    
    init(image:UIImage, url:URL) {
        self.image = image
        self.url = url
    }
}
// provides a simple cache mechanism to get images from a known file URL
// could be extended to support even remote URL
class ImageProvider {
    
    var cacheSize = 1
    private var cachedImages = [ImageEntry]()
    
    convenience init() {
        self.init(withCacheSize: 1)
    }
    
    init(withCacheSize:Int) {
        cacheSize = withCacheSize
    }
    
    func getImage(atFileURL url:URL) -> UIImage? {
        for entry in cachedImages {
            if entry.url == url {
                return entry.image
            }
        }
        guard let data = try? Data(contentsOf: url),
            let newImage = UIImage(data:data) else {
            return nil
        }
        if cachedImages.count >= cacheSize {
            cachedImages.removeFirst()
        }
        cachedImages.append(ImageEntry(image:newImage, url:url))
        return newImage
    }
}
