//
//  editProfileController.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2023/01/09.
//  Copyright © 2023 Erick El nino. All rights reserved.
//

import UIKit

private let editcellidentifier = "EditprofileCell"

protocol editProfileControllerDelegate: AnyObject
{
    func controllerEdit(controller: editProfileController , currentuser: User)
}

class editProfileController: UITableViewController
{
    var profileUser: User
    
    private let footerView = EditprofileFooterView()
    
    weak var delegate: editProfileControllerDelegate?
    
    lazy var headerView = UserProfileHeader(user: profileUser)
    
    var userdetailsChanged:Bool = false
    var imageProfilechanged:Bool = false
    
    var selectedImage: UIImage?
    {
        didSet
        {
            headerView.userProfileImage.image = selectedImage
            imageProfilechanged = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    var erickelninoImagePicker = UIImagePickerController()
    
    init(user: User) {
        self.profileUser = user
        super.init(style: .plain)
        headerView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStyle()
        configureTableView()
        configureationImagePicker()
    }
    
    func configureTableView()
    {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 190)
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableFooterView = footerView
        footerView.delegate = self
        tableView.register(editProfileCell.self, forCellReuseIdentifier: editcellidentifier)
    }
    
    func configureationImagePicker()
    {
        erickelninoImagePicker.delegate = self
        erickelninoImagePicker.allowsEditing = true
    }
    
}

extension editProfileController
{
    private func configureStyle()
    {
        view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveprofile))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    
    @objc func handleSaveprofile()
    {
        if imageProfilechanged && userdetailsChanged != true
        {
            updateImageprofile()
            print("DEBUG: change Image not data")
        }
        
        if imageProfilechanged == true && userdetailsChanged == true
        {
            
            Services.shared.saveUserinfo(profileUser: profileUser) { (Error, databaseref) in
                self.delegate?.controllerEdit(controller: self, currentuser: self.profileUser)
                
                self.updateImageprofile()
            }
             print("DEBUG: change Image and data")
        }
        
        if imageProfilechanged != true && userdetailsChanged == true
        {
            updateUserdata()
             print("DEBUG: change Data not Image")
        }
    }
    
    @objc func handleCancel()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUserdata()
    {
        Services.shared.saveUserinfo(profileUser: profileUser) { (Error, databaseref) in
            self.delegate?.controllerEdit(controller: self, currentuser: self.profileUser)
        }
    }
    
    
    func updateImageprofile()
    {
        guard let images = selectedImage else {return}
        imageProfilechanged = true
        
        Services.shared.UpdateprofileImage(Image: images) { profileImageUrl in
            guard let ImageURl = profileImageUrl else {return}
            self.profileUser.userProfileImageurl = ImageURl
            self.delegate?.controllerEdit(controller: self, currentuser:self.profileUser)
        }
    }
    
    
}
extension editProfileController: UserProfileHeaderDelegate
{
    func userDidtapChangePhoto() {
        
        erickelninoImagePicker.modalPresentationStyle = .fullScreen
        self.present(erickelninoImagePicker, animated: true, completion: nil)
        
    }
    
}
extension editProfileController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editprofileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: editcellidentifier, for: indexPath) as? editProfileCell else {return UITableViewCell()}
        guard let options = editprofileOptions(rawValue: indexPath.row) else {return cell}
        cell.deldgate = self
        cell.viewmodel = editProfileViewModel(user: profileUser, options: options)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let options = editprofileOptions(rawValue: indexPath.row) else {return 0}
        
        return options == .bio ? 100:50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
}

extension editProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagepicked = info[.editedImage] as? UIImage else {return}
        
        self.selectedImage = imagepicked
        
        self.dismiss(animated: true , completion: nil)
    }
    
}

extension editProfileController: editprofileCellDelegate
{
    func updateUserprofilefields(with cell: editProfileCell) {
        guard let viewmodel = cell.viewmodel else {return }
        
        switch viewmodel.option
        {
            
        case .Fullname:
            guard let value = cell.infotextfield.text else {return}
            userdetailsChanged = true
            profileUser.userfullname = value
            navigationItem.rightBarButtonItem?.isEnabled = true
        case .Username:
            guard let value = cell.infotextfield.text else {return}
            profileUser.Username = value
            userdetailsChanged = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        case .bio:
            guard let value = cell.bioInputView.text else {return}
            profileUser.userBio = value
            userdetailsChanged = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
    }
}

extension editProfileController: EditprofileFooterViewDelegate
{
    func logoutButtonPressed() {
        print("DEBUG: LOGOUT from edit profile controller")
    }

}


