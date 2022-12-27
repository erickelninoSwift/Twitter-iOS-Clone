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
        print("DEBUg: HANDLE FOLLOW")
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
        NotificationServices.shared.fetchAllnotification { Notifications in
            self.notificationUser = Notifications
            print("DEBUG: \(Notifications)")
        }
    }
}
