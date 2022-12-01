
//
//  ProfileFilterViewCell.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/28.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class ProfileFilterViewCell: UICollectionViewCell
{
    
    var titleLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    override var isSelected: Bool
        {
        didSet
        {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
