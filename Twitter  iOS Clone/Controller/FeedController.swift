//
//  FeedController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/15.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

protocol fetchUserData: AnyObject
{
    func getCurrentUserdata(currentUser: User)
}

class FeedController: UICollectionViewController
{
    
    
    private var AllmyTweets = [Tweets]()
    

    
    var user: User?
    {
        didSet
        {
            print("USER SET FEEDCONTROLLER")
            newAddleftviewButton()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        FetchAllTweetFromDatabase()
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.cellIdentifier)
        collectionView.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    func newAddleftviewButton()
    {
        guard let myUser = user else {return}
        
        let profilImageview = UIImageView()
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
        TweetService.shared.fetchAllTweets { Tweets in
            self.AllmyTweets = Tweets
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func handleuserprofile()
    {
        guard let currentUser = user else {return}
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        
        if currentUser.Current_User_ID == currentId
        {
            TweetService.shared.getchSpecificUserTweets(userSelectedId: currentId) { Allmytweets in
                 let viewmodel = TweetViewModel(tweet: Allmytweets.first!)
                let controller = ProfileViewController(Myyuser: currentUser, selctedTweet: viewmodel)
                controller.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }else
        {
            return
        }
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
        return cell
    }
    
    
}

//Fix size of each Cells

extension FeedController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}


extension FeedController: TweetCellDelagate
{
    func celltappedAction(currentCollectionCell: TweetCell, myTweetSelected: TweetViewModel) {
        
        guard let erickeninoUser = currentCollectionCell.AllmyTweet?.tweet.user else {return}
        let controller = ProfileViewController(Myyuser: erickeninoUser, selctedTweet: myTweetSelected)
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
}
