//
//  User.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/19.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

struct User
{
    var useremail: String!
    var userfullname: String!
    var Username: String!
    var userProfileImageurl:URL?
    var user_id: String!
    
    var isUserFollowed: Bool = false
 
    var iscurrentUssr:Bool
    {
        let currentUser = Auth.auth().currentUser?.uid
        return currentUser == user_id
    }
    
    
    init(UserformDatabase:[String:Any]) {
    
        self.useremail = UserformDatabase["Email"] as? String
        self.userfullname = UserformDatabase["Fullname"] as? String
        self.Username = UserformDatabase["Username"] as? String
        if let profilurlstring = UserformDatabase["ImageUrl"] as? String
        {
            guard let prourl = URL(string: profilurlstring) else {return}
            self.userProfileImageurl = prourl
        }else
        {
            return
        }
        self.user_id = UserformDatabase["User_id"] as? String
       
    }
}

struct UserDetails
{
    
    var UserId: String!
    var Fullname: String!
    var Username: String!
    var Email: String!
    var userProfileImageurl:String!
    var password:String!
    
    init(UserdetailsDataL : [String:Any]) {
        
        self.UserId = UserdetailsDataL["User_id"] as? String
        self.Fullname = UserdetailsDataL["Fullname"] as? String
        self.Username = UserdetailsDataL["Username"] as? String
        self.Email = UserdetailsDataL["Email"] as? String
        self.userProfileImageurl = UserdetailsDataL["ImageUrl"] as? String
        self.password = UserdetailsDataL["User_pasword"] as? String
    }
                       
    
}
