//
//  TextFieldValidation.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/17.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation


struct LoginValidation
{
    let email: String?
    let password: String?
    
    var isValid: Bool
    {
        guard let myemail = email , let mypass = password else {return false}
        
        return !myemail.isEmpty && !mypass.isEmpty
    }
}

struct RegistrationValidation
{
    let email: String?
    let password: String?
    let fullname: String?
    let username: String?
    
    var isValid: Bool
    {
        guard let myemail = email,let mypassword = password,let myfullname = fullname, let myusername = username else { return false}
        
        return !myemail.isEmpty && !mypassword.isEmpty && !myfullname.isEmpty && !myusername.isEmpty
    }
}
