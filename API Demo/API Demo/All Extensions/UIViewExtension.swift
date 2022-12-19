//
//  UIViewExtension.swift
//  GitUsersDemo
//
//  Created by Nirav Patel on 22/11/22.
//

import UIKit

extension UIView {
    func addShadowToView(_ shadowColor: UIColor, shadowOpacity: Float, shadowOffset: CGSize, shadowRadius: CGFloat) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
    }
}
