//
//  LoginViewController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

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
    
    
    private let loginButton: UIButton =
    {
        let button = CustomButton(text: "Log In")
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    private let RegistrationButton: UIButton =
    {
        let button = FooterCustomButton(text1: "Don't have an account? ", text2: "Sign Up")
        button.addTarget(self, action: #selector(handleRegisteration), for: .touchUpInside)
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
        view.addSubview(logoImage)
        logoImage.centerX(inView: self.view)
        logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        logoImage.setDimensions(width: 120, height: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,PasswordContainerView,loginButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 15).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        
        view.addSubview(RegistrationButton)
        RegistrationButton.centerX(inView: self.view)
        RegistrationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true 
        
        
    }
    
    @objc func handleRegisteration()
    {
        print("DEBUG: REGISTERATION")
        
        let controller = RegistrationController()
        controller.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc func handleLogin()
    {
        guard let email = emailTetxfield.text else { return}
        guard let password = emailTetxfield.text else { return}
        
        let Logincredentilas = LoginDetails(useremail: email, userPassword: password)
        APICaller.shared.SignInUser(currentUser: Logincredentilas) { (Results, Error) in
            if Error != nil
            {
                print("DEBUG: There was an Error while signin In \(Error!.localizedDescription)")
                return
            }
            
            guard let window  = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabController else {return}
            tab.checkUseravailable()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
