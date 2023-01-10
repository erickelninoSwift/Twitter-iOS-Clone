//
//  editProfileViewModel.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2023/01/09.
//  Copyright © 2023 Erick El nino. All rights reserved.
//

import Foundation

enum editprofileOptions: Int , CaseIterable
{
    case Fullname
    case Username
    case bio
    
    var description: String
    {
        switch self
        {
        case .Fullname: return  "Fullname"
        case .Username: return "Username"
        case .bio: return "Bio"
        }
    }
}

struct editProfileViewModel
{
    let user:User
    var option: editprofileOptions
    
    var titleText: String
    {
        return option.description
    }
    
    var optionValue: String
    {
        switch option
        {
        case .Fullname: return user.userfullname
           
        case .Username: return user.Username
            
        case .bio: return "Bio"
           
        }
    }
    
    var shouldhidetextfield: Bool
    {
        return option == .bio
    }
    
    var shouldhideTextview: Bool
    {
        return option != .bio 
    }
    
    init(user:User , options: editprofileOptions)
    {
        self.user = user
        self.option = options
    }
}
