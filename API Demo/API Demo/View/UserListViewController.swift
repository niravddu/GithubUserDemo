//
//  ViewController.swift
//  API Demo
//
//  Created by Parth Patel on 17/11/22.
//

import UIKit
import Combine

class UserListViewController: UIViewController {
    
    //MARK: - All Outlets
    @IBOutlet weak var ibTableView: UITableView!
    
    //MARK: - All Properties and Variables
    fileprivate var vm: UserInfoViewModel?
    fileprivate var refreshControl = UIRefreshControl()
    var cancellable : AnyCancellable?
    
    //MARK: - Page Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        self.addPullToRefresh()
    }
    
    //MARK: - All Actions
    
    //MARK: - Self Calling Methods
    private func initViewModel() {
        self.vm = UserInfoViewModel(self)
        
        cancellable = vm?.userListResult.sink { completion in
            switch completion {
            case .failure(let err):
                print(err.localizedDescription)
            case .finished:
                print("api call finished")
            }
        } receiveValue: { list in
            print(list)
            self.ibTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        vm?.getUserList(true)
    }
    
    private func addPullToRefresh() {
        //Add pull to refresh
        self.refreshControl.tintColor = #colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 0.7)
        self.refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        self.ibTableView.addSubview(self.refreshControl)
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.vm?.getUserList(true)
    }
    
    //MARK: - Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetails" {
            let objUserDetailsViewController = segue.destination as! UserDetailsViewController
            objUserDetailsViewController.currentSelectedUserID = self.vm?.currentSelectedUserID ?? ""
        }
    }
}

//MARK: -
//MARK: - All Extensions
//MARK: -

//MARK: - UITableView Delegate and DataSource Methods
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm?.objUserInfoModelArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        cell.configMyTableViewCell(self.vm?.objUserInfoModelArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.vm?.redirectToUserDetailsView(indexPath)
    }
}

//MARK: - UIScrollView Delegate Methods
extension UserListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard (self.vm?.objUserInfoModelArray.count ?? 0) > 0, scrollView == self.ibTableView,
              (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 300,
              (self.vm?.isFetchingUsersList ?? false) == false else { return }
        self.vm?.getUserList(false)
    }
}
