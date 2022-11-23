//
//  TweetService.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/23.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Firebase
import Foundation

struct TweetService
{
    static let shared = TweetService()
    
    func uploadTweet(caption: String , completion: @escaping(Error?,DatabaseReference) ->Void)
    {
        guard let uuid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["uuid": uuid , "Timestamp": Int(NSDate().timeIntervalSince1970), "Likes": 0 , "Retweets":0 , "Caption": caption] as [String:Any]
        
           ERICKELNINO_JACKPOT_TWEET_REF.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchAllTweets(completion: @escaping([Tweets]) -> Void)
    {
        var CurrentUserTweet = [Tweets]()
        
        
        ERICKELNINO_JACKPOT_TWEET_REF.observe(.childAdded) { (snapshot) in
            
            let tweetID = snapshot.key
            
            guard let currentDatavalue = snapshot.value as? [String:Any] else {return}
            let currentTweet = Tweets(tweetID: tweetID, dictionary: currentDatavalue)
         
                CurrentUserTweet.append(currentTweet)
                completion(CurrentUserTweet)
        }
         
    }
}
