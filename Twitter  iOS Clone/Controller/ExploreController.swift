//
//  ExploreController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/15.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

private let cellidentifier = "ExploreController_ID"
class ExploreController: UITableViewController
{
    
    private var currentUser: User!
    
    private var allUsers = [User]()
    {
        didSet
        {
            tableView.reloadData()
            navigationConfigiration()
            
        }
    }
    
    private var filteredUserdetails = [User](){
        didSet
        {
            tableView.reloadData()
            navigationConfigiration()
        }
    }
    
    private var isInSearchMode: Bool
    {
        return searchcontroller.isActive && !searchcontroller.searchBar.text!.isEmpty
    }
    
    private var allTweets = [Tweets]()
    
    private var searchcontroller = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIwithTitle(with: "Explore")
        configureCurrentUserInformation()
        tableView.register(ExploreUserCell.self, forCellReuseIdentifier: cellidentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        navigationConfigiration()
        configureSearchBar()
    }
    
//     Initialized current User data
//    ===================================
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationConfigiration()
    }
    func configureCurrentUserInformation()
    {
        guard let currentuserId = Auth.auth().currentUser?.uid else {return}
        Services.shared.FetchSpecificUser(currentUserId: currentuserId) { myUser in
            self.currentUser = myUser
        }
        
        Services.shared.fetchAllUserds { MycurrentUser in
            
            DispatchQueue.main.async {
                 self.allUsers = MycurrentUser
                self.tableView.reloadData()
            }
        }
        
    }
//=====================================================================
    func navigationConfigiration()
    {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barStyle = .default
        self.tableView.reloadData()
    }
//=====================================================================
    
    
    
    func configureSearchBar()
    {
        searchcontroller.searchResultsUpdater = self
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.hidesNavigationBarDuringPresentation = false
        searchcontroller.searchBar.placeholder = "Search for User"
        navigationItem.searchController = searchcontroller
        self.definesPresentationContext = false
        self.tableView.reloadData()
    }
    
}
extension ExploreController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isInSearchMode ? filteredUserdetails.count : allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as? ExploreUserCell
            else {return UITableViewCell()
                
        }
        cell.selectedUserDrtails = isInSearchMode ? filteredUserdetails[indexPath.row] : allUsers[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = isInSearchMode ? filteredUserdetails[indexPath.row] : allUsers[indexPath.row]
        let controller = ProfileViewController(Myyuser: selectedCell)
        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension ExploreController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}

        filteredUserdetails = allUsers.filter({ $0.userfullname.contains(searchText.lowercased())})
    }
}
