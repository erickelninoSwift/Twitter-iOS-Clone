//
//  EditprofileFooterView.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2023/01/13.
//  Copyright © 2023 Erick El nino. All rights reserved.
//

import UIKit

protocol EditprofileFooterViewDelegate: AnyObject
{
    func logoutButtonPressed()
}

class EditprofileFooterView: UIView
{
    // MARK: - properties
    
    weak var delegate:EditprofileFooterViewDelegate?
    
    private lazy var logoutButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        button.backgroundColor = .twitterBlue
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(logoutButton)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.layer.cornerRadius = 20
        logoutButton.centerX(inView: self)
        logoutButton.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 2).isActive = true
        logoutButton.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2).isActive = true
        self.trailingAnchor.constraint(equalToSystemSpacingAfter: logoutButton.trailingAnchor, multiplier: 2).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditprofileFooterView
{
    @objc func handleLogOut()
    {
        delegate?.logoutButtonPressed()
    }
}
