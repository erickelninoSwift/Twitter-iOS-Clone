//
//  FooterCustomButton.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class FooterCustomButton: UIButton
{
    init(text1: String , text2: String) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let attributed = NSAttributedString(string: text2, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),.foregroundColor:UIColor.white])
        let mutableString = NSMutableAttributedString(string: text1, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular),.foregroundColor:UIColor.white])
        mutableString.append(attributed)
        self.setAttributedTitle(mutableString, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
