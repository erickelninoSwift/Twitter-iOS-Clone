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
    
    private var allUsers = [UserDetails]()
    
    private var allTweets = [Tweets]()
    
    private var searchcontroller = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIwithTitle(with: "Explore")
        configureCurrentUserInformation()
        tableView.register(ExploreUserCell.self, forCellReuseIdentifier: cellidentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        configureSearchBar()
    }
    
//     Initialized current User data
//    ===================================
    
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
//    ==============================
    
    
    
    func configureSearchBar()
    {
        searchcontroller.searchResultsUpdater = self
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.hidesNavigationBarDuringPresentation = false
        searchcontroller.searchBar.placeholder = "Search for User"
        navigationItem.searchController = searchcontroller
        self.definesPresentationContext = false
    }
    
}
extension ExploreController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as? ExploreUserCell
            else {return UITableViewCell()
                
        }
        cell.selectedUserDrtails = allUsers[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = allUsers[indexPath.row]
        print("DEBUG: \(selectedCell.Fullname!)")

    }
    
    
    func fecthAllmyTweets()
    {
        
    }
    
    
}

extension ExploreController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        
        
    }
}
