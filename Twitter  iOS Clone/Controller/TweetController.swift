//
//  TweetController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/14.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

private let collectionViewIdentifier = "TweetController"
private let headeridentifier = "HeaderCellIdentifier"

protocol TweetControllerDelegateLogoutbutton: AnyObject
{
    func logoutactionTriggered(with action:TweetController)
}


protocol DismissTweetControllerDelegate: AnyObject {
    func dismissClass(current Controller:TweetController , userTweettodelete: Tweets ,user: User, Indexpath: Int)
}


class TweetController: UICollectionViewController
{
    
    
    weak var delegate: DismissTweetControllerDelegate?
    weak var erickDelegate: TweetControllerDelegateLogoutbutton?
    
    private var userTweets: Tweets
    private var userSelcted: User
    
    private var actionSheetLauncher: ActionSheetLauncher!
    
    private var alluserTweets = [Tweets]()
    
    private var AllReplies = [Tweets]()
    {
        didSet
        {
            collectionView.reloadData()
        }
    }
    
    var TweetPosition: Int?
    {
        didSet
        {
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    
    init(currenrUseselected: User,UserTweetsSelcted: Tweets, selctedTweetIndex: Int? = nil) {
        
        
        self.userSelcted = currenrUseselected
        self.userTweets = UserTweetsSelcted
        self.TweetPosition = selctedTweetIndex
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        fetchAllcurrentUserTweets()
        getAllreplies()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tweet"
        congfigureCollectionView()
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetControllerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headeridentifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: collectionViewIdentifier)
        collectionView.backgroundColor = .white
    }
    
    
    fileprivate func congfigureCollectionView()
    {
        collectionView.backgroundColor = .systemPink
    }
}

extension TweetController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllReplies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifier, for: indexPath) as? TweetCell else {return UICollectionViewCell()}
        let viewmodel = TweetViewModel(tweet: AllReplies[indexPath.row])
        cell.AllmyTweet = viewmodel
        cell.delelgate = self
        return cell
    }
}


// Determone the size of each cells

extension TweetController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewmodel = TweetViewModel(tweet: userTweets)
        let captioncell = viewmodel.size(width: view.frame.width).height
        return CGSize(width: view.frame.width, height: captioncell + 300)
    }
}


extension TweetController
{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headeridentifier, for: indexPath) as? TweetControllerHeader
            else { return UICollectionReusableView()}
        header.userSelcted = userSelcted
        header.tweets = userTweets
        header.delegate = self
        //        header.erickelninodelegate = self
        return header
    }
}

extension TweetController
{
    fileprivate func fetchAllcurrentUserTweets()
    {
        TweetService.shared.getchSpecificUserTweets(user: userSelcted) { (TweetsUser) in
            self.alluserTweets = TweetsUser
            self.collectionView.reloadData()
        }
    }
}

extension TweetController
{
    func getAllreplies()
    {
        TweetService.shared.fetchAllreplies(tweet: userTweets) { (tweet) in
            DispatchQueue.main.async {
                self.AllReplies = tweet
                self.collectionView.reloadData()
            }
            
        }
    }
}


extension TweetController: TweeterHeaderDelegate
{
    func handleMentionTapped(with User: String) {
        
    }
    
    
    func actionsheetPressed() {
        if userSelcted.iscurrentUssr
        {
            
            showActionSheet(userTweets.user)
            actionSheetLauncher.currentUser.isUserFollowed = false
            
        }else
        {
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            
            Services.shared.checkifuserFollowed(userid: userSelcted.user_id , currentUserID: currentUser) { isFollowed in
                print("DEBUG: USER IS FOLLOWED: \(isFollowed)")
                var user = self.userSelcted
                user.isUserFollowed = isFollowed
                self.showActionSheet(user)
            }
        }
    }
    
    
    
    fileprivate func showActionSheet(_ user: User) {
        self.actionSheetLauncher = ActionSheetLauncher(user: user)
        self.actionSheetLauncher.delegate = self
        self.actionSheetLauncher.show()
    }
    
}

extension TweetController: ActionsheetLaucherDelegate
{
    func didSelectOption(option: ActionSheetOptions, currentActionsheetLauncher: ActionSheetLauncher) {
        UIView.animate(withDuration: 0.8, animations: {
            
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            
            switch option
            {
                
            case .follow(let user):
                Services.shared.userFollowing(usertofollow: user.user_id, currentID: currentUser) { (err, dataref) in
                    if err != nil
                    {
                        print("DEBUG: Error while following User \(err!.localizedDescription)")
                        return
                    }
                    self.collectionView.reloadData()
                }
                
            case .unfollow(let user):
                Services.shared.unfollowUser(currentuserid: currentUser, usertoUnfollowId: user.user_id) { (err, dataref) in
                    if err != nil
                    {
                        print("DEBUG: Error while unfollowing user \(err!.localizedDescription)")
                        return
                    }
                    
                    self.collectionView.reloadData()
                    
                }
            case .report:
                print("DEBUG: Report Tweet")
                
            case .delete:
                
                guard let index = self.TweetPosition else {return}
                TweetService.shared.deleteTweet(tweetID: self.userTweets.mytweetId)
                self.delegate?.dismissClass(current: self, userTweettodelete: self.userTweets, user: self.userSelcted, Indexpath: index)
                
            case .Logout:
                
                self.erickDelegate?.logoutactionTriggered(with: self)
            }
            
            
        }) { (_) in
            currentActionsheetLauncher.HandleDismissal()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension TweetController: TweetCellDelagate
{
    func handleTappedMention(WithUser Username: String) {
        
    }
    
    
    func celltappedAction(currentCollectionCell: TweetCell) {
        
    }
    
    func replyButtonPressed(with cell: TweetCell) {
        
    }
    
    func didLikeTweet(Tweetcell: TweetCell) {
        print("DEBUG: Did Like Tweet ")
    }
    

    
}
