//
//  TweetViewModel.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/25.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation
import UIKit

struct TweetViewModel
{
    let tweet: Tweets
    let ProfileURlImage:URL!
    let captionuser:String
    let username: String
    let fullname:String
    var likes: Int?
    {
        return tweet.likes
    }
    
    var Retweet: Int?
    {
        return tweet.RetweetCount
    }
    
 
    
    var myCurrentTimestamp:String?
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: tweet.myTimeStamp, to: now) ?? "1s"
    }
    
    var userInfor: NSAttributedString
     {
         let nsstringAtt = NSAttributedString(string: "  @\(username) - \(myCurrentTimestamp!)", attributes: [.font:UIFont.systemFont(ofSize: 12), .foregroundColor:UIColor.lightGray])
         let attributed = NSMutableAttributedString(string: "\(fullname)", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
         attributed.append(nsstringAtt)
          return attributed
     }
     
    
    
    init(tweet: Tweets)
    {
        self.tweet = tweet
        
        self.ProfileURlImage = tweet.user.userProfileImageurl
        self.username = tweet.user.Username
        self.fullname = tweet.user.userfullname
        self.captionuser = tweet.caption
        
    }
}
