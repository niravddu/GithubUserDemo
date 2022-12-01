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
        self.userViewController.showLoadingIndicator()
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
    }
    
    func redirectToUserDetailsView(_ selecteAtIndex: IndexPath) {
        self.currentSelectedUserID = self.objUserInfoModelArray[selecteAtIndex.row].login ?? ""
        self.userViewController.performSegue(withIdentifier: "userDetails", sender: self.userViewController)
    }
}
