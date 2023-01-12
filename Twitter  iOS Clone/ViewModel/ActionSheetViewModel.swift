//
//  ActionSheetViewModel.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/20.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation

struct ActionSheetViewModel
{
    private let user: User
    
    var options : [ActionSheetOptions]
    {
        var results = [ActionSheetOptions]()
        if user.iscurrentUssr
        {
            results.append(.delete)
        }else
        {
            if user.isUserFollowed
            {
                results.append(.unfollow(user))
            }else
            {
                results.append(.follow(user))
            }
        }
        results.append(.report)
        results.append(.Logout)
        
        return results
    }
    
    init(user: User) {
        self.user = user
        print("DEBUG: USER SET FROM ACTIONSHEETVIEWMODEL \(self.user)")
    }
}

enum ActionSheetOptions
{
    case follow(User)
    case unfollow(User)
    case report
    case delete
    case Logout
    
    
    var description: String
    {
        switch self
        {
        case .follow(let user): return "Follow @\(user.Username ?? "")"
        case .unfollow(let user): return "Unfollow @\(user.Username ?? "")"
        case .report: return "Report Tweet"
        case .delete: return "Delete Tweet"
        case .Logout: return "Logout"
        }
    }
}
