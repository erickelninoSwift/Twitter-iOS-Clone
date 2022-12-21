//
//  ActionSheetCell.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/20.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class ActionSheetCell: UITableViewCell
{
    
     //MARK: - Properties
    
    var actionSheetValue: ActionSheetOptions?
    {
        didSet
        {
            configureCell()
        }
    }
    
    private var ActionImage:UIImageView =
    {
        let myImage = UIImageView()
        myImage.translatesAutoresizingMaskIntoConstraints = false
        myImage.clipsToBounds = true
        myImage.contentMode = .scaleAspectFit
        myImage.image = #imageLiteral(resourceName: "TwitterLogo")
        myImage.setDimensions(width: 36, height: 36)
        return myImage
    }()
    
    
    private var titleLabel: UILabel =
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Unfollow @Joker"
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [ActionImage,titleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 15
        
        self.addSubview(stack)
        stack.centerY(inView: self)
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell()
    {
        print("DEBUG: CONFIGURE ACTIONSHEET CELL")
        guard let actionsheetTitle = actionSheetValue else {return }
        print("DEBUG: ACTIONSHEET \(actionsheetTitle)")
        titleLabel.text = actionsheetTitle.description
        
    }
    
}
