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

class FeedController: UIViewController
{
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
        
    }
    
    
    func FetchAllTweetFromDatabase()
    {
        TweetService.shared.fetchAllTweets { Tweets in
           
        }
    }
}
