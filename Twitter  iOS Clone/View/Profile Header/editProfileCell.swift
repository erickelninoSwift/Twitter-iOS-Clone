//
//  editProfileCell.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2023/01/09.
//  Copyright © 2023 Erick El nino. All rights reserved.
//

import UIKit

class editProfileCell: UITableViewCell
{
    
    let titlelabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "Text titlelable"
        return label
    }()
    
    lazy var infotextfield: UITextField =
        {
            let textfield = UITextField()
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.textColor = .twitterBlue
            textfield.borderStyle = .none
            textfield.textAlignment = .left
            
            return textfield
    }()
    

    lazy var bioInputView : InputTextView =
    {
        let textfield = InputTextView()
        textfield.placeHolder.font = UIFont.systemFont(ofSize: 14)
        textfield.placeHolder.textColor = .twitterBlue
        textfield.placeHolder.text = "Bio"
        return textfield
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        styleCell()
        cellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension editProfileCell
{
    private func styleCell()
    {
        
        print("DEBUG: CELL was Called !!!")
    }
    
    private func cellLayout()
    {
        contentView.addSubview(titlelabel)
        NSLayoutConstraint.activate([ titlelabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 1),
                                      titlelabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
