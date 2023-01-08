//
//  TweetCell.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/24.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

protocol TweetCellDelagate: AnyObject
{
    func celltappedAction(currentCollectionCell:TweetCell)
    func replyButtonPressed(with cell: TweetCell)
    func didLikeTweet(Tweetcell: TweetCell)
}

class TweetCell: UICollectionViewCell
{
    
    
    
    var AllmyTweet: TweetViewModel?
    {
        didSet
        {
            configure()
            
            
        }
    }
    
    var Tweet: Tweets?
    
    
    weak var delelgate:TweetCellDelagate?
    
    
    private lazy var userProfileImage: UIImageView =
    {
        let profilepicture = UIImageView()
        profilepicture.translatesAutoresizingMaskIntoConstraints = false
        profilepicture.clipsToBounds = true
        profilepicture.layer.masksToBounds = true 
        profilepicture.contentMode = .scaleAspectFill
        profilepicture.setDimensions(width: 60, height: 60)
        profilepicture.layer.cornerRadius = 60 / 2
        profilepicture.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileimageTapped))
        profilepicture.addGestureRecognizer(tap)
        profilepicture.isUserInteractionEnabled = true
        
        return profilepicture
    }()
    
    private let replyTo: UILabel =
    {
        let label  = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.text = "→ Replying to @Eriik"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    
    private let captionLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let username: UILabel =
    {
        let label = CustomUILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    private lazy var commentButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.clipsToBounds = true
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handlecomment), for: .touchUpInside)
        button.setDimensions(width: 25, height: 25)
        return button
    }()
    
    private lazy var retweet: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.clipsToBounds = true
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleretweet), for: .touchUpInside)
        button.setDimensions(width: 25, height: 25)
        return button
    }()
    
    
    private lazy var likebutton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.clipsToBounds = true
        button.tintColor = .darkGray
        button.setDimensions(width: 25, height: 25)
        
        
        button.addTarget(self, action: #selector(handlelikes), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var sharebutton: UIButton =
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "share"), for: .normal)
        button.imageView?.clipsToBounds = true
        button.tintColor = .darkGray
        button.setDimensions(width: 25, height: 25)
        button.addTarget(self, action: #selector(handleshare), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    
    static let cellIdentifier = "MyCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        //        self.addSubview(userProfileImage)
        //        userProfileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        //        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [username,captionLabel])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.distribution = .fillProportionally
        
        let imageStack = UIStackView(arrangedSubviews: [userProfileImage,stack])
        imageStack.translatesAutoresizingMaskIntoConstraints = false
        imageStack.axis = .horizontal
        imageStack.spacing = 10
        
        
        
        self.addSubview(imageStack)
        
        imageStack.topAnchor.constraint(equalToSystemSpacingBelow: self.safeAreaLayoutGuide.topAnchor, multiplier: 2).isActive = true
        imageStack.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2).isActive = true
        self.trailingAnchor.constraint(equalToSystemSpacingAfter: imageStack.trailingAnchor, multiplier: 2).isActive = true
        
        
        let stackAction = UIStackView(arrangedSubviews: [commentButton,retweet,likebutton,sharebutton])
        stackAction.translatesAutoresizingMaskIntoConstraints = false
        stackAction.axis = .horizontal
        stackAction.spacing = 10
        stackAction.distribution = .fillEqually
        
        self.addSubview(stackAction)
        stackAction.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        stackAction.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackAction.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .systemGroupedBackground
        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.addSubview(underlineView)
        underlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        underlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        underlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleshare()
    {
        print("DEBUG: SHARE")
    }
    
    @objc func handlelikes()
    {
        delelgate?.didLikeTweet(Tweetcell: self)
    }
    
    @objc func handlecomment()
    {
        print("DEBUG: COMMENT HANDLED")
        delelgate?.replyButtonPressed(with: self)
    }
    
    @objc func handleretweet()
    {
        print("DEBUG : RETWEET BUTTON PRESSED")
    }
    
    func configure()
    {
        guard let oneTweet = AllmyTweet else {return}
        userProfileImage.sd_setImage(with: oneTweet.ProfileURlImage, completed: nil)
        captionLabel.text = oneTweet.captionuser
        username.attributedText = oneTweet.userInfor
        
        likebutton.setImage(oneTweet.likeButtonImage, for: .normal)
        likebutton.tintColor = oneTweet.likeButtonColor
        
    }
    
    @objc func handleProfileimageTapped()
    {
        delelgate?.celltappedAction(currentCollectionCell: self)
    }
    
    
}
