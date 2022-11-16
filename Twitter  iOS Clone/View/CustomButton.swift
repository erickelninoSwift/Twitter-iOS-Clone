//
//  CustomButton.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class CustomButton: UIButton
{
    init(text: String) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false

         self.backgroundColor = .white
         self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
         self.setTitle(text, for: .normal)
        self.setTitleColor(.twitterBlue, for: .normal)
         self.layer.cornerRadius = 5
         self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
