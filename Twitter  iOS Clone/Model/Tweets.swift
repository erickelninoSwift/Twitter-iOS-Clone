//
//  Tweets.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/23.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation

struct Tweets
{
    let caption:String
    let uuid: String
    let likes:Int
    let RetweetCount:Int
    let mytweetId:String
    var myTimeStamp: Date!
    var user: User
    var didLikeTweet: Bool = false
    
    
    init(with user: User,tweetId: String,dictionary:[String:Any]) {
        
        self.user = user
        self.mytweetId = tweetId
        self.caption = dictionary["Caption"] as? String ?? ""
        self.uuid = dictionary["uuid"] as? String ?? ""
        self.likes = dictionary["Likes"] as? Int ?? 0
        self.RetweetCount = dictionary["Retweets"] as? Int ?? 0
        self.myTimeStamp = Date(timeIntervalSince1970: dictionary["Timestamp"] as! Double)
    }
}

