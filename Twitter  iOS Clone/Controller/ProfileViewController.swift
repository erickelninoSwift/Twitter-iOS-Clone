//
//  ProfileViewController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/27.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

private let cellidentifier = "cell"
private let profileIdentifier = "ProfileHeader"

class ProfileViewController: UICollectionViewController
{
    
    
    private let erickuser:User
    private let erickmytweets: TweetViewModel
    
    private var AllSpecifiUserTweets = [Tweets]()
    
    
    init(Myyuser: User , selctedTweet: TweetViewModel) {
        self.erickuser = Myyuser
        self.erickmytweets = selctedTweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        AlltweetsForspecifiuser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUICollectionView()
        print("DEBUG: LEST SEE DATA PASSED ON : USER: \(erickuser) and THE TWEETS SELECTED: \(erickmytweets.captionuser)")
        
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
    
    
    func AlltweetsForspecifiuser()
    {
        TweetService.shared.getchSpecificUserTweets(userSelectedId: erickmytweets.tweet.uuid) { choloTweets in
            DispatchQueue.main.async {
                self.AllSpecifiUserTweets = choloTweets
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
        return AllSpecifiUserTweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as? TweetCell
        else
        {
            return UICollectionViewCell()
        }
         let currentTweet = TweetViewModel(tweet: AllSpecifiUserTweets[indexPath.row])
         cell.AllmyTweet = currentTweet
         return cell
    }
    
}
extension ProfileViewController
{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileIdentifier, for: indexPath) as? ProfileViewHeader
            else {return UICollectionReusableView()
                
        }
        header.myerickUser = erickuser
        header.erickTweets = erickmytweets
        header.delegate = self
        
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
    func dismissController() {
        print("DEBUG: DELEGATE RECERIVED DISMISS CONTROLLER")
        self.navigationController?.popViewController(animated: true)
    }
}



