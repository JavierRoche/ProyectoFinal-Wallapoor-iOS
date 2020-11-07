//
//  ProfileViewController.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoutButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Logout", for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector (tapOnLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Objeto del modelo que contiene el perfil del usuario
    let viewModel: ProfileViewModel
    
    
    // MARK: Inits

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: Life Cycle

    override func loadView() {
        self.setViewsHierarchy()
        self.setConstraints()
    }
    
    
    // MARK: User Interactions
    
    @objc func tapOnLogout() {
        Managers.managerUserAuthoritation!.logout(onSuccess: {
            self.showAlert(title: "Logout", message: "User log out")
        }) { [weak self] error in
            print(error)
            self?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    
    // MARK: Private Functions
    
    fileprivate func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(backgroundView)
        view.addSubview(logoutButton)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32.0),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64.0)
        ])
    }
}

