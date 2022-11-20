//
//  MainTabController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/15.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

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
        button.addTarget(self, action: #selector(actionButtonHandler), for: .touchUpInside)
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
        checkUseravailable()
//        signUserOut()
    }
    
    
//     MARK: - Selectors
    
    @objc func actionButtonHandler()
    {
        print("DEBUG : 123")
    }
    private func configureMainTabbarUI()
    {
        
        let profileImageview = UIImageView()
        profileImageview.backgroundColor = .twitterBlue
        profileImageview.contentMode = .scaleAspectFit
        profileImageview.setDimensions(width: 32, height: 32)
        profileImageview.layer.cornerRadius = 32 / 2
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageview)
        
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
    
    
//     MARK: - API
    
    
    func fetchCurrentUser()
    {
        Services.shared.FetchUser { (User) in
            print("DEBUG: We passed data that exist \(User.useremail ?? "")")
        }
    }
    
    func checkUseravailable()
    {
        if Auth.auth().currentUser == nil
        {
            print("DEBUG: USER NOT SIGNED IN ")
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
     
    
    func signUserOut()
    {
        do
        {
            try Auth.auth().signOut()
            print("DEBUG: USER LOGGED OUT")
            
        }catch let error
        {
            print("DEBUG:Error while signing User Out \(error.localizedDescription)")
        }
    }

}
