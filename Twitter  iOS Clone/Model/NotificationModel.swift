//
//  NotificationModel.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/25.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation
enum NotificationType: Int
{
    case follow
    case like
    case reply
    case retweet
}
struct NotificationModel
{
    var user: User
    var tweet: Tweets?
    var timestamp: Date!
    var TweetId: String?
    
    var type:NotificationType!
    
    
    init(user:User,dictionary: [String:Any]) {
        self.user = user
        
        if let tweetIDD = dictionary["tweetID"] as? String
        {
            self.TweetId = tweetIDD
        }
        
        if let timeStamp = dictionary["timestamp"] as? Double
        {
            self.timestamp = Date(timeIntervalSince1970: timeStamp)
        }
        
        if let type = dictionary["type"] as? Int
        {
            self.type = NotificationType(rawValue: type)
        }
    }
}
