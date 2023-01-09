//
//  ProfileViewHeader.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/27.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

protocol profileGeaderViewDelegate: AnyObject
{
    func dismissController()
    func followandunfollow(profilfheader: ProfileViewHeader , myuser: User)
    func FilterSelected(filterSelected: ProfileFliterCaseOption, user: User)
}

class ProfileViewHeader: UICollectionReusableView
{
    
    
    weak var delegate: profileGeaderViewDelegate?
    
    
    var activateFollowButton: NSLayoutConstraint!
    
    var myerickUser:User?
    {
        didSet
        {
            
        }
    }
    
    var erickTweets: TweetViewModel?
    {
        didSet
        {
            fetchCurrentUserStats()
            configureFollowers()
            chechuserexist()
        }
    }
    
    
    lazy var backButton: UIButton =
        {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
            button.imageView?.clipsToBounds = true
            button.tintColor = .white
            button.addTarget(self, action: #selector(handledismissbutton), for: .touchUpInside)
            return button
    }()
    
    private lazy var containerView: UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        view.setDimensions(width: self.frame.width, height: 100)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        return view
    }()
    
    private lazy var userProfileImage: UIImageView =
    {
        let profilepicture = UIImageView()
        profilepicture.translatesAutoresizingMaskIntoConstraints = false
        profilepicture.clipsToBounds = true
        profilepicture.contentMode = .scaleAspectFill
        profilepicture.setDimensions(width: 100, height: 100)
        profilepicture.layer.cornerRadius = 100 / 2
        profilepicture.backgroundColor = .lightGray
        profilepicture.layer.borderWidth = 3.0
        profilepicture.layer.borderColor = UIColor.white.cgColor
        
        
        return profilepicture
    }()
    
    lazy var addFloowbutton: UIButton =
        {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setDimensions(width: 120, height: 40)
            button.layer.cornerRadius = 40 / 2
            button.setTitleColor(.twitterBlue, for: .normal)
            button.backgroundColor = .white
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.twitterBlue.cgColor
            button.addTarget(self, action: #selector(handlefollowuser), for: .touchUpInside)
            return button
    }()
    
    private lazy var fullname: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
      
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    private lazy var Username: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var BioLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Jackpot startegy will come with a bot next year plus singals,This is how we do business"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var followinglabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewfollowing))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var followerabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewfollowers))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    
    private lazy var profilfilter: UIView =
    {
        let view = ProfileFilterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        fetchCurrentUserStats()
//        configureFollowers()
//        chechuserexist()
        self.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(userProfileImage)
        userProfileImage.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        userProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        self.addSubview(addFloowbutton)
        addFloowbutton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        addFloowbutton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 30).isActive = true
        setupStackview()
    }
    
    //    Stack view for username bio
    
    func setupStackview()
    {
        let userinformationStack = UIStackView(arrangedSubviews: [Username,fullname,BioLabel])
        userinformationStack.translatesAutoresizingMaskIntoConstraints =  false
        userinformationStack.spacing = 4
        userinformationStack.axis = .vertical
        userinformationStack.distribution = .fillProportionally
        
        self.addSubview(userinformationStack)
        userinformationStack.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 10).isActive = true
        userinformationStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        userinformationStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [followinglabel,followerabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        
        self.addSubview(stack)
        stack.topAnchor.constraint(equalTo: userinformationStack.bottomAnchor, constant: 5).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        
        self.addSubview(profilfilter)
        profilfilter.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 5).isActive = true
        profilfilter.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        profilfilter.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        profilfilter.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        
    }
    
    //     MARK: - User initialized
    
    
    func configureFollowers()
    {
        guard let currentUser = myerickUser else {return}
        let viewmodel = ProfileheaderViewModel(user: currentUser)
       
        followerabel.attributedText = viewmodel.userFollowers
        followinglabel.attributedText = viewmodel.userFollowing
        fullname.text = currentUser.userfullname
        Username.text = currentUser.Username
        userProfileImage.sd_setImage(with: currentUser.userProfileImageurl, completed: nil)
        addFloowbutton.setTitle(viewmodel.actionButton, for: .normal)
    }
    
    func chechuserexist()
    {
        guard var erick = myerickUser else {return}
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let usertoFollowID = erick.user_id else {return}
        
        if currentUserId != usertoFollowID
        {
            Services.shared.checkifuserFollowed(userid: usertoFollowID, currentUserID: currentUserId) { isfollowed in
                erick.isUserFollowed = isfollowed
            }
        }
    }
    
    
    func fetchCurrentUserStats()
      {
        guard let currentuser = myerickUser?.user_id else {return}
          Services.shared.fetchUserStats(userId: currentuser) { (userstats) in
              
            self.myerickUser?.userStats = userstats
          }
      }
    
    
    
    @objc func handleViewfollowing()
    {
        print("DEBUG: View Following")
    }
    
    @objc func handleViewfollowers()
    {
        print("DEBUG: View Followers")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handledismissbutton()
    {
        print("DEBUG: DIMISS BUTTON PRESSED")
        delegate?.dismissController()
    }
    
    @objc func handlefollowuser(button: UIButton)
    {
        guard let user = myerickUser else {return}
        delegate?.followandunfollow(profilfheader: self, myuser: user)
      
    }
    
    
    
}

extension ProfileViewHeader: profileViewFilterDelegate
{
    func didSelectFileter(Filter: ProfileFliterCaseOption) {
        
        guard let currentuser = myerickUser else {return}
        delegate?.FilterSelected(filterSelected: Filter, user: currentuser)
    }
    
    func ProfileviewCellSelected(currentView: ProfileFilterView, ViewSelctedIndexPath: IndexPath) {
        guard let cell = currentView.myCollectionView.cellForItem(at: ViewSelctedIndexPath) as? ProfileFilterViewCell
            else {return}

        let xPosition = cell.frame.origin.x
        
        UIView.animate(withDuration: 0.3) {
            currentView.underlineView.frame.origin.x = xPosition
        }
    }
}


extension ProfileViewHeader
{
    
}
