//
//  UserDetailsViewController.swift
//  GitUsersDemo
//
//  Created by Nirav Patel on 22/11/22.
//

import UIKit

class UserDetailsViewController: UIViewController {

    //MARK: - All Outlets
    @IBOutlet weak var ibProfileImageView: LazyImageView!
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompanyTitle: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblBlogTitle: UILabel!
    @IBOutlet weak var lblBlog: UILabel!
    @IBOutlet weak var lblFollowersTitle: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowingTitle: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblNotesTitle: UILabel!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var ibSaveBtn: UIButton!
    
    //MARK: - All Properties and Variables
    var currentSelectedUserID = ""
    private var vm: UserDetailsViewModel?
    private let placeHolder = #imageLiteral(resourceName: "userProfile")
    
    //MARK: - Page Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        self.themeConfig()
        self.vm?.getUserDetailsFromDB(self.currentSelectedUserID)
    }
    
    //MARK: - All Actions
    @IBAction func btnSave(_ sender: UIButton) {
        var title = ""
        var message = ""
        if CoreDataManager.shared.saveNoteUserWise(self.currentSelectedUserID, notes: self.txtNotes.text) {
            title = "Success"
            message = "Note saved."
        } else {
            title = "Error"
            message = "Note not saved."
        }
        
        let objAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        objAlertController.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(objAlertController, animated: true)
    }
    
    //MARK: - Self Calling Methods
    private func initViewModel() {
        self.vm = UserDetailsViewModel(self)
        self.vm?.reloadData = {
            self.setData()
        }
    }
    
    private func themeConfig() {
        //self.ibProfileImageView.layer.cornerRadius = self.ibProfileImageView.frame.width/2
        self.ibProfileImageView.clipsToBounds = true
        self.txtNotes.layer.cornerRadius = 10
        self.txtNotes.layer.borderWidth = 1
        self.txtNotes.layer.borderColor = UIColor.gray.cgColor
        self.ibSaveBtn.layer.cornerRadius = self.ibSaveBtn.frame.height/2
    }
    
    private func setData() {
        if let profileImageURL = URL(string: self.vm?.objUserDetailsModel?.avatarURL ?? "")  {
            self.ibProfileImageView.loadImage(profileImageURL, placeHolderImage: self.placeHolder, isInvertedImage: false)
        }
        
        self.lblName.text = self.vm?.objUserDetailsModel?.getName()
        self.lblCompany.text = self.vm?.objUserDetailsModel?.company ?? "-"
        self.lblBlog.text = self.vm?.objUserDetailsModel?.blog ?? "-"
        self.lblFollowers.text = self.vm?.objUserDetailsModel?.getFollowers()
        self.lblFollowing.text = self.vm?.objUserDetailsModel?.getFollowing()
        
        self.lblNameTitle.text = "Name:"
        self.lblCompanyTitle.text = "Company:"
        self.lblBlogTitle.text = "Blog:"
        self.lblFollowersTitle.text = "Followers"
        self.lblFollowingTitle.text = "Following"
        self.lblNotesTitle.text = "Notes:"
        
        self.txtNotes.text = CoreDataManager.shared.getNoteUserWise(self.currentSelectedUserID)?.notes ?? ""
    }
    
    //MARK: - Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

//MARK: -
//MARK: - All Extensions
//MARK: -

//MARK: - 
