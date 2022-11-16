//
//  ContainerView.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/16.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class ContainerView
{
    func inputContainerView(with image: UIImage, textfield: UITextField) -> UIView
    {
        let view = UIView()
        let separator = UIView()
       
        view.translatesAutoresizingMaskIntoConstraints = false
    
        
        let imageV = UIImageView()
        imageV.clipsToBounds = true
        imageV.image = image.withRenderingMode(.alwaysOriginal)
        imageV.setDimensions(width: 25, height: 25)
        view.addSubview(imageV)
        imageV.centerY(inView: view)
        imageV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        separator.backgroundColor = .white
        
        view.addSubview(textfield)
        textfield.leadingAnchor.constraint(equalTo: imageV.trailingAnchor, constant: 5).isActive = true
        textfield.centerY(inView: imageV)
        
        
        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: imageV.bottomAnchor, constant: 10).isActive = true
        separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        separator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
}
