//
//  UserDetailsViewModel.swift
//  GitUsersDemo
//
//  Created by Nirav Patel on 22/11/22.
//

import UIKit
import Combine

class UserDetailsViewModel {
    var cancellable : AnyCancellable?
    @Published var objUserDetailsModel: UserDetailsModel?
    let userDetailsResult = PassthroughSubject<Void, Error>()
    private var userDetailsController = UIViewController()
    var reloadData: (() -> Void)?
    
    required init(_ viewController: UIViewController) {
        self.userDetailsController = viewController
    }
    
    func getUserDetailsFromDB(_ userID: String) {
        if ConnectivityManager.shared.isInternetAvailable() {
            self.userDetailsController.showLoadingIndicator()
            
            let urlString = userDtails + userID
            
            let url = URL(string: urlString)!
            let res: Resource<UserDetailsModel> = Resource(url: url)
            cancellable = WebServiceManager().fetch(res: res).sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    self.userDetailsResult.send(completion: .failure(err))
                case .finished:
                    self.userDetailsResult.send()
                }
                self.userDetailsController.hideLoadingIndicator()
            }, receiveValue: { UserDetails in
                CoreDataManager.shared.saveUserDetailsDataToDB(UserDetails)
                self.objUserDetailsModel = UserDetails
                self.reloadData!()
            })
        } else {
            if let objUserDetailsCDModel = CoreDataManager.shared.getUserDetailsFromDB(userID) {
                self.objUserDetailsModel = self.convertCoreDataModelIntoCodableModel(objUserDetailsCDModel)
            }
            self.userDetailsResult.send()
            self.reloadData!()
        }
    }
    
    private func convertCoreDataModelIntoCodableModel(_ objUserDetailsCDModel: UserDetailsCDModel) -> UserDetailsModel {
        
        let objTempUserDetailsModel = UserDetailsModel(objUserDetailsCDModel.login, id: Int(objUserDetailsCDModel.id), nodeID: objUserDetailsCDModel.node_id, avatarURL: objUserDetailsCDModel.avatar_url, gravatarID: objUserDetailsCDModel.gravatar_id, url: objUserDetailsCDModel.url, htmlURL: objUserDetailsCDModel.html_url, followersURL: objUserDetailsCDModel.followers_url, followingURL: objUserDetailsCDModel.following_url, gistsURL: objUserDetailsCDModel.gists_url, starredURL: objUserDetailsCDModel.starred_url, subscriptionsURL: objUserDetailsCDModel.subscriptions_url, organizationsURL: objUserDetailsCDModel.organizations_url, reposURL: objUserDetailsCDModel.repos_url, eventsURL: objUserDetailsCDModel.events_url, receivedEventsURL: objUserDetailsCDModel.received_events_url, type: objUserDetailsCDModel.type, siteAdmin: objUserDetailsCDModel.site_admin, name: objUserDetailsCDModel.name, company: objUserDetailsCDModel.company, blog: objUserDetailsCDModel.blog, location: objUserDetailsCDModel.location, email: objUserDetailsCDModel.email, hireable: objUserDetailsCDModel.hireable, bio: objUserDetailsCDModel.bio, twitterUsername: objUserDetailsCDModel.twitter_username, publicRepos: Int(objUserDetailsCDModel.public_repos), publicGists: Int(objUserDetailsCDModel.public_gists), followers: Int(objUserDetailsCDModel.followers), following: Int(objUserDetailsCDModel.following), createdAT: objUserDetailsCDModel.created_at, updatedAT: objUserDetailsCDModel.updated_at)
        return objTempUserDetailsModel
    }
}
