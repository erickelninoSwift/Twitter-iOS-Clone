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
    var userProfileImageurl:String!
    var user_id: String!
    var Current_User_ID:String!
    
    
    init(userID: String, UserformDatabase:[String:Any]) {
    
        self.useremail = UserformDatabase["Email"] as? String
        self.userfullname = UserformDatabase["Fullname"] as? String
        self.Username = UserformDatabase["Username"] as? String
        self.userProfileImageurl = UserformDatabase["ImageUrl"] as? String
        self.user_id = UserformDatabase["User_id"] as? String
        self.Current_User_ID = userID
    }
}
