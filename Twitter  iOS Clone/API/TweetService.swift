//
//  TweetService.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/23.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Firebase


struct TweetService
{
    static let shared = TweetService()
    
    func uploadTweet(caption: String , completion: @escaping(Error?,DatabaseReference) ->Void)
    {
        guard let uuid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["uuid": uuid , "Timestamp": Int(NSDate().timeIntervalSince1970), "Likes": 0 , "Retweets":0 , "Caption": caption] as [String:Any]
        
        let DATABASE = ERICKELNINO_JACKPOT_TWEET_REF.childByAutoId()
        
        guard let Tweet_ID = DATABASE.key else {return}
        
        //        let userTweetsValue = ["id":Tweet_ID] as [String:Any]
        
        DATABASE.updateChildValues(values) { (Error, DatabaseReference) in
            if let error = Error
            {
                print("DEBUG: There was an error while saving data to the database \(error.localizedDescription)")
                return
            }
            
            ERICKELNINO_JACKPOT_USER_TWEET.child(uuid).updateChildValues([Tweet_ID:1], withCompletionBlock: completion)
        }
    }
    
    func fetchAllTweets(completion: @escaping([Tweets]) -> Void)
    {
        var CurrentUserTweet = [Tweets]()
        
        
        ERICKELNINO_JACKPOT_TWEET_REF.observe(.childAdded){ (snapshot) in
            
            let myTweetsId = snapshot.key
            
            guard let currentDatavalue = snapshot.value as? [String:Any] else {return}
            guard let user_Id =  currentDatavalue["uuid"] as? String else {return}
            Services.shared.FetchSpecificUser(currentUserId: user_Id) { (User) in
                
                let currenttweet  = Tweets(with: User, tweetId: myTweetsId, dictionary: currentDatavalue)
                CurrentUserTweet.append(currenttweet)
                completion(CurrentUserTweet)
            }
        }
    }
    
    func getchSpecificUserTweets(user: User, completion: @escaping([Tweets]) -> Void)
    {
        
        var CurrentUserTweet = [Tweets]()
        
        
        ERICKELNINO_JACKPOT_USER_TWEET.child(user.user_id).observe(.childAdded){ (snapshot) in
            
            let myTweetsId = snapshot.key

            ERICKELNINO_JACKPOT_TWEET_REF.child(myTweetsId).observeSingleEvent(of: .value) { (snapingtweets) in
                guard let dataforuser = snapingtweets.value as? [String:Any] else {return}
                let mytweets = Tweets(with: user, tweetId: myTweetsId, dictionary: dataforuser)
                CurrentUserTweet.append(mytweets)
                completion(CurrentUserTweet)
            }
            
        }
        
    }
    
}
