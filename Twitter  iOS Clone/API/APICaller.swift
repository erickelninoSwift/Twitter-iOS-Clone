//
//  APICaller.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/17.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation
import Firebase

struct Userdetails
{
    let email : String?
    let password :String?
    let fullname : String?
    let username : String?
    let myProfilepicImage: UIImage?
    let myImageDataName: String?
    let MyImagedata: Data?
    
}

struct LoginDetails
{
    let useremail:String
    let userPassword: String
}

class APICaller
{
    static let shared = APICaller()
    
    
    func registerUser(CurrentUserdetails: Userdetails, completion: @escaping(Error?,DatabaseReference) -> Void)
    {
        let profile_Photo_ref = ERICKELNINO_JACKPOT_STORAGE_PROFILIMAGE.child(CurrentUserdetails.myImageDataName ?? "")
        profile_Photo_ref.putData(CurrentUserdetails.MyImagedata ?? Data()) { (meta, Error) in
            if let error =  Error
            {
                print("DEBUG: There was an error when trying to save your profilepic \(error.localizedDescription)")
                return
            }
            
            profile_Photo_ref.downloadURL { (URL, Error) in
                if let error = Error
                {
                    print("DEBUG: Could not retrieve Profile pic URL \(error.localizedDescription)")
                    return
                }
                guard let ImageURL  = URL?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: CurrentUserdetails.email ?? "", password: CurrentUserdetails.password ?? "") { (Results, Error) in
                    
                    if let error = Error
                    {
                        print("DEBUG: error \(error.localizedDescription)")
                        
                        return
                    }
                    guard let uuid = Results?.user.uid else {return}
                    
                    let userdata: [String: Any] = ["User_id": uuid,"Fullname": CurrentUserdetails.fullname ?? "" , "Username": CurrentUserdetails.username ?? "" , "Email": CurrentUserdetails.email ?? "" , "ImageUrl": ImageURL,"User_pasword":CurrentUserdetails.password ?? ""]
                    
                    ERICKLNINO_JACKPOT_USERS_REF.child(uuid).updateChildValues(userdata, withCompletionBlock: completion)
                    
                }
            }
        }
    }
    
    func SignInUser(currentUser: LoginDetails, completion: @escaping(AuthDataResult?,Error?) ->Void)
    {
        Auth.auth().signIn(withEmail: currentUser.useremail, password: currentUser.userPassword, completion: completion)
    }
}
