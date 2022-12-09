//
//  Services.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/19.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

struct Services
{
    static let shared = Services()
    
    func FetchUser(completion: @escaping(User) -> Void)
    {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        ERICKLNINO_JACKPOT_USERS_REF.child(currentUserId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            let myUser = User(userID: currentUserId, UserformDatabase: dictionary)
            if myUser.Current_User_ID == myUser.user_id
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
               let myUser = User(userID: currentUserId, UserformDatabase: dictionary)
               if myUser.Current_User_ID == myUser.user_id
               {
                    completion(myUser)
               }else
               {
                   print("No data was found")
                   return
               }
           }
       }
    
    
    func fetchAllUserds(completion: @escaping([UserDetails]) ->Void)
    {
        var allusersData = [UserDetails]()
        
        ERICKLNINO_JACKPOT_USERS_REF.observe(.childAdded) { snapshot in
            guard let data = snapshot.value else {return}
            guard let currentData = data as? [String:Any] else {return}
            let viewmodel = UserDetails(UserdetailsDataL: currentData)
            allusersData.append(viewmodel)
            completion(allusersData)
            print("DEBUG: USERS SET SUCCESSFULLY")
        }
    }
}
