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
import ActiveLabel


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
    
    
    private let replyLabel: ActiveLabel =
    {
        let label = ActiveLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.mentionColor = .twitterBlue
        
        return label
    }()
    
    private var uploadTweetArea = InputTextView()
    
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
        handleMentionTap()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController()
        configigurationUITweet()
        setImageProfileView()
        
    }
    
    
    func configigurationUITweet()
    {
        addTextView()
    }
    
    
    
    func handleMentionTap()
    {
        replyLabel.handleMentionTap { elnino in
           print("DEBUG: Mention user is : \(elnino)")
        }
    }
    
    
    func configureRetweetAction()
    {
        self.actionButton.setTitle(viewmodel.actionButtonTitle, for: .normal)
        self.replyLabel.text = "\(viewmodel.replytextto ?? "")"
        self.replyLabel.attributedText = viewmodel.attributedStringplaceholder
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
        stack.alignment = .fill
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
            
            NotificationServices.shared.uploadNotification(notificationType: .reply, tweet: Retweet)
            uploadTweetTofirebase()
        }
    }
    
    private func uploadTweetTofirebase()
    {
        guard let tweetField  = uploadTweetArea.text else {return}
        
        TweetService.shared.uploadTweet(caption: tweetField, config: self.configTweet)
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
