//
//  ProfileViewController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/27.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

private let cellidentifier = "cell"
private let profileIdentifier = "ProfileHeader"

class ProfileViewController: UICollectionViewController
{
    
    
    var erickuser:User
    {
        didSet
        {
    
        }
    }
    
    //    private let erickmytweets: TweetViewModel
    
    var AllSpecifiUserTweets : [Tweets]?
    {
        didSet
        {
            collectionView.reloadData()
        }
    }
    
    private var selectedFielter: ProfileFliterCaseOption = .tweets
    {
        didSet{ print("Jackpot: \(selectedFielter.description)")}
    }
    
    private var likedTweets = [Tweets]()
   
    
    private var replies = [Tweets]()
  
    private var userTweets = [Tweets]()
   
    
    private var currentDataSource  = [Tweets]()
    {
        didSet
        {
            self.collectionView.reloadData()
        }
    }

    
    
    
    init(Myyuser: User) {
        self.erickuser = Myyuser
        //        self.erickmytweets = selctedTweet
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        chechuserexist()
        erickelninoAlltweets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUICollectionView()
        chechuserexist()
        navigationcontrollerDisplay()
//        refreshAllController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationcontrollerDisplay()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationcontrollerDisplay()
    }
    
    
    func refreshAllController()
    {
        let refreshcontrollerView = UIRefreshControl()
        self.collectionView.refreshControl = refreshcontrollerView
        refreshcontrollerView.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func erickelninoAlltweets()
    {
        self.collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.getchSpecificUserTweets(user: erickuser) { myTweets in
            DispatchQueue.main.async {
                self.currentDataSource = myTweets
                self.userTweets = myTweets
                self.collectionView.reloadData()
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func configureUICollectionView()
    {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellidentifier)
        collectionView.register(ProfileViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileIdentifier)
        
        guard let tabHeight = tabBarController?.tabBar.frame.height else {return }
        self.collectionView.contentInset.bottom = tabHeight
    }
}
extension ProfileViewController: UICollectionViewDelegateFlowLayout
{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as? TweetCell
            else
        {
            return UICollectionViewCell()
        }
        
        let currenttweets = currentDataSource[indexPath.row]
        print("DEBUG: REPLY : \(currenttweets.replyingTo ?? "")")
        let currentTweet = TweetViewModel(tweet: currenttweets)
        cell.AllmyTweet = currentTweet
        
        return cell
    }
    
    
    func chechuserexist()
    {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let usertoFollowID = erickuser.user_id else {return}
        
        if currentUserId != usertoFollowID
        {
            Services.shared.checkifuserFollowed(userid: usertoFollowID, currentUserID: currentUserId) { isfollowed in
                self.erickuser.isUserFollowed = isfollowed
                self.collectionView.reloadData()
            }
        }
    }
    
}
extension ProfileViewController
{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileIdentifier, for: indexPath) as? ProfileViewHeader
            else {return UICollectionReusableView()
                
        }
        header.myerickUser = erickuser
        header.delegate = self
        header.configureFollowers()
        fetchCurrentUserStats()
       
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 380)
    }
    
    func fetchCurrentUserStats()
    {
        guard let currentuser = erickuser.user_id else {return}
        Services.shared.fetchUserStats(userId: currentuser) { (userstats) in

            self.erickuser.userStats = userstats
            self.collectionView.reloadData()
        }
    }
}
extension ProfileViewController: profileGeaderViewDelegate
{
    func FilterSelected(filterSelected: ProfileFliterCaseOption, user: User) {
        
        self.selectedFielter = filterSelected
        
        switch self.selectedFielter
        {
        case .likes:
            TweetService.shared.fetchLikesTweet(user: user) { (AllTweets) in
                self.likedTweets = AllTweets
                self.currentDataSource = self.likedTweets
               
            }
        case .replies:

            TweetService.shared.userSelectedAllReplies(user: user) { TweetsUser in
                self.replies = TweetsUser
                self.currentDataSource = self.replies
                
            }
          
        case .tweets:
            self.currentDataSource = self.userTweets
        }
    }
    
  
   
    func followandunfollow(profilfheader: ProfileViewHeader, myuser: User) {
        chechuserexist()
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let usertoFollowID = myuser.user_id else {return}
        
        
        if currentUserId != usertoFollowID
        {
            if erickuser.isUserFollowed
            {
                unfollowuser(currentUserid: currentUserId, usertounfollowId: usertoFollowID, profile: profilfheader)
            }else
            {
                followUser(currentUserid: currentUserId, usertofollowId: usertoFollowID, profile: profilfheader)
                NotificationServices.shared.uploadNotification(notificationType: .follow, user: myuser)
            }
        }else
        {
            
        }
    }
    
    func dismissController() {
        
        self.navigationController?.popViewController(animated: true)
    }
}




extension ProfileViewController
{
    
    
    func unfollowuser(currentUserid: String, usertounfollowId: String, profile: ProfileViewHeader)
    {
        Services.shared.unfollowUser(currentuserid: currentUserid, usertoUnfollowId: usertounfollowId) { (Error, DataRefence) in
            if Error != nil
            {
                print("DEBUG: Error While unfollowing User: \(Error!.localizedDescription)")
                return
            }
            
            Database.database().reference().child("User-followers").child(usertounfollowId).child(currentUserid).removeValue { (Error, dataRef) in
                if Error != nil
                {
                    print("DEBUG: Error while unfollowing user: \(Error!.localizedDescription)")
                    return
                }
                self.erickuser.isUserFollowed = false
                self.collectionView.reloadData()
            }
        }
    }
    
    func followUser(currentUserid: String, usertofollowId: String, profile:ProfileViewHeader )
    {
        Services.shared.userFollowing(usertofollow: usertofollowId, currentID: currentUserid) { (Error, DataRef) in
            if let error = Error
            {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            Database.database().reference().child("User-followers").child(usertofollowId).updateChildValues([currentUserid: 1]) { (Error, datareference) in
                if Error != nil
                {
                    print("DEBUG: Error \(Error!.localizedDescription)")
                    return
                }
                self.erickuser.isUserFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
}

extension ProfileViewController
{
    
    func navigationcontrollerDisplay()
    {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        self.collectionView.reloadData()
    }
}

extension ProfileViewController
{
    @objc func handleRefresh()
    {
        erickelninoAlltweets()
    }
}

