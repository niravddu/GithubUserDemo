//
//  LazyImageView.swift
//  PracticalTest
//
//  Created by Parth Patel on 16/11/22.
//

import UIKit

class LazyImageView: UIImageView {

    private let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(_ imageURL: URL, placeHolderImage: UIImage) {
        self.image = placeHolderImage
        
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data (contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
