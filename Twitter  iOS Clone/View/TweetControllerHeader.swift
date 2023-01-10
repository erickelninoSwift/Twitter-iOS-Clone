//
//  TweetControllerHeader.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/14.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

protocol TweeterHeaderDelegate: AnyObject
{
    func actionsheetPressed()
    
}


class TweetControllerHeader: UICollectionReusableView
{
    // MARK: - properties
    
    var userSelcted: User?
    {
        didSet
        {
            configureUserHeaderData()

        }
    }
    
    var tweets: Tweets?
    {
        didSet
        {
            configureUserHeaderData()
            
        }
    }
    
     weak var delegate: TweeterHeaderDelegate?
    
    private lazy var replyingTo: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
       
        
        return label
    }()
    
    private lazy var actionsheetButton: UIButton =
    {
        let button =  UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.clipsToBounds = true
        button.setImage(UIImage(systemName: "ellipsis")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.tintColor = .twitterBlue
        button.addTarget(self, action: #selector(handleactionSheet), for: .touchUpInside)
        return button
        
    }()
    private lazy var userProfileImage: UIImageView =
    {
        let profilepicture = UIImageView()
        profilepicture.translatesAutoresizingMaskIntoConstraints = false
        profilepicture.clipsToBounds = true
        profilepicture.contentMode = .scaleAspectFill
        profilepicture.setDimensions(width: 80, height: 80)
        profilepicture.layer.cornerRadius = 80 / 2
        profilepicture.backgroundColor = .lightGray
        profilepicture.layer.borderWidth = 3
        profilepicture.layer.borderColor = UIColor.white.cgColor
        
        
        return profilepicture
    }()
    
    
    private lazy var fullname: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Eriik Elnino"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    private lazy var Username: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@Jackpot"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    
    
    private lazy var TimeandDate: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
       
        label.numberOfLines = 0
        return label
    }()
    
    
    private lazy var currentTweet: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    private lazy var retweetLabel: UILabel =
       {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .lightGray
           label.font = UIFont.systemFont(ofSize: 16)
          
           let tap = UITapGestureRecognizer(target: self, action: #selector(HandleRetweet))
           label.addGestureRecognizer(tap)
           label.isUserInteractionEnabled = true
           
           return label
       }()
       
       private  lazy var likesLabel: UILabel =
       {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .lightGray
           label.font = UIFont.systemFont(ofSize: 16)
          
           let tap = UITapGestureRecognizer(target: self, action: #selector(handlelikes))
           label.addGestureRecognizer(tap)
           label.isUserInteractionEnabled = true
           return label
       }()
    
    
    private lazy var statsView : UIView =
    {
        let view = StatisticsView(lieksLable: self.likesLabel, RetweetsLabel: self.retweetLabel)
        return view
    }()
    
    
    private lazy var commentButton : UIButton =
    {
        let button = createButton(ImageName: "comment")
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton : UIButton =
    {
        let button = createButton(ImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweet), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton : UIButton =
    {
        let button = createButton(ImageName: "like")
        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton : UIButton =
    {
        let button = createButton(ImageName: "share")
        button.addTarget(self, action: #selector(handleshareButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCylce
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHeader()
//        self.addSubview(userProfileImage)
//        userProfileImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
//        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [fullname,Username])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 3
        
        
        let erickStack = UIStackView(arrangedSubviews: [userProfileImage,stack])
        erickStack.translatesAutoresizingMaskIntoConstraints = false
        erickStack.axis = .horizontal
        erickStack.alignment = .center
        erickStack.spacing = 10
        erickStack.distribution = .fillProportionally
        
        
        let replytostack = UIStackView(arrangedSubviews: [replyingTo,erickStack])
        replytostack.translatesAutoresizingMaskIntoConstraints = false
        replytostack.axis = .vertical
        replytostack.spacing = 3
        
        
        
        self.addSubview(replytostack)
        
        replytostack.topAnchor.constraint(equalToSystemSpacingBelow: self.safeAreaLayoutGuide.topAnchor, multiplier: 1).isActive = true
        replytostack.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2).isActive = true
        self.trailingAnchor.constraint(equalToSystemSpacingAfter: replytostack.trailingAnchor, multiplier: 2).isActive = true
        
        
        self.addSubview(currentTweet)
        currentTweet.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        currentTweet.topAnchor.constraint(equalTo: erickStack.bottomAnchor, constant: 10).isActive = true
        currentTweet.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        
        self.addSubview(TimeandDate)
        TimeandDate.topAnchor.constraint(equalTo: currentTweet.bottomAnchor, constant: 10).isActive = true
        TimeandDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        
        self.addSubview(actionsheetButton)
    
        actionsheetButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        actionsheetButton.centerY(inView: stack)
        
        self.addSubview(statsView)
        statsView.topAnchor.constraint(equalTo: TimeandDate.bottomAnchor, constant:10).isActive = true
        statsView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5).isActive = true
        statsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        let stackaction = UIStackView(arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        stackaction.translatesAutoresizingMaskIntoConstraints = false
        stackaction.axis = .horizontal
        stackaction.spacing = 10
        stackaction.distribution = .fillEqually
        
        self.addSubview(stackaction)
        stackaction.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        stackaction.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        stackaction.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        
    }
    
    
    func configureHeader()
    {
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUserHeaderData()
    {
        guard let userSet = userSelcted  else {return}
        guard let tweet = tweets else {return}
         let viewmodel = TweetViewModel(tweet: tweet)
        userProfileImage.sd_setImage(with: viewmodel.ProfileURlImage, completed: nil)
        fullname.text = viewmodel.fullname
        Username.text = viewmodel.username
        currentTweet.text = viewmodel.captionuser
        TimeandDate.text = "\(viewmodel.headerTimeStamp)"
        retweetLabel.attributedText = viewmodel.retweetsNSAttributedString
        likesLabel.attributedText = viewmodel.likesAttributedString
        
        likeButton.setImage(viewmodel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewmodel.likeButtonColor
        
        self.replyingTo.isHidden = viewmodel.shouldHideReplyLabel
        self.replyingTo.text = viewmodel.replyLabelText
        
    }
    
    @objc func handleViewfollowing()
    {
        print("DEBUG: FOLLOWIGN: ")
    }
    
    @objc func HandleRetweet()
    {
        print("DEBUG: RETWEETS")
    }
    
    @objc func handlelikes()
    {
        print("DEBUG: handle LIKES")
    }
    
    @objc func handleactionSheet()
    {
        delegate?.actionsheetPressed()
    }
    
    
    @objc func handleComment()
    {
        print("DEBUG: HANDLE COMMENT")
    }
    
    @objc func handleRetweet()
    {
        print("DEBUG: HANDLE RETWEET")
    }
    
    @objc func handleLikeButton()
    {
        print("DEBUG: HANDLE LIKE")
    }
    
    @objc func handleshareButton()
    {
        print("DEBUG: HANDLE SHARE")
    }
    
    fileprivate func createButton(ImageName: String) -> UIButton
    {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: ImageName), for: .normal)
        button.imageView?.clipsToBounds = true
        button.tintColor = .darkGray
        button.setDimensions(width: 25, height: 25)
        
        return button
    }
}


