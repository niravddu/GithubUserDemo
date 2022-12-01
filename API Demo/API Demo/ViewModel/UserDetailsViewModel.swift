//
//  UserDetailsViewModel.swift
//  API Demo
//
//  Created by Parth Patel on 18/11/22.
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
    
    func getUserDetails(_ userID: String) {
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
            self.objUserDetailsModel = UserDetails
            self.reloadData!()
        })
    }
}
