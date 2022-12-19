//
//  UIImageViewExtension.swift
//  GitUsersDemo
//
//  Created by Nirav patel on 06/12/22.
//

import Foundation
import UIKit

extension UIImage {
    func invertedImage() -> UIImage? {
        
        let img = CoreImage.CIImage(cgImage: self.cgImage!)
        
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setDefaults()
        
        filter?.setValue(img, forKey: "inputImage")
        
        let context = CIContext(options:nil)
        
        guard let cgimg = context.createCGImage((filter?.outputImage)!, from: (filter?.outputImage?.extent)!) else { return self }

        return UIImage(cgImage: cgimg)
    }
}
