//
//  editProfileController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2023/01/09.
//  Copyright © 2023 Erick El nino. All rights reserved.
//

import UIKit

class editProfileController: UITableViewController
{
    let profileUser: User
    
    private lazy var headerView = UserProfileHeader(user: profileUser)
    
    init(user: User) {
        self.profileUser = user
        super.init(style: .plain)
        headerView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStyle()
        configureLayout()
        configureTableView()
    }
    
    func configureTableView()
    {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 190)
        tableView.tableFooterView = UIView()
    }
    
}

extension editProfileController
{

}

extension editProfileController
{
    private func configureStyle()
    {
        view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveprofile))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    private func configureLayout()
    {
        
    }
    
    @objc func handleSaveprofile()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancel()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
extension editProfileController: UserProfileHeaderDelegate
{
    func userDidtapChangePhoto() {
        print("DEBUG: CHANGE PHOTO FROM EDIT CONTROLLER")
    }

}
