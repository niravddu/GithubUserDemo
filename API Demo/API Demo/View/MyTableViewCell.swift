//
//  MyTableViewCell.swift
//  API Demo
//
//  Created by Parth Patel on 17/11/22.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var ibShadowView: UIView!
    @IBOutlet weak var ibContainerView: UIView!
    @IBOutlet weak var ibProfileImageShadowView: UIView!
    @IBOutlet weak var ibProfileImageView: LazyImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserDetailsURL: UILabel!
    
    private let placeHolder = #imageLiteral(resourceName: "userProfile")
    
    //MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellThemeConfig()
    }
    
    //MARK: - Self Calling Methods
    private func cellThemeConfig() {
        self.ibShadowView.addShadowToView(.black, shadowOpacity: 0.2, shadowOffset: .zero, shadowRadius: 5)
        self.ibShadowView.layer.cornerRadius = 5
        self.ibShadowView.clipsToBounds = false
        self.ibContainerView.layer.cornerRadius = 5
        self.ibContainerView.clipsToBounds = true
        
        self.ibProfileImageShadowView.addShadowToView(.black, shadowOpacity: 0.6, shadowOffset: .zero, shadowRadius: 5)
        self.ibProfileImageShadowView.layer.cornerRadius = self.ibProfileImageShadowView.frame.size.height/2
        self.ibProfileImageView.layer.cornerRadius = self.ibProfileImageShadowView.frame.size.height/2
    }
    
    func configMyTableViewCell(_ objUserInfoModel: UserInfoModel?) {
        if let profileImageURL = URL(string: objUserInfoModel?.avatarURL ?? "")  {
            self.ibProfileImageView.loadImage(profileImageURL, placeHolderImage: self.placeHolder)
        }
        self.lblUserName.text = objUserInfoModel?.login ?? ""
        self.lblUserDetailsURL.text = objUserInfoModel?.htmlURL ?? ""
    }
}
