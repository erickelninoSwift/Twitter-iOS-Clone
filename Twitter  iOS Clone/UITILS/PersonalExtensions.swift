//
//  PersonalExtensions.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/11.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

class PersonalExtensions
{
    static let shared = PersonalExtensions()
    
    
    
    func unfollowuser(currentUserid: String, usertounfollowId: String ,completion: @escaping() ->Void)
    {
        Services.shared.unfollowUser(currentuserid: currentUserid, usertoUnfollowId: usertounfollowId) { (Error, DataRefence) in
            if Error != nil
            {
                print("DEBUG: Error While unfollowing User: \(Error!.localizedDescription)")
                return
            }
            
            Database.database().reference().child("User-followers").child(usertounfollowId).child(currentUserid).removeValue { (Error, dataRef) in
                if Error != nil
                {
                    print("DEBUG: Error while unfollowing user: \(Error!.localizedDescription)")
                    return
                }
                print("DEBUG: You were removed has his followers")
                
            }
        }
    }
    
    func followUser(currentUserid: String, usertofollowId: String, completion: @escaping() ->Void)
    {
        Services.shared.userFollowing(usertofollow: usertofollowId, currentID: currentUserid) { (Error, DataRef) in
            if let error = Error
            {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            Database.database().reference().child("User-followers").child(usertofollowId).updateChildValues([currentUserid: 1]) { (Error, datareference) in
                if Error != nil
                {
                    print("DEBUG: Error \(Error!.localizedDescription)")
                    return
                }
                print("DEBUG: DONE!!!")
                
            }
        }
    }
    
    
}

class createCustomButton
{
    static let shared = createCustomButton()
    
    func createButton(buttonName Name: String) -> UIButton
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.clipsToBounds = true
        button.setImage(UIImage(named: Name), for: .normal)
        button.tintColor = .darkGray
        
        button.setDimensions(width: 25, height: 25)
        return button
    }
    
    
    
    func logoutWarnings(viewcontroller: UIViewController)
    {
        let alert  = UIAlertController(title: "Logout", message: "Would you like to Logout ?", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Logout", style: .destructive) { (action) in
            
            do
            {
                try Auth.auth().signOut()
                
                let controller = UINavigationController(rootViewController: LoginViewController())
                controller.modalPresentationStyle = .fullScreen
                viewcontroller.present(controller, animated: true, completion: nil)
            }catch let error
            {
                print("DEBUG:Error while signing User Out \(error.localizedDescription)")
            }
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { actionAlert in
            
        }
        alert.addAction(action)
        alert.addAction(action2)
        
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
}
