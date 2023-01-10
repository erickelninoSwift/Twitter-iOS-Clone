//
//  UserProfileHeader.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2023/01/09.
//  Copyright © 2023 Erick El nino. All rights reserved.
//

import UIKit

protocol UserProfileHeaderDelegate: AnyObject
{
    func userDidtapChangePhoto()
}

class UserProfileHeader: UIView
{
    
    weak var delegate:UserProfileHeaderDelegate?
    
    private let user: User
    
     lazy var userProfileImage: UIImageView =
    {
        let profilepicture = UIImageView()
        profilepicture.translatesAutoresizingMaskIntoConstraints = false
        profilepicture.clipsToBounds = true
        profilepicture.contentMode = .scaleAspectFill
        profilepicture.setDimensions(width: 120, height: 120)
        profilepicture.layer.cornerRadius = 120 / 2
        profilepicture.backgroundColor = .lightGray
        profilepicture.layer.borderWidth = 2.5
        profilepicture.layer.borderColor = UIColor.white.cgColor
        
        
        return profilepicture
    }()
    
     lazy var changePhotobutton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Profile Photo", for: [])
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleChangePhotoprofile), for: .primaryActionTriggered)
        return button
    }()
    
    
    
    init(user: User)
    {
        self.user = user
        
        super.init(frame: .zero)
        layoutconfiguration()
        style()
        layout()
        configureHeader()
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UserProfileHeader
{
    private func style()
    {
        self.backgroundColor = .twitterBlue
    }
    
    
    private func layout()
    {
        
    }
    
    @objc func handleChangePhotoprofile()
    {
        delegate?.userDidtapChangePhoto()
    }
}

extension UserProfileHeader
{
    private func layoutconfiguration()
    {
        self.addSubview(userProfileImage)
        userProfileImage.centerX(inView: self)
        NSLayoutConstraint.activate([userProfileImage.topAnchor.constraint(equalToSystemSpacingBelow: self.safeAreaLayoutGuide.topAnchor, multiplier: 2),
                                     
        ])
        self.addSubview(changePhotobutton)
        changePhotobutton.centerX(inView: userProfileImage)
        NSLayoutConstraint.activate([ changePhotobutton.topAnchor.constraint(equalToSystemSpacingBelow: userProfileImage.bottomAnchor, multiplier: 1),
                                      changePhotobutton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 4),
                                      self.trailingAnchor.constraint(equalToSystemSpacingAfter: changePhotobutton.trailingAnchor, multiplier: 4)
        
        ])
        
    }
    
    
    private func configureHeader()
    {
        userProfileImage.sd_setImage(with: user.userProfileImageurl, completed: nil)
    }
}
