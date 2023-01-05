//
//  NotificationController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/15.
//  Copyright © 2022 Erick El nino. All rights reserved.
//


import UIKit
import Firebase
class NotificationController: UITableViewController
{
    let cellidentifier = "NotificationCellID"
    
    private var notificationUser = [NotificationModel]()
    {
        didSet
        {
            self.tableView.reloadData()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        fetchcurrentUsernotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        fetchcurrentUsernotifications()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIwithTitle(with: "Notifications")
        setupTableView()
        fetchcurrentUsernotifications()
        
    }
    
    
    private func setupTableView()
    {
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.NotificationCellID)
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        let refreshController = UIRefreshControl()
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(handleRefreshView), for: .valueChanged)
    }
}

extension NotificationController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationUser.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.NotificationCellID, for: indexPath) as? NotificationCell
            else
        {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.notification = notificationUser[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notification1 = notificationUser[indexPath.row]
        
        guard let notificationType = notification1.type else {return}
        
        
        
        if notificationType == .follow
        {
            let user = notification1.user
            let controller = ProfileViewController(Myyuser: user)
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        
        if notificationType == .like
        {
            guard let mytweetID = notification1.TweetId else {return}
            ERICKLNINO_JACKPOT_DB_REF.child("Tweets").child(mytweetID).observeSingleEvent(of: .value) { snapshot in
                guard let tweetDictionary = snapshot.value as? [String:Any] else {return}
                guard let userID = tweetDictionary["uuid"] as? String else {return}
                Services.shared.FetchSpecificUser(currentUserId: userID) { userSelected in
                    let tweet = Tweets(with: userSelected, tweetId: mytweetID, dictionary: tweetDictionary)
                    
                    let controller = TweetController(currenrUseselected: userSelected, UserTweetsSelcted: tweet)
                    controller.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
}


extension NotificationController: NotificationcellDelegate
{
    func handleFollowPressed(Cell: NotificationCell) {
        guard let user = Cell.notification?.user else {return}
        print("DEBUG : User is followed : \(user.isUserFollowed)")
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        if user.isUserFollowed
        {
            Services.shared.unfollowUser(currentuserid: currentUser, usertoUnfollowId: user.user_id) { (err, dataref) in
                Cell.notification?.user.isUserFollowed = false
                self.tableView.reloadData()
            }
            
        }else
        {
            Services.shared.userFollowing(usertofollow: user.user_id, currentID: currentUser) { (err, dataref) in
                
                Cell.notification?.user.isUserFollowed = true
                self.tableView.reloadData()
            }
        }
    }
    
    func userPressedCell(cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        let controller = ProfileViewController(Myyuser: user)
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension NotificationController
{
    // API Caller
    
    func fetchcurrentUsernotifications()
    {
        refreshControl?.beginRefreshing()
        NotificationServices.shared.fetchAllnotification { Notifications in
            self.notificationUser = Notifications
            
            self.checkifuserIsFolloed(Notifications)
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    fileprivate func checkifuserIsFolloed(_ Notifications: [NotificationModel]) {
        for(index, Notification) in Notifications.enumerated()
        {
            if case .follow = Notification.type
            {
                let user = Notification.user
                guard let currentuid = Auth.auth().currentUser?.uid else {return}
                
                Services.shared.checkifuserFollowed(userid: user.user_id, currentUserID: currentuid) { isfollowed in
                    self.notificationUser[index].user.isUserFollowed = isfollowed
                }
            }
        }
    }
}

// Referech tableViewController

extension NotificationController
{
    @objc func handleRefreshView()
    {
       fetchcurrentUsernotifications()
    }
}
