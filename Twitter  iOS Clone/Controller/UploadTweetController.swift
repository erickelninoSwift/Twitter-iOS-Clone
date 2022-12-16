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
    
     private var configTweet:UploadTweetConfiguration
     private lazy var viewmodel = UploadTweetViewModel(config: configTweet)
    
    private lazy var actionButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlue
        button.titleLabel?.textAlignment = .center
        button.setTitle("Tweet", for: .normal)
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
    
    
    private let replyLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private var uploadTweetArea = ContainertextView()
    
    init(user: User, config: UploadTweetConfiguration) {
        self.Currentuser = user
        self.configTweet = config
        super.init(nibName: nil, bundle: nil)
        configureRetweetAction()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController()
        configigurationUITweet()
        setImageProfileView()
        switch configTweet
        {
        case .Tweet:
             self.title = "Tweet"
            print("DEBUG: TWEET CONTROLLER \(Currentuser.Username ?? "")")
             replyLabel.isHidden = viewmodel.shouldshowPreply
        case .Reply(let Tweet):
             self.title = "Retweet"
            print("DEBUG: REPLY to \(Tweet.caption)")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    
    
    
    
    func configureRetweetAction()
    {
        self.actionButton.setTitle(viewmodel.actionButtonTitle, for: .normal)
        self.replyLabel.text = "\(viewmodel.replytextto ?? "")"
        self.uploadTweetArea.placeHolder.text = viewmodel.placeholderText
        
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
        let imagestackview = UIStackView(arrangedSubviews: [userProfileImage,uploadTweetArea])
        imagestackview.translatesAutoresizingMaskIntoConstraints = false
        imagestackview.axis = .horizontal
        imagestackview.spacing = 12
        imagestackview.alignment = .leading
        
        let stack =  UIStackView(arrangedSubviews: [replyLabel,imagestackview])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        
//        view.addSubview(imagestackview)
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        imagestackview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
       
    }
    
    @objc func handlebackbutton()
    {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handletweet()
    {
        switch configTweet
        {
        case .Tweet:
            uploadTweetTofirebase()
        case .Reply(let Retweet):
            print("DEBUG: WE ARER SUPPOSED TO REPLY HERE WITH TWEET\(Retweet.caption)")
            uploadRetweet()
        }
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
    
    
    private func uploadRetweet()
    {
        print("DEBUG RETWEET")
    }
}
