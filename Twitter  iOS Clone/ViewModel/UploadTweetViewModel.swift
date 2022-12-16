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
            placeholderText = "Tweet your reply"
            shouldshowPreply = true
            replytextto = "Reply to @\(Tweet.user.Username ?? "")"
        }
    }
    
    
}
