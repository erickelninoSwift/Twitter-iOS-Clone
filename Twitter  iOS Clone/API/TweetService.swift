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
        
        var values = ["uuid": uuid , "Timestamp": Int(NSDate().timeIntervalSince1970), "Likes": 0 , "Retweets":0 , "Caption": caption] as [String:Any]
        
        switch config
        {
        case .Tweet:
            
            ERICKELNINO_JACKPOT_TWEET_REF.childByAutoId().updateChildValues(values) { (Error, DatabaseReference) in
                
                ERICKELNINO_JACKPOT_USER_TWEET.child(uuid).updateChildValues([DatabaseReference.key ?? "":1])
            }
            
        case .Reply(let tweet):
            values["replyingTo"] = tweet.user.Username
            ERICKELNINO_JACKPOT_TWEET_REPLY.child(tweet.mytweetId).childByAutoId().updateChildValues(values) { Error, DatabaseReference in
                
                guard let replieID = DatabaseReference.key else {return}
                
                Database.database().reference().child("Users-Replies").child(uuid).updateChildValues([tweet.mytweetId: replieID])
            }
            
        }
        
    }
    
    func fetchAllTweets(completion: @escaping([Tweets]) -> Void)
    {
        var CurrentUserTweet = [Tweets]()
        
        guard let curreuserID = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("User-following").child(curreuserID).observe(.childAdded) { (mysnapshots) in
            
            let useryoufollowID = mysnapshots.key
            
            Database.database().reference().child("Users-Tweets").child(useryoufollowID).observe(.childAdded) { userTweetsnapshots in
                
                let userYouFollowTweetID = userTweetsnapshots.key
                Database.database().reference().child("Tweets").child(userYouFollowTweetID).observeSingleEvent(of: .value) { snapyshots in
                    guard let currentTweet = snapyshots.value as? [String:Any] else {return}
                    Services.shared.FetchSpecificUser(currentUserId: useryoufollowID) { UserTweets in
                        let MyTweetTopass = Tweets(with: UserTweets, tweetId: userYouFollowTweetID, dictionary: currentTweet)
                        CurrentUserTweet.append(MyTweetTopass)
                        completion(CurrentUserTweet)
                    }
                }
            }
        }
        
        
        Database.database().reference().child("Users-Tweets").child(curreuserID).observe(.childAdded) { userTweetsnapshots in
            
            let userYouFollowTweetID = userTweetsnapshots.key
            Database.database().reference().child("Tweets").child(userYouFollowTweetID).observeSingleEvent(of: .value) { snapyshots in
                guard let currentTweet = snapyshots.value as? [String:Any] else {return}
                Services.shared.FetchSpecificUser(currentUserId: curreuserID) { UserTweets in
                    let MyTweetTopass = Tweets(with: UserTweets, tweetId: curreuserID, dictionary: currentTweet)
                    CurrentUserTweet.append(MyTweetTopass)
                    completion(CurrentUserTweet)
                }
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
    // MARK: - Fetch All Replies
    
    func userSelectedAllReplies(user: User , completion: @escaping([Tweets]) ->Void)
    {
        var allreplies = [Tweets]()
        
        Database.database().reference().child("Users-Replies").child(user.user_id).observe(.childAdded, with: { snapshot in
            
            if snapshot.exists() && allreplies.isEmpty
            {
                
                guard let replyId = snapshot.value as? String else {return}
                let tweetId = snapshot.key
                Database.database().reference().child("Tweets-replies").child(tweetId).child(replyId).observe(.value) { (mysnapshot) in
                    guard let dictionary = mysnapshot.value as? [String:Any] else {return}
                    guard let userid = dictionary["uuid"] as? String else {return}
                    
                    print("DEBUG: \(dictionary)")
                    
                    Services.shared.FetchSpecificUser(currentUserId: userid) { currentUser in
                        let tweets = Tweets(with: currentUser, tweetId: replyId, dictionary: dictionary)
                        allreplies.append(tweets)
                        completion(allreplies)
                    }
                }
            }else if !snapshot.exists() && allreplies.count == 0
            {
                completion(allreplies)
            }
            
            
        }, withCancel: nil)
        
    }
    //==========================================================
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
    
    func fetchLikesTweet(user: User , completion: @escaping([Tweets]) ->Void)
    {
        var tweetLiked = [Tweets]()
        
        print("DEBUG: User is : \(user.Username ?? "")")
        Database.database().reference().child("Users-Likes").child(user.user_id).observe(.childAdded) { (snapshots) in
            
            Database.database().reference().child("Tweets").child(snapshots.key).observeSingleEvent(of: .value) { (mysnapshots) in
                guard let dictionary = mysnapshots.value as? [String:Any] else {return}
                guard let userTweet = dictionary["uuid"] as? String  else {return}
                Services.shared.FetchSpecificUser(currentUserId: userTweet) { userToFetch in
                    var tweet = Tweets(with: userToFetch, tweetId: snapshots.key, dictionary: dictionary)
                    tweet.didLikeTweet = true
                    tweetLiked.append(tweet)
                    completion(tweetLiked)
                }
                
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
    
    func fetchSpecificTweet(tweetID: String, completion: @escaping(Tweets) ->Void)
    {
        ERICKELNINO_JACKPOT_TWEET_REF.child(tweetID).observeSingleEvent(of: .childAdded) { (snapshot) in
            guard  let dictionary = snapshot.value as? [String:Any] else {return}
            guard let uuid = dictionary["uuid"] as? String else {return}
            
            Services.shared.FetchSpecificUser(currentUserId: uuid) { User in
                let tweet = Tweets(with: User, tweetId: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    
}
