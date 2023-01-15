//
//  MainTabController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/15.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

enum ActionButtonConfiguration
{
    case Tweet
    case Message
}

class MainTabController: UITabBarController {
    
    
    private var buttonActionconfig: ActionButtonConfiguration =  .Tweet
   
    
    var user: User?
    {
        didSet
        {
            print("Did set main Tab")
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return}
        
            feed.user = self.user
        }
    }
    
    
    private let optionButton: UIButton =
    {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.widthAnchor.constraint(equalToConstant: 56).isActive = true
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(actionButtonHandler), for: .touchUpInside)
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .twitterBlue
        checkUseravailable()
    }
    
    //    PROFILE IMAGE
    
        
    
    //     MARK: - Selectors
      
    
    @objc func handleprofile()
    {
        print("DEBUG: PRIFILE")
    }
    
    @objc func actionButtonHandler()
    {
        let controller : UIViewController
        guard let currentuser = user else {return}
        switch buttonActionconfig
        {
        case .Tweet:
            
            controller = UploadTweetController(user: currentuser, config: .Tweet)
            
        case .Message:
            
            controller = SearchController(configuration: .message)
        }
        
    
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        
    }
    private func configureMainTabbarUI()
    {
        view.addSubview(optionButton)
        optionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 65, paddingRight: 15)
    }
    
    func configureTabbar()
    {
        let FeedViewController = templatenavigationController(image: UIImage(named: "home_unselected"), rootViewControoler: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
       
        let ExploreViewController = templatenavigationController(image: UIImage(named: "search_unselected"), rootViewControoler: SearchController(configuration: .Explore))
        let NotificationViewController = templatenavigationController(image: UIImage(named: "like_unselected"), rootViewControoler: NotificationController())
        let conversationViewController = templatenavigationController(image: UIImage(systemName: "envelope"), rootViewControoler: ConversationController())
        
        viewControllers = [FeedViewController,ExploreViewController,NotificationViewController,conversationViewController]
    }
    
    func templatenavigationController(image: UIImage?, rootViewControoler: UIViewController) -> UINavigationController
    {
        let navigation = UINavigationController(rootViewController: rootViewControoler)
        navigation.tabBarItem.image = image
        navigation.navigationBar.barTintColor = .white

        return navigation
    }
    
    //     MARK: - API
    
    
    func fetchCurrentUser()
    {
        Services.shared.FetchUser { [weak self] (User) in
            self?.user = User
        }
    }
    
    func checkUseravailable()
    {
        if Auth.auth().currentUser == nil
        {
            DispatchQueue.main.async {
                let controller = UINavigationController(rootViewController: LoginViewController())
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }else
        {
            print("DEBUG: USER SIGNED IN ")
            configureTabbar()
            configureMainTabbarUI()
            fetchCurrentUser()
        }
    }

//
    
}
extension MainTabController: UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = viewControllers?.firstIndex(of: viewController)
        {
            print("DEBUG: Index View Controllers: \(index)")
            let imageName = index == 3 ? #imageLiteral(resourceName: "mail") : #imageLiteral(resourceName: "new_tweet")
            self.optionButton.setImage(imageName, for: .normal)
            self.buttonActionconfig = index == 3 ? .Message : .Tweet
            print("DEBUG: Action Configuration \(self.buttonActionconfig)")
        }
    }
}
