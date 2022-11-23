//
//  ExploreController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/15.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import Firebase

class ExploreController: UIViewController
{
    
    var user: User?
    {
        didSet
        {
            print("DEBUG: Did set user in Explore")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIwithTitle(with: "Explore")
    }
}
