//
//  TweetViewModel.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/25.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation
import UIKit

struct TweetViewModel
{
    var tweet: Tweets
    let ProfileURlImage:URL!
    let captionuser:String
    let username: String
    let fullname:String
    var likes: Int?
    {
        return tweet.likes
    }
    
    var Retweet: Int?
    {
        return tweet.RetweetCount
    }
    
 
    
    var myCurrentTimestamp:String?
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: tweet.myTimeStamp, to: now) ?? "1s"
    }
    
    
    var likeButtonColor: UIColor
    {
        var colorButton  = tweet.didLikeTweet ? UIColor.systemRed: UIColor.systemGray
        return colorButton
    }
    
    var likeButtonImage: UIImage
    {
        var imageName = tweet.didLikeTweet ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    var headerTimeStamp: String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        return formatter.string(from: tweet.myTimeStamp)
    }
    
    var retweetsNSAttributedString: NSAttributedString?
    {
        let attributed = NSAttributedString(string: "Retweets", attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.darkGray])
        let mutabelString = NSMutableAttributedString(string: "\(Retweet ?? 0)  ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15),.foregroundColor:UIColor.darkGray])
        mutabelString.append(attributed)
        return mutabelString
    }
    
    var likesAttributedString: NSAttributedString?
    {
        let attributed = NSAttributedString(string: "Likes", attributes: [.font:UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.darkGray])
        let mutabelString = NSMutableAttributedString(string: "\(likes ?? 0)  ", attributes: [.font: UIFont.boldSystemFont(ofSize: 15),.foregroundColor:UIColor.darkGray])
        mutabelString.append(attributed)
        return mutabelString
    }
    
    var userInfor: NSAttributedString
     {
         let nsstringAtt = NSAttributedString(string: "  @\(username) - \(myCurrentTimestamp!)", attributes: [.font:UIFont.systemFont(ofSize: 12), .foregroundColor:UIColor.lightGray])
         let attributed = NSMutableAttributedString(string: "\(fullname)", attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
         attributed.append(nsstringAtt)
          return attributed
     }
     
    
    
    init(tweet: Tweets)
    {
        self.tweet = tweet
        
        self.ProfileURlImage = tweet.user.userProfileImageurl
        self.username = tweet.user.Username
        self.fullname = tweet.user.userfullname
        self.captionuser = tweet.caption
        
    }
    
//     Resizing cell function
    
    func size(width: CGFloat) -> CGSize
    {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
