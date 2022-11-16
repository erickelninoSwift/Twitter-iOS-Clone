//
//  MainTabController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/15.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    
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
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
        configureMainTabbarUI()
    }
    
    
    
    
    private func configureMainTabbarUI()
    {
        view.addSubview(optionButton)
        optionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 65, paddingRight: 15)
    }
    
    func configureTabbar()
    {
        let FeedViewController = templatenavigationController(image: UIImage(named: "home_unselected"), rootViewControoler: FeedController())
        let ExploreViewController = templatenavigationController(image: UIImage(named: "search_unselected"), rootViewControoler: ExploreController())
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

}
