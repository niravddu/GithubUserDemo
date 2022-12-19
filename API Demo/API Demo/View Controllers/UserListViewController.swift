//
//  ViewController.swift
//  GitUsersDemo
//
//  Created by Nirav Patel on 20/11/22.
//

import UIKit
import Combine

class UserListViewController: UIViewController {
    
    //MARK: - All Outlets
    @IBOutlet weak var ibTableView: UITableView!
    @IBOutlet weak var ibNoInternetContainerView: UIView!
    
    //MARK: - All Properties and Variables
    fileprivate var vm: UserDataViewModel?
    fileprivate var refreshControl = UIRefreshControl()
    var cancellable : AnyCancellable?
    
    //MARK: - Page Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ibTableView.windless
            .apply {
                $0.beginTime = 0.01
                $0.duration = 4
                $0.animationLayerOpacity = 0.5
            }
            .start()
        self.ibTableView.reloadData()
        
        self.initViewModel()
        self.addPullToRefresh()
        self.updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: nil)
        self.ibTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .flagsChanged, object: nil)
    }
    
    //MARK: - All Actions
    
    //MARK: - Self Calling Methods
    private func initViewModel() {
        self.vm = UserDataViewModel(self)
        
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
            self.ibTableView.windless.end()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.vm?.getUserList(true)
        })
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
    
    @objc func statusManager(_ notification: Notification) {
        self.updateUserInterface()
    }
    
    func updateUserInterface() {
        switch Network.reachability.status {
        case .unreachable:
            self.ibNoInternetContainerView.backgroundColor = .red
            self.ibNoInternetContainerView.isHidden = false
        case .wwan,.wifi:
            self.ibNoInternetContainerView.isHidden = true
        }
        self.ibTableView.reloadData()
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
        if self.vm == nil {
            return 10
        }
        return self.vm?.objUserInfoModelArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        cell.configMyTableViewCell(self.vm?.objUserInfoModelArray[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ConnectivityManager.shared.isInternetAvailable() {
            self.vm?.redirectToUserDetailsView(indexPath)
        } else {
            if self.vm?.checkOfflineUserDataAvailable(indexPath) ?? false {
                self.vm?.redirectToUserDetailsView(indexPath)
            } else {
                self.showAlertView("Alert", message: "Profile details not available for offline ", buttonName: "Ok")
            }
        }
    }
}

//MARK: - UIScrollView Delegate Methods
extension UserListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ConnectivityManager.shared.isInternetAvailable() {
            guard (self.vm?.objUserInfoModelArray.count ?? 0) > 0, scrollView == self.ibTableView,
                  (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height - 300,
                  (self.vm?.isFetchingUsersList ?? false) == false else { return }
            self.vm?.getUserList(false)
        }
    }
}
