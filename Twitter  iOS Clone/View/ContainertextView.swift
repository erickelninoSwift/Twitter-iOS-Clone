//
//  ContainertextView.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/23.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class ContainertextView: UITextView
{
//    Properties
    
    var placeHolder: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "What's happening? "
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(placeHolder)
        self.font = UIFont.systemFont(ofSize: 16)
        self.isScrollEnabled = false
        self.heightAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        
        self.textColor = .darkGray
        self.backgroundColor = .white
        placeHolder.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        placeHolder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlechange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    @objc func handlechange()
    {
        placeHolder.isHidden = !text.isEmpty
    }
}
