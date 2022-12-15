//
//  UploadTweetController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/21.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class UploadTweetController: UIViewController
{

    private var Currentuser: User
    
    private lazy var actionButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.setDimensions(width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        
        button.addTarget(self, action: #selector(handletweet), for: .touchUpInside)
        return button
    }()
    
    
    private let userProfileImage: UIImageView =
    {
        let profilepicture = UIImageView()
        profilepicture.translatesAutoresizingMaskIntoConstraints = false
        profilepicture.clipsToBounds = true
        profilepicture.contentMode = .scaleAspectFill
        profilepicture.setDimensions(width: 60, height: 60)
        profilepicture.layer.cornerRadius = 60 / 2
        profilepicture.backgroundColor = .twitterBlue
        
        return profilepicture
    }()
    
    
    private var uploadTweetArea: UITextView =
    {
        let textview = ContainertextView()
        
        return textview
    }()
    
    init(user: User) {
        self.Currentuser = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController()
        configigurationUITweet()
        setImageProfileView()
    }
    
    
    func configigurationUITweet()
    {
//        view.addSubview(userProfileImage)
//        userProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
//        userProfileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
       
        addTextView()
    }
    
    
    func setImageProfileView()
    {
        userProfileImage.sd_setImage(with: Currentuser.userProfileImageurl, completed: nil)
    }
    
    func navigationController()
    {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handlebackbutton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    
    func addTextView()
    {
        let stack = UIStackView(arrangedSubviews: [userProfileImage,uploadTweetArea])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .leading
        
        view.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
    
    @objc func handlebackbutton()
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handletweet()
    {
        uploadTweetTofirebase()
    }
//    Upload my tweet function
    
    private func uploadTweetTofirebase()
    {
        guard let tweetField  = uploadTweetArea.text else {return}
        
        TweetService.shared.uploadTweet(caption: tweetField) { (Error, databaserefe) in
            if let error = Error
            {
                print("DEBUG: There was an error while trying to save your tweet \(error.localizedDescription)")
                return
            }
           
            self.uploadTweetArea.text = ""
            self.dismiss(animated: true, completion: nil)
        }
    }
}
