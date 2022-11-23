//
//  Tweets.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/23.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation
import Firebase


struct Tweets
{
    var caption:String?
    var TweetID:String?
    var uuid: String?
    var likes:Int?
    var RetweetCount:Int?
    var Timestamp: Date?
    
    init(tweetID: String , dictionary:[String:Any]) {
        
        
        guard let captionString = dictionary["caption"] as? String else {return}
        guard let retweetnumber = dictionary["Retweets"] as? Int else {return}
        guard let LikesNumber = dictionary["Likes"] as? Int else {return}
        guard let uid = dictionary["uuid"] as? String else {return}
        
        
        self.TweetID = tweetID
        self.caption = captionString
        self.uuid = uid
        self.likes = LikesNumber
        self.RetweetCount = retweetnumber
        if let TimeStamp = dictionary["Timestamp"] as? Double
        {
            self.Timestamp = Date(timeIntervalSince1970: TimeStamp)
        }
        
    }
    
}


//let values = ["uuid": uuid , "Timestamp": Int(NSDate().timeIntervalSince1970), "Likes": 0 , "Retweets":0 , "Caption": caption] as [String:Any]
