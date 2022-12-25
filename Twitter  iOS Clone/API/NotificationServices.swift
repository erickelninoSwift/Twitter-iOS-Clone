//
//  NotificationServices.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/25.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation
import Firebase

class NotificationServices
{
    static let shared = NotificationServices()
    
    func uploadNotification(notificationType: NotificationType, tweet: Tweets? = nil, user:User? = nil)
    {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        var values = ["timestamp": Int(NSDate().timeIntervalSince1970),"uid": currentUserId,"type": notificationType.rawValue] as [String:Any]
        
        if let mytweet = tweet
        {
            values["tweetID"] = mytweet.mytweetId
            ERICKELNINO_JACKPOT_NOTIFICATION.child(mytweet.user.user_id).childByAutoId().updateChildValues(values)
        }else if let user = user
        {
            ERICKELNINO_JACKPOT_NOTIFICATION.child(user.user_id).childByAutoId().updateChildValues(values)
        }
    }
}

