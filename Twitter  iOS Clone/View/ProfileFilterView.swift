//
//  ProfileFilterView.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/28.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit


protocol profileViewFilterDelegate: AnyObject
{
    func ProfileviewCellSelected(currentView:ProfileFilterView, ViewSelctedIndexPath: IndexPath)
}
private let resuseIdentifierCell = "profilViewCell"

class ProfileFilterView: UIView
{
    
    
    weak var delegate:profileViewFilterDelegate?
    
    
    lazy var myCollectionView: UICollectionView =
    {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ProfileFilterViewCell.self, forCellWithReuseIdentifier: resuseIdentifierCell)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCollectionView()
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
    func addCollectionView()
    {
        self.addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        myCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true 
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ProfileFilterView: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFliterCaseOption.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuseIdentifierCell, for: indexPath) as? ProfileFilterViewCell
            else {return UICollectionViewCell()}
        let option = ProfileFliterCaseOption(rawValue: indexPath.row)?.description ?? ""
        cell.titleLabel.text = option
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.ProfileviewCellSelected(currentView: self, ViewSelctedIndexPath: indexPath)
    }
}


extension ProfileFilterView: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / CGFloat(ProfileFliterCaseOption.allCases.count), height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


