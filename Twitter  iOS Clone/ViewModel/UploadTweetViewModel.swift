//
//  UploadTweetViewModel.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

enum UploadTweetConfiguration
{
    case Tweet
    case Reply(Tweets)
}

struct UploadTweetViewModel
{
    var actionButtonTitle:String
    var placeholderText: String
    var shouldshowPreply: Bool
    var replytextto:String?
    var placeholderCustomized: UILabel?
    var attributedStringplaceholder:NSAttributedString?
    
    init(config: UploadTweetConfiguration)
    {
        switch config
        {
        case .Tweet:
            print("DEBUG: Tweet")
            actionButtonTitle = "Tweet"
           
            placeholderText = "What's happening ?"
            shouldshowPreply = false
        case .Reply(let Tweet):
            actionButtonTitle = "Reply"
            let attr = NSAttributedString(string: Tweet.user.Username, attributes: [.font:UIFont.systemFont(ofSize: 14, weight: .bold),.foregroundColor:UIColor.twitterBlue])
            let mutableAttr = NSMutableAttributedString(string: "Reply to @", attributes: [.font:UIFont.systemFont(ofSize: 13, weight: .semibold),.foregroundColor:UIColor.black])
            mutableAttr.append(attr)
            self.attributedStringplaceholder = mutableAttr
            placeholderText = "Tweet your reply "
            shouldshowPreply = true
            replytextto = "Reply to  @\(Tweet.user.Username ?? "")"
        }
    }
    
    
}
//let attr = NSAttributedString(string: Tweet.user.Username, attributes: [.font:UIFont.systemFont(ofSize: 14, weight: .semibold),.foregroundColor:UIColor.twitterBlue])
//let mutableAttr = NSMutableAttributedString(string: "Reply to @", attributes: [.font:UIFont.systemFont(ofSize: 13, weight: .semibold),.foregroundColor:UIColor.lightGray])
