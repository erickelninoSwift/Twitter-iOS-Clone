//
//  LoginViewController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    
    
    private let logoImage: UIImageView =
    {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.clipsToBounds = true
        logo.layer.masksToBounds = true
        logo.contentMode = .scaleAspectFit
        logo.image = #imageLiteral(resourceName: "TwitterLogo")
        return logo
    }()
    
    
    private lazy var emailContainerView: UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let imageV = UIImageView()
        imageV.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        imageV.setDimensions(width: 25, height: 25)
        view.addSubview(imageV)
        imageV.centerY(inView: view)
        imageV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        
        return view
    }()
    
    
    private lazy var PasswordContainerView: UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let imageV = UIImageView()
        imageV.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        imageV.setDimensions(width: 25, height: 25)
        view.addSubview(imageV)
        imageV.centerY(inView: view)
        imageV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginUI()
        AddViewsToSubviews()
    }
    
    
    private func configureLoginUI()
    {
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        
    }
    
    private func AddViewsToSubviews()
    {
        view.addSubview(logoImage)
        logoImage.centerX(inView: self.view)
        logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        logoImage.setDimensions(width: 120, height: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,PasswordContainerView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 15).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        
        
    }
}
