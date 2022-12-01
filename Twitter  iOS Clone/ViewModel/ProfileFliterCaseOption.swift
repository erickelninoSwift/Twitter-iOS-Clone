//
//  ProfileFliterCaseOption.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/29.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

enum ProfileFliterCaseOption: Int, CaseIterable
{
    case tweets
    case replies
    case likes
    
    
    var description: String
    {
        switch self
        {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
    
        }
    }
}

struct ProfileheaderViewModel
{
    let myuser: User
    
    var username:String
    {
        return myuser.Username
    }
    
    var fullname:String
    {
        return myuser.userfullname
    }
    
     var actionButton: String
    {
        let currentuser = Auth.auth().currentUser?.uid
        return currentuser == myuser.Current_User_ID ? "Edit" : "Follow"
    }
    
    var myfollowers:Int? = 0
    var myFollowing:Int? = 0
    
    
    var userFollowing: NSAttributedString?
    {
        return atttributedText(with: 0, text: "following")
    }
    
    var userFollowers: NSAttributedString?
    {
        return atttributedText(with: 2, text: "followers")
    }
    
    init(user: User)
    {
        self.myuser = user
    }
    
    
    func atttributedText(with number: Int , text: String) -> NSAttributedString
    {
        
        let nsstringAtt = NSAttributedString(string: " \(text)", attributes: [.font:UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.lightGray])
        let attributed = NSMutableAttributedString(string: "\(number)", attributes: [.font:UIFont.boldSystemFont(ofSize: 14), .foregroundColor:UIColor.black])
        attributed.append(nsstringAtt)
         return attributed
    }
    
}
