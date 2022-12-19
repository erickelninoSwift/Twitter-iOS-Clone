//
//  TweetController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/14.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit


private let collectionViewIdentifier = "TweetController"
private let headeridentifier = "HeaderCellIdentifier"



class TweetController: UICollectionViewController
{
    
    private let userTweets: Tweets
    private let userSelcted: User
    
    private var alluserTweets = [Tweets]()
    
    private var AllReplies = [Tweets]()
    {
        didSet
        {
            collectionView.reloadData()
        }
    }
    
    
   
    
    
    
    init(currenrUseselected: User,UserTweetsSelcted: Tweets) {
        self.userSelcted = currenrUseselected
        self.userTweets = UserTweetsSelcted

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        print("DEBUG: TWEET CONTROLLER USER: \(currenrUseselected.userfullname ?? "") AND TWEETS: \(UserTweetsSelcted.caption)")
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
        return cell
    }
}


// Determone the size of each cells

extension TweetController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
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
