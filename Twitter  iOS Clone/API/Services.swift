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
    
    func checkifuserFollowed(userid: String ,currentUserID: String, completion: @escaping(Bool) -> Void)
    {
        Database.database().reference().child("User-following").child(currentUserID).child(userid).observeSingleEvent(of: .value) { (snapshots) in
            print("DEBUG: USER EXIST : \(snapshots.exists())")
            completion(snapshots.exists())
        }
    }
    
    
    func fetchUserStats(userId: String, completion: @escaping(UserRelationStats) -> Void)
    {
        Database.database().reference().child("User-followers").child(userId).observeSingleEvent(of: .value) { (snapshots) in
            let followers  = snapshots.children.allObjects.count
            Database.database().reference().child("User-following").child(userId).observeSingleEvent(of: .value) { (snaphotelnino) in
                let following = snaphotelnino.children.allObjects.count
                
                print("DEBUG: USER FOLLOWERS: \(followers) & FOLLOWING: \(following)")
                let currentUserstat = UserRelationStats(followers: followers, following: following)
                completion(currentUserstat)
            }
        }
    }
    
    
    func saveUserinfo(profileUser: User, completion: @escaping(DatabaseCompletion))
    {
        guard let userid = Auth.auth().currentUser?.uid else {return}
        
        let value = ["Fullname": profileUser.userfullname ?? "", "Username": profileUser.Username ?? "","bio": profileUser.userBio ?? ""]
        
        Database.database().reference().child("Users").child(userid).updateChildValues(value, withCompletionBlock: completion)
        
    }
    
    
    
    func UpdateprofileImage(Image: UIImage , completion: @escaping(URL?) -> Void)
    {
        guard let imageData = Image.jpegData(compressionQuality: 0.3) else {return}
        guard let currentuid = Auth.auth().currentUser?.uid else {return}
        let filename = NSUUID().uuidString
        
        let ref = ERICKELNINO_JACKPOT_STORAGE_PROFILIMAGE.child(filename)
        
        ref.putData(imageData) { (mystorage, Error) in
            if let error = Error
            {
                print("DEBUG: FILESTORAGE : \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let ImageURL = url?.absoluteString else {return}
                let value = ["ImageUrl": ImageURL]
                
                Database.database().reference().child("Users").child(currentuid).updateChildValues(value) { (Error, Dataref) in
                    print("DEBUG: PROFILE IMAGE UPDATED")
                    completion(url)
                }
                
            }
            
            
        }
        
    }
    
    func MentionProfileService(Username: String , completion: @escaping(User) ->Void)
    {
        Database.database().reference().child("Users-username").child(Username).observeSingleEvent(of: .value) { usersnapshot in
           
            print("DEBUG: \(usersnapshot)")
           
        }
    }
   
}
