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
       
    }
}


extension NotificationController: NotificationcellDelegate
{
    func userPressedCell(cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        let controller = ProfileViewController(Myyuser: user)
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
//    let controller = ProfileViewController(Myyuser: erickeninoUser)
//    controller.modalPresentationStyle = .fullScreen
//    navigationController?.pushViewController(controller, animated: true)
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
