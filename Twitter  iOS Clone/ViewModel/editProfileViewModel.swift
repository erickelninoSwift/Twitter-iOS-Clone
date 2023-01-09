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
