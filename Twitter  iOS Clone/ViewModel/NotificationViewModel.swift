//
//  NotificationViewModel.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/26.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

struct NotificationViewModel {
    let notification: NotificationModel
    let type : NotificationType
    
    
    var timstampText: String?
    {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: notification.timestamp, to: now) ?? "1s"
    }
    
    
    var profileImageURL: URL?
    {
        return notification.user.userProfileImageurl
    }
    
    
    var notificationMessage: String
    {
        switch type
        {
            
        case .follow:
            return " Started following you "
        case .like:
            return " Liked your Tweet"
        case .reply:
            return " Replied to you Tweet"
        case .retweet:
            return " Retweeted your post"
        }
    }
    
    
    var notificationText: NSAttributedString?
    {
        guard let timestamp = timstampText else {return nil}
        
        let nsstringAtt = NSAttributedString(string: "\(notificationMessage)", attributes: [.font:UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.darkGray])
        let attributed = NSMutableAttributedString(string: "\(notification.user.Username ?? "")", attributes: [.font:UIFont.boldSystemFont(ofSize: 14), .foregroundColor:UIColor.black])
        let MyTimestamp = NSAttributedString(string: " \(timestamp)", attributes: [.font:UIFont.systemFont(ofSize: 14), .foregroundColor:UIColor.lightGray])
        attributed.append(nsstringAtt)
        attributed.append(MyTimestamp)
        return attributed
    }
    
    init(notification: NotificationModel) {
        self.notification = notification
        self.type = notification.type
    }
}
