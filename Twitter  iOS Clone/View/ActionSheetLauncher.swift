//
//  ActionSheetLauncher.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/12/19.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import UIKit


protocol ActionsheetLaucherDelegate: AnyObject
{
    func didSelectOption(option: ActionSheetOptions, currentActionsheetLauncher: ActionSheetLauncher)
}

private let cellidentifier = "TableViewCellID"

class ActionSheetLauncher: NSObject
{
    
    
    weak var delegate: ActionsheetLaucherDelegate?
    
    var currentUser: User
    
    
    private lazy var viewModel = ActionSheetViewModel(user: currentUser)
    
    private var window: UIWindow?
    
    
    private var tabelview  = UITableView()
    
    private lazy var BlackView: UIView =
    {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        
        let tap  = UITapGestureRecognizer(target: self, action: #selector(HandleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    
 
    
    private lazy var cancelButton: UIButton =
    {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        
        button.addTarget(self, action: #selector(HandleDismissal), for: .primaryActionTriggered)
        
        
        return button
    }()
    
    private lazy var footer: UIView =
    {
        let view = UIView()
     
        view.addSubview(cancelButton)
        
        cancelButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        cancelButton.centerY(inView: view)
        cancelButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        cancelButton.layer.cornerRadius = 75 / 2
        
        return view
        
    }()
    
    
    init(user: User) {
        self.currentUser = user
        print("DEBUG: USER SET IN BLACKVIEWIS \(self.currentUser)")
        super.init()
        configTableView()
    }
    
    func show()
    {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
        self.window = window
        
        
        window.addSubview(BlackView)
        BlackView.frame = window.frame
        
        window.addSubview(tabelview)
        
        let tableHeight = CGFloat(viewModel.options.count * 80) + 80
        self.tabelview.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: tableHeight)
        UIView.animate(withDuration: 0.5) {
            
            self.BlackView.alpha = 1
            self.tabelview.frame.origin.y -= tableHeight
        }
    }
    
    func configTableView()
    {
        tabelview.delegate = self
        tabelview.dataSource = self
        tabelview.separatorStyle = .none
        tabelview.backgroundColor = .white
        tabelview.rowHeight = 80
        tabelview.layer.cornerRadius = 10
        tabelview.isScrollEnabled = false
        tabelview.register(ActionSheetCell.self, forCellReuseIdentifier: cellidentifier)
        
    }
    
    @objc func HandleDismissal()
    {
        UIView.animate(withDuration: 0.5) {
            self.BlackView.alpha = 0
            self.tabelview.frame.origin.y += 300
        }
    }
    
}


extension ActionSheetLauncher: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tabelview.dequeueReusableCell(withIdentifier: cellidentifier, for: indexPath) as? ActionSheetCell else {return UITableViewCell()}
        
        cell.actionSheetValue = viewModel.options[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = viewModel.options[indexPath.row]
        
        delegate?.didSelectOption(option: selectedOption, currentActionsheetLauncher: self)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
}
