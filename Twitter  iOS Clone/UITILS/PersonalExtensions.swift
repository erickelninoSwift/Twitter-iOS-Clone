//
//  PersonalExtensions.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/11.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation
import Firebase

class PersonalExtensions
{
    static let shared = PersonalExtensions()
    
    
    
    func unfollowuser(currentUserid: String, usertounfollowId: String ,completion: @escaping() ->Void)
    {
        Services.shared.unfollowUser(currentuserid: currentUserid, usertoUnfollowId: usertounfollowId) { (Error, DataRefence) in
            if Error != nil
            {
                print("DEBUG: Error While unfollowing User: \(Error!.localizedDescription)")
                return
            }
            
            Database.database().reference().child("User-followers").child(usertounfollowId).child(currentUserid).removeValue { (Error, dataRef) in
                if Error != nil
                {
                    print("DEBUG: Error while unfollowing user: \(Error!.localizedDescription)")
                    return
                }
                print("DEBUG: You were removed has his followers")

            }
        }
    }
    
    func followUser(currentUserid: String, usertofollowId: String, completion: @escaping() ->Void)
    {
        Services.shared.userFollowing(usertofollow: usertofollowId, currentID: currentUserid) { (Error, DataRef) in
            if let error = Error
            {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            Database.database().reference().child("User-followers").child(usertofollowId).updateChildValues([currentUserid: 1]) { (Error, datareference) in
                if Error != nil
                {
                    print("DEBUG: Error \(Error!.localizedDescription)")
                    return
                }
                print("DEBUG: DONE!!!")
                
            }
        }
    }

}
