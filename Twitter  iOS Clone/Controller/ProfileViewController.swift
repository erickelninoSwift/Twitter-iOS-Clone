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
            fetchCurrentUserStats()
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
    
    
    init(Myyuser: User) {
        self.erickuser = Myyuser
//        self.erickmytweets = selctedTweet
     
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        erickelninoAlltweets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUICollectionView()
        chechuserexist()
        fetchCurrentUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func erickelninoAlltweets()
    {
        TweetService.shared.getchSpecificUserTweets(user: erickuser) { myTweets in
            DispatchQueue.main.async {
                self.AllSpecifiUserTweets = myTweets
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureUICollectionView()
    {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: cellidentifier)
        collectionView.register(ProfileViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: profileIdentifier)
    }
}
extension ProfileViewController: UICollectionViewDelegateFlowLayout
{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllSpecifiUserTweets?.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as? TweetCell
            else
        {
            return UICollectionViewCell()
        }
        
        if let currenttweets = AllSpecifiUserTweets?[indexPath.row]
        {
            let currentTweet = TweetViewModel(tweet: currenttweets)
            cell.AllmyTweet = currentTweet
    
            
        }
        
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
        print("DEBUG: USER SET FOR PROFILE HEADER: \(erickuser.userfullname!)")
        header.delegate = self
        header.configureFollowers()
      
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 380)
    }
}
extension ProfileViewController: profileGeaderViewDelegate
{
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
            }
        }else
        {
            print("DEBUG: SHOW PROFILE CONTROLLER")
        }
    }
    
    func dismissController() {
      
        self.navigationController?.popViewController(animated: true)
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


