//
//  TweetService.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/23.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Firebase


typealias MyCurrentDatabaseCompletion = ((Error?,DatabaseReference) ->Void)

struct TweetService
{
    static let shared = TweetService()
    
    func uploadTweet(caption: String , config: UploadTweetConfiguration)
    {
        guard let uuid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["uuid": uuid , "Timestamp": Int(NSDate().timeIntervalSince1970), "Likes": 0 , "Retweets":0 , "Caption": caption] as [String:Any]
        
        switch config
        {
        case .Tweet:
            
            ERICKELNINO_JACKPOT_TWEET_REF.childByAutoId().updateChildValues(values) { (Error, DatabaseReference) in
                
                ERICKELNINO_JACKPOT_USER_TWEET.child(uuid).updateChildValues([DatabaseReference.key ?? "":1])
            }
            
        case .Reply(let tweet):
            print("DEBUG: REPLY TWEET")
            
            ERICKELNINO_JACKPOT_TWEET_REPLY.child(tweet.mytweetId).childByAutoId().updateChildValues(values)
            
        }
        
        
        
        
        
        //        let userTweetsValue = ["id":Tweet_ID] as [String:Any]
        
        
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
    
    func fetchAllreplies(tweet: Tweets, completion: @escaping([Tweets]) -> Void)
    {
        var allreplies = [Tweets]()
        //
        ERICKELNINO_JACKPOT_TWEET_REPLY.child(tweet.mytweetId).observe(.childAdded) { (snapshots) in
            
            
            guard let currentUser = Auth.auth().currentUser?.uid else {return}
            Services.shared.FetchSpecificUser(currentUserId:currentUser) { (CurrentReplier) in
                guard let dictionary = snapshots.value as? [String:Any] else {return}
                let tweetReplyId = snapshots.key
                let myreplies = Tweets(with: CurrentReplier, tweetId: tweetReplyId, dictionary: dictionary)
                allreplies.append(myreplies)
                completion(allreplies)
            }
            
        }
    }
    
    func deleteTweet(tweetID: String)
    {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        print(currentUserId)
        
        ERICKELNINO_JACKPOT_USER_TWEET.child(currentUserId).child(tweetID).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists()
            {
                ERICKELNINO_JACKPOT_USER_TWEET.child(currentUserId).child(snapshot.key).removeValue { (Error, DatabaseRef) in
                    
                    ERICKELNINO_JACKPOT_TWEET_REF.child(snapshot.key).removeValue { (Error, DataReference) in
                        
                        ERICKELNINO_JACKPOT_TWEET_REPLY.child(snapshot.key).observeSingleEvent(of: .value) { (snapshot2) in
                            ERICKELNINO_JACKPOT_TWEET_REPLY.child(snapshot2.key).removeValue()
                        }
                    }
                }
            }
        }
    }
    
    
    func likeTweets(tweet: Tweets , completion: @escaping(MyCurrentDatabaseCompletion))
    {
        guard let currentUserid = Auth.auth().currentUser?.uid else {return}
        
        let likes = tweet.didLikeTweet ? tweet.likes - 1 : tweet.likes + 1
        ERICKELNINO_JACKPOT_TWEET_REF.child(tweet.mytweetId).child("Likes").setValue(likes)
        
        if tweet.didLikeTweet
        {
            //             Unlike Post
            ERICKELNINO_JACKPOT_USER_TWEET_LIKES.child(currentUserid).child(tweet.mytweetId).removeValue { (Error, Database) in
                ERICKELNINO_JACKPOT_LIKES_TWEET.child(tweet.mytweetId).child(currentUserid).removeValue(completionBlock: completion)
            }
            
        }else
        {
            
            ERICKELNINO_JACKPOT_USER_TWEET_LIKES.child(currentUserid).updateChildValues([tweet.mytweetId:1]) { (Error, Database) in
                ERICKELNINO_JACKPOT_LIKES_TWEET.child(tweet.mytweetId).updateChildValues([currentUserid:1], withCompletionBlock: completion)
                NotificationServices.shared.uploadNotification(notificationType: .like, tweet: tweet)
                
            }
        }
        
    }
    
    func checkuserlikeTweet(tweet: Tweets, completion: @escaping(Bool) ->Void)
    {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        ERICKELNINO_JACKPOT_USER_TWEET_LIKES.child(currentUserId).child(tweet.mytweetId).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot.exists())
        }
        
    }
    
    
}
