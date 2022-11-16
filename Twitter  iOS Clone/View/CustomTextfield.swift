//
//  CustomTextfield.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class CustomTextfield: UITextField
{
    init(placeholder: String) {
        super.init(frame: .zero)
        let attributedString = NSAttributedString(string: placeholder, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular),.foregroundColor: UIColor.white])
        self.attributedPlaceholder = attributedString
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
