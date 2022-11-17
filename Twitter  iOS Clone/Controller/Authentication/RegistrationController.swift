//
//  RegistrationController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase


class RegistrationController: UIViewController
{
    
    
    private let imagePicker = UIImagePickerController()
    private var ProfilePicImage: UIImage?
    
    private let AddPhotoButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        imagePicker.delegate  = self
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
        AddPhotoButton.setDimensions(width: 200, height: 200)
        
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
        guard let email = emailTetxfield.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullnametextfield.text else {return}
        guard let username = UsernameTextfield.text else {return}
        guard let myProfilepicImage = ProfilePicImage else {
            print("DEBUG: Please Select and Image")
            return
            
        }
        
        guard let imageData = myProfilepicImage.jpegData(compressionQuality: 0.2) else {return}
        let ImageDataName = NSUUID().uuidString
        
        let userToregister = Userdetails(email: email, password: password, fullname: fullname, username: username, myProfilepicImage: myProfilepicImage, myImageDataName: ImageDataName, MyImagedata: imageData)
        
        APICaller.shared.registerUser(CurrentUserdetails: userToregister) { (Error, reference) in
            if let error  = Error
            {
                print("DEBUG: There was an error while updating your database \(error.localizedDescription)")
                
                return
            }
            
            print("DEBUG: data was saved successfully")
            print("Waiting to go to another ViewControoler")
        }
        
    }
    
    @objc func handlepickImage()
    {
        print("DEBUG: PICK IMAGE")
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}
// MARK: - IMAGE PICKER FUNCTIONS

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        
        self.ProfilePicImage = profileImage
        
        self.AddPhotoButton.layer.cornerRadius = 200 / 2
        self.AddPhotoButton.layer.masksToBounds = true
        self.AddPhotoButton.layer.borderWidth = 2
        self.AddPhotoButton.imageView?.contentMode = .scaleAspectFill
        self.AddPhotoButton.imageView?.clipsToBounds = true 
        self.AddPhotoButton.layer.borderColor = UIColor.white.cgColor
        self.AddPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}

