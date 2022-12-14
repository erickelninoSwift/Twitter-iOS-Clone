//
//  CustomUILabel.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/24.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit
import ActiveLabel

class CustomUILabel: ActiveLabel
{
    override init(frame:CGRect) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.mentionColor = .twitterBlue
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
