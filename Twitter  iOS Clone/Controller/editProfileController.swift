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
    
   
    weak var delegate: editProfileControllerDelegate?
    
    lazy var headerView = UserProfileHeader(user: profileUser)
    
    var selectedImage: UIImage?
      {
          didSet
          {
            headerView.userProfileImage.image = selectedImage
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
        tableView.tableFooterView = UIView()
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
        updateUserdata()
    }
    
    @objc func handleCancel()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUserdata()
    {
        Services.shared.saveUserinfo(profileUser: profileUser) { (Error, databaseref) in
            if let error = Error
            {
                print("DEBUG: ERROR: \(error.localizedDescription)")
                return
            }
            self.delegate?.controllerEdit(controller: self, currentuser: self.profileUser)
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
            profileUser.userfullname = value
             navigationItem.rightBarButtonItem?.isEnabled = true
        case .Username:
             guard let value = cell.infotextfield.text else {return}
             profileUser.Username = value
             navigationItem.rightBarButtonItem?.isEnabled = true
        case .bio:
            guard let value = cell.bioInputView.text else {return}
            profileUser.userBio = value
             navigationItem.rightBarButtonItem?.isEnabled = true
        }
        
       
        print("DEBUG: USER FULLNAME: \(profileUser.userfullname ?? "")")
        print("DEBUG: USER NAME: \(profileUser.Username ?? "")")
        print("DEBUG: USER BIO : \(profileUser.userBio ?? "")")
        
    }
}


