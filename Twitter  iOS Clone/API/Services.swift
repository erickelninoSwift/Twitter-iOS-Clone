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
            print("DEBUG: Current snpa \(snapshot)")
            print("DEBUG: Current USER_ID: \(currentUserId)")
            
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
}
