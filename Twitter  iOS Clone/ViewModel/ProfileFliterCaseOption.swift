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
    var myuser: User
    
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
        
        
        if currentuser == myuser.user_id
        {
            return "Edit profile"
        }else if !myuser.isUserFollowed && !myuser.iscurrentUssr
        {
            return "Follow"
        }else if myuser.isUserFollowed && !myuser.iscurrentUssr
        {
            return "Following"
        }
        
        return "Loading"
    }
    
    
    var myfollowers:Int
    {
        return myuser.userStats?.followers ?? 0
    }
    
    var myFollowing:Int
    {
        return myuser.userStats?.following ?? 0
    }
    
    
    var userFollowing: NSAttributedString?
    {
        return atttributedText(with: myFollowing, text: "following")
    }
    
    var userFollowers: NSAttributedString?
    {
        return atttributedText(with: myfollowers, text: "followers")
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
