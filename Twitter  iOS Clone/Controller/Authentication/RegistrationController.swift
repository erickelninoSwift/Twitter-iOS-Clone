//
//  RegistrationController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController
{
    
    
    private let AddPhotoButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 150 / 2
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(handlepickImage), for: .touchUpInside)
        return button
    }()
    
    private let emailTetxfield : UITextField =
    {
        let textfield = CustomTextfield(placeholder: "Email")
        return textfield
    }()
    
    private let passwordTextField : UITextField =
    {
        let textfield = CustomTextfield(placeholder: "Password")
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    private let fullnametextfield : UITextField =
    {
        let textfield = CustomTextfield(placeholder: "Fullname")
        return textfield
    }()
    
    private let UsernameTextfield : UITextField =
    {
        let textfield = CustomTextfield(placeholder: "Username")
        return textfield
    }()
    
    private lazy var emailContainerView: UIView =
    {
        let view = ContainerView().inputContainerView(with: UIImage(named: "ic_mail_outline_white_2x-1") ?? UIImage(), textfield: emailTetxfield)
        return view
    }()
    
    
    private lazy var PasswordContainerView: UIView =
    {
        let view = ContainerView().inputContainerView(with: UIImage(named: "ic_lock_outline_white_2x") ?? UIImage(), textfield: passwordTextField)
        
        return view
    }()
    
    private lazy var fullnameContainerView: UIView =
    {
        let view = ContainerView().inputContainerView(with: UIImage(named: "ic_person_outline_white_2x") ?? UIImage(), textfield: fullnametextfield )
        return view
    }()
    
    private lazy var usernameContainerView: UIView =
    {
        let view = ContainerView().inputContainerView(with: UIImage(named: "ic_person_outline_white_2x") ?? UIImage(), textfield: UsernameTextfield)
        return view
    }()
    
    
    private let registrationbutton: UIButton =
    {
        let button = CustomButton(text: "Sign Up")
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    
    private let BacktoLoginButton: UIButton =
    {
        let button = FooterCustomButton(text1: "Already have an account? ", text2: "Log in")
        button.addTarget(self, action: #selector(handleLoginController), for: .touchUpInside)
        return button
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
        view.addSubview(AddPhotoButton)
        AddPhotoButton.centerX(inView: self.view)
        AddPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        AddPhotoButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,PasswordContainerView,fullnameContainerView,usernameContainerView,registrationbutton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: AddPhotoButton.bottomAnchor, constant: 15).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        
        view.addSubview(BacktoLoginButton)
        BacktoLoginButton.centerX(inView: self.view)
        BacktoLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        
    }
    
    @objc func handleLoginController()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleRegistration()
    {
        print("DEBUG: REGISTRATION")
    }
    
    @objc func handlepickImage()
    {
        print("DEBUG: PICK IMAGE")
    }
}

