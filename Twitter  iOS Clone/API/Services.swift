//
//  Services.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/19.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

typealias DatabaseCompletion = ((Error?,DatabaseReference) ->Void)

struct Services
{
    static let shared = Services()
    
    func FetchUser(completion: @escaping(User) -> Void)
    {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        ERICKLNINO_JACKPOT_USERS_REF.child(currentUserId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            let myUser = User(UserformDatabase: dictionary)
            if myUser.user_id == currentUserId
            {
                 completion(myUser)
            }else
            {
                print("No data was found")
                return
            }
        }
    }
    
    func FetchSpecificUser(currentUserId: String ,completion: @escaping(User) -> Void)
    {
           ERICKLNINO_JACKPOT_USERS_REF.child(currentUserId).observeSingleEvent(of: .value) { (snapshot) in
               
               guard let dictionary = snapshot.value as? [String:Any] else { return }
               let myUser = User(UserformDatabase: dictionary)
               if myUser.user_id == currentUserId
               {
                    completion(myUser)
               }else
               {
                   print("No data was found")
                   return
               }
           }
       }
    
    
    func fetchAllUserds(completion: @escaping([User]) ->Void)
    {
        var allusersData = [User]()
        
        ERICKLNINO_JACKPOT_USERS_REF.observe(.childAdded) { snapshot in
            guard let data = snapshot.value else {return}
            guard let currentData = data as? [String:Any] else {return}
            let viewmodel = User(UserformDatabase: currentData)
            allusersData.append(viewmodel)
            completion(allusersData)
            print("DEBUG: USERS SET SUCCESSFULLY")
        }
    }
    
    
    func userFollowing(usertofollow: String ,currentID: String ,completion: @escaping(DatabaseCompletion))
    {
        Database.database().reference().child("User-following").child(currentID).updateChildValues([usertofollow: 1], withCompletionBlock: completion)
    }
    
    func unfollowUser(currentuserid: String, usertoUnfollowId: String, completion: @escaping(DatabaseCompletion))
    {
        Database.database().reference().child("User-following").child(currentuserid).child(usertoUnfollowId).removeValue(completionBlock: completion)
    }
}
