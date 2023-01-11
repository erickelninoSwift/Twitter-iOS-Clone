//
//  FeedController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/15.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel
//protocol fetchUserData: AnyObject
//{
//    func getCurrentUserdata(currentUser: User)
//}


class FeedController: UICollectionViewController
{
    
    
    private var AllmyTweets = [Tweets]()
    {
        didSet
        {
            self.collectionView.reloadData()
        }
    }
    
    
    var user: User?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newAddleftviewButton()
        configureUI()
        FetchAllTweetFromDatabase()
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.cellIdentifier)
        collectionView.backgroundColor = .white
        self.collectionView.reloadData()
        refreshcontroller()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    func refreshcontroller()
    {
        let myRefreshController = UIRefreshControl()
        self.collectionView.refreshControl = myRefreshController
        myRefreshController.addTarget(self, action: #selector(handlerefrech), for: .valueChanged)
        
        
    }
    
    func newAddleftviewButton()
    {
        guard let myUser = user else {return}
        
        let profilImageview = UIImageView()
        profilImageview.translatesAutoresizingMaskIntoConstraints = false
        
        profilImageview.setDimensions(width: 40, height: 40)
        profilImageview.layer.masksToBounds = true
        profilImageview.layer.cornerRadius = 40 / 2
        profilImageview.sd_setImage(with: myUser.userProfileImageurl, completed: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profilImageview)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleuserprofile))
        
        profilImageview.addGestureRecognizer(tap)
        profilImageview.isUserInteractionEnabled = true
        
    }
    
    
    func FetchAllTweetFromDatabase()
    {
        self.collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchAllTweets { tweets in
    
            self.AllmyTweets = tweets.sorted(by: {$0.myTimeStamp > $1.myTimeStamp})
            self.checkLikes()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    
    func checkLikes()
    {
        self.AllmyTweets.forEach { (tweet) in
            TweetService.shared.checkuserlikeTweet(tweet: tweet) { DidlikeTweet in
                guard DidlikeTweet == true else {return}
                
                if let index = self.AllmyTweets.firstIndex(where: { $0.mytweetId == tweet.mytweetId})
                {
                    self.AllmyTweets[index].didLikeTweet = true
                }
            }
        }
    }
    
    
    @objc func handleuserprofile()
    {
        guard let currentUser = user else {return}
        let controller = ProfileViewController(Myyuser: currentUser)
        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension FeedController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllmyTweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.cellIdentifier, for: indexPath) as? TweetCell else
        {
            return UICollectionViewCell()
            
        }
        
        let thecurrentTweet = AllmyTweets[indexPath.row]
        cell.delelgate = self
        cell.AllmyTweet = TweetViewModel(tweet: thecurrentTweet)
        cell.Tweet = thecurrentTweet
        return cell
    }
}

//Fix size of each Cells

extension FeedController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewmodel = TweetViewModel(tweet: AllmyTweets[indexPath.row])
        let heightcell = viewmodel.size(width: view.frame.width).height
        return CGSize(width: view.frame.width, height: heightcell + 115)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userSlectedTweets = AllmyTweets[indexPath.row]
        let userSelected = AllmyTweets[indexPath.row].user
        let index = indexPath.row
        

        let controller = TweetController(currenrUseselected: userSelected, UserTweetsSelcted: userSlectedTweets, selctedTweetIndex: index)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
}


extension FeedController: TweetCellDelagate
{
    func activelabelAction(replyLabel: ActiveLabel, captionLabel: ActiveLabel) {
        replyLabel.handleMentionTap { elnino in
            print("DEBUG: Tap: \(elnino)")
        }
        replyLabel.handleHashtagTap { elnino in
            print("DEBUG: Tap: \(elnino)")
        }
        
        captionLabel.handleMentionTap { cholo in
            print("DEBUG: Tap: \(cholo)")
        }
        captionLabel.handleHashtagTap { cholo in
             print("DEBUG: Tap: \(cholo)")
        }
    }
    
    func didLikeTweet(Tweetcell: TweetCell) {
        
        guard let tweet  = Tweetcell.AllmyTweet?.tweet else {return}
        
        TweetService.shared.likeTweets(tweet: tweet) { (Error,dataref) in
            Tweetcell.AllmyTweet?.tweet.didLikeTweet.toggle()
            Tweetcell.AllmyTweet?.tweet.likes = tweet.didLikeTweet ? tweet.likes - 1 : tweet.likes + 1
            
        }
    }
    
    func replyButtonPressed(with cell: TweetCell) {
        guard let myUser = user else {return}
        
        guard let tweet = cell.AllmyTweet?.tweet else {return}
        
        let controller = UploadTweetController(user: myUser, config: .Reply(tweet))
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
    }
    
    func celltappedAction(currentCollectionCell: TweetCell) {
        
        guard let erickeninoUser = currentCollectionCell.AllmyTweet?.tweet.user else {return}
        
        let controller = ProfileViewController(Myyuser: erickeninoUser)
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension FeedController: DismissTweetControllerDelegate
{
    func dismissClass(current Controller: TweetController, userTweettodelete: Tweets, user: User, Indexpath: Int) {
        
        AllmyTweets.remove(at: Indexpath)
        collectionView.reloadData()
        
    }
}

extension FeedController
{
    @objc func handlerefrech()
    {
        
        FetchAllTweetFromDatabase()
        
    }
}
