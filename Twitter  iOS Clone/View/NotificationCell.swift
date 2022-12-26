//
//  NotificationCell.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/25.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

protocol NotificationcellDelegate: AnyObject
{
    func userPressedCell(cell: NotificationCell)
}

class NotificationCell: UITableViewCell
{
    
    
    var notification: NotificationModel?
    {
        didSet
        {
            configureationCell()
        }
    }
    
    static let NotificationCellID = "notificationCell"
    
    var delegate: NotificationcellDelegate?
    
    private lazy var userProfileImage: UIImageView =
    {
        let profilepicture = UIImageView()
        profilepicture.clipsToBounds = true
        profilepicture.contentMode = .scaleAspectFit
        profilepicture.setDimensions(width: 50, height: 50)
        profilepicture.layer.cornerRadius = 50 / 2
        profilepicture.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileimageTapped))
        profilepicture.addGestureRecognizer(tap)
        profilepicture.isUserInteractionEnabled = true
        
        return profilepicture
    }()
    
    
    let notificationLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Some test notification "
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellStyle()
        cellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




extension NotificationCell
{
    private func cellStyle()
    {
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel?.textColor = .darkGray
        userProfileImage.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    private func cellLayout()
    {
        let stack = UIStackView(arrangedSubviews: [userProfileImage,notificationLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        
        self.addSubview(stack)
        
        NSLayoutConstraint.activate([stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                                     stack.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 2),
                                     self.trailingAnchor.constraint(equalToSystemSpacingAfter: stack.trailingAnchor, multiplier: 2)
            
            
        ])
        
    }
}

extension NotificationCell
{
    @objc func handleProfileimageTapped()
    {
        delegate?.userPressedCell(cell: self)
    }
    
    func configureationCell()
    {
        guard let notificationPassed = notification else {return}
        
        let viewModel = NotificationViewModel(notification: notificationPassed)
        userProfileImage.sd_setImage(with: viewModel.profileImageURL, completed: nil)
        notificationLabel.attributedText = viewModel.notificationText
    }
}
