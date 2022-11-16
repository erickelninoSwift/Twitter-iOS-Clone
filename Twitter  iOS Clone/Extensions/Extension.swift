//
//  Extension.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

extension UIViewController
{
    func configureUI()
    {
        view.backgroundColor = .white
        
        let imagelogo = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imagelogo.contentMode = .scaleAspectFit
        navigationItem.titleView = imagelogo
    }
    
    func configureUIwithTitle(with title: String)
    {
        view.backgroundColor = .white
        navigationItem.title = title
    }
}
