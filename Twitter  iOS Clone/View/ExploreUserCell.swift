//
//  ExploreUserCell.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/08.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase


class ExploreUserCell: UITableViewCell
{
    
    
    var selectedUserDrtails: User?
    {
        didSet
        {
            configureation()
        }
    }
    
     private lazy var userProfileImage: UIImageView =
      {
          let profilepicture = UIImageView()
          profilepicture.clipsToBounds = true
          profilepicture.contentMode = .scaleAspectFit
          profilepicture.setDimensions(width: 40, height: 40)
          profilepicture.layer.cornerRadius = 40 / 2
          profilepicture.backgroundColor = .twitterBlue
    
          return profilepicture
      }()
    
    
    
    private lazy var username: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Username"
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var fullname: UILabel =
       {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.font = UIFont.systemFont(ofSize: 14)
        label.text = "FullName"
           label.textColor = .lightGray
           return label
     }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        
        self.addSubview(userProfileImage)
        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        userProfileImage.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [username,fullname])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stack)
        stack.centerY(inView: self)
        stack.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureation()
    {
        guard let myUser = selectedUserDrtails else {return}
        guard let Usernameselected = myUser.Username  else {return}
        guard let fullnameSelected = myUser.userfullname else {return}
        
        username.text = Usernameselected
        fullname.text = fullnameSelected
        userProfileImage.sd_setImage(with: myUser.userProfileImageurl, completed: nil)
        
    }
    
}
