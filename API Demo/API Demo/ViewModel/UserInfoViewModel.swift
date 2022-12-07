//
//  UserInfoViewModel.swift
//  API Demo
//
//  Created by Parth Patel on 17/11/22.
//

import UIKit
import Combine

class UserInfoViewModel: ObservableObject {
    
    @Published var objUserInfoModelArray = [UserInfoModel]()
    var cancellable : AnyCancellable?
    let userListResult = PassthroughSubject<Void, Error>()
    private var userViewController = UIViewController()
    var currentSelectedUserID = ""
    var isFetchingUsersList = false
    
    required init(_ viewController: UIViewController) {
        self.userViewController = viewController
    }
    
    func getUserList(_ isFromStarting: Bool){
        if ConnectivityManager.shared.isInternetAvailable() {
            //self.userViewController.showLoadingIndicator()
            self.isFetchingUsersList = true
            var lastUserID = "0"
            if isFromStarting {
                lastUserID = "0"
            } else {
                lastUserID = self.objUserInfoModelArray.count > 0 ? "\((self.objUserInfoModelArray.last?.id ?? 0))" : "0"
            }
            
            let urlString = usersList + "?since=" + lastUserID
            
            let url = URL(string: urlString)!
            let res: Resource<[UserInfoModel]> = Resource(url: url)
            cancellable = WebServiceManager().fetch(res: res).sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    self.userListResult.send(completion: .failure(err))
                case .finished:
                    self.userListResult.send()
                }
                self.userViewController.hideLoadingIndicator()
            }, receiveValue: { objUserInfoData in
                for objUserInfoModel in objUserInfoData {
                    CoreDataManager.shared.saveUserListData(objUserInfoModel)
                }
                if isFromStarting {
                    self.objUserInfoModelArray = objUserInfoData
                } else {
                    if self.objUserInfoModelArray.count > 0 {
                        self.objUserInfoModelArray.append(contentsOf: objUserInfoData)
                    } else {
                        self.objUserInfoModelArray = objUserInfoData
                    }
                }
                self.isFetchingUsersList = false
            })
        } else {
            let objUserInfoModelArray = CoreDataManager.shared.getAllUsersList()
            if objUserInfoModelArray.count > 0 {
                self.objUserInfoModelArray = self.convertCoreDataModelIntoCodableModel(objUserInfoModelArray)
                self.userListResult.send()
                self.isFetchingUsersList = false
            } else {
                print("No users in the core data")
            }
        }
    }
    
    private func convertCoreDataModelIntoCodableModel(_ objUserInfoModelArray: [UserListModel]) -> [UserInfoModel] {
        var tempObjUserInfoModelArray = [UserInfoModel]()
        for objUserListCDModel in objUserInfoModelArray {
            let tempObjUserInfoModel = UserInfoModel(objUserListCDModel.login, id: Int(objUserListCDModel.id), nodeID: objUserListCDModel.node_id, avatarURL: objUserListCDModel.avatar_url, gravatarID: objUserListCDModel.gravatar_id, url: objUserListCDModel.url, htmlURL: objUserListCDModel.html_url, followersURL: objUserListCDModel.followers_url, followingURL: objUserListCDModel.following_url, gistsURL: objUserListCDModel.gists_url, starredURL: objUserListCDModel.starred_url, subscriptionsURL: objUserListCDModel.subscriptions_url, organizationsURL: objUserListCDModel.organizations_url, reposURL: objUserListCDModel.repos_url, eventsURL: objUserListCDModel.events_url, receivedEventsURL: objUserListCDModel.received_events_url, type: objUserListCDModel.type, siteAdmin: objUserListCDModel.site_admin)
            
            tempObjUserInfoModelArray.append(tempObjUserInfoModel)
        }
        return tempObjUserInfoModelArray
    }
    
    func redirectToUserDetailsView(_ selecteAtIndex: IndexPath) {
        self.currentSelectedUserID = self.objUserInfoModelArray[selecteAtIndex.row].login ?? ""
        self.userViewController.performSegue(withIdentifier: "userDetails", sender: self.userViewController)
    }
}
