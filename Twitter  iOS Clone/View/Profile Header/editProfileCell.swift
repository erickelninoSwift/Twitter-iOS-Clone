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
     var viewmodel: editProfileViewModel?
        {
        didSet
        {
            configure()
        }
    }
    
    let titlelabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
       
        return label
    }()
    
    lazy var infotextfield: UITextField =
        {
            let textfield = UITextField()
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.textColor = .twitterBlue
            textfield.borderStyle = .none
            textfield.textAlignment = .left
            textfield.text = "Test User shiiit"
            return textfield
    }()
    
    
    lazy var bioInputView : InputTextView =
        {
            let textfield = InputTextView()
            textfield.placeHolder.font = UIFont.systemFont(ofSize: 14)
            textfield.placeHolder.textColor = .twitterBlue
            textfield.placeHolder.text = "Bio"
            textfield.font = UIFont.systemFont(ofSize: 14)
            textfield.textColor = .twitterBlue
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
                                      titlelabel.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 1),
                                      titlelabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        contentView.addSubview(infotextfield)
        NSLayoutConstraint.activate([infotextfield.centerYAnchor.constraint(equalTo: titlelabel.centerYAnchor),
                                     infotextfield.leadingAnchor.constraint(equalToSystemSpacingAfter: titlelabel.trailingAnchor, multiplier: 2),
                                     self.trailingAnchor.constraint(equalToSystemSpacingAfter: infotextfield.trailingAnchor, multiplier: 3)
            
        ])
        
        contentView.addSubview(bioInputView)
        NSLayoutConstraint.activate([bioInputView.centerYAnchor.constraint(equalTo: titlelabel.centerYAnchor),
                                     bioInputView.leadingAnchor.constraint(equalToSystemSpacingAfter: titlelabel.trailingAnchor, multiplier: 2),
                                     self.trailingAnchor.constraint(equalToSystemSpacingAfter: bioInputView.trailingAnchor, multiplier: 3)
        ])
    }
    
    
    private func configure()
    {
        guard let currentviewmodel = viewmodel else {return}
        
        infotextfield.isHidden = currentviewmodel.shouldhidetextfield
        bioInputView.isHidden = currentviewmodel.shouldhideTextview
        
        titlelabel.text = currentviewmodel.titleText
        infotextfield.text = currentviewmodel.optionValue
        bioInputView.text = currentviewmodel.optionValue
        
    }
}
