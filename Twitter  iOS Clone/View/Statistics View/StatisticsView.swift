//
//  StatisticsView.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/14.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit

class StatisticsView: UIView
{
    init(lieksLable: UILabel, RetweetsLabel: UILabel) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.backgroundColor = .white
        //        =================
        let divider1 = UIView()
        divider1.translatesAutoresizingMaskIntoConstraints = false
        divider1.backgroundColor = .systemGroupedBackground
        divider1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //        =======================
        
        
        let divider2 = UIView()
        divider2.translatesAutoresizingMaskIntoConstraints = false
        divider2.backgroundColor = .systemGroupedBackground
        divider2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //        =====================
        
        self.addSubview(divider1)
        divider1.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        divider1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        divider1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        
        self.addSubview(divider2)
        divider2.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        divider2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        divider2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [RetweetsLabel,lieksLable])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        
        self.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        stack.centerY(inView: self)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
