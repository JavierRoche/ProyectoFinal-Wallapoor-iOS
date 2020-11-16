//
//  DetailProductViewController+Constraints.swift
//  Wallapobre
//
//  Created by APPLE on 15/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

extension DetailProductViewController {
    func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(tableView)
        view.addSubview(footerView)
        view.addSubview(chatButton)
        
        /// Boton superior para salir del chat
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.arrowIcon), style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.alpha = 0.4
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            //footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        NSLayoutConstraint.activate([
            chatButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16.0),
            chatButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16.0),
            chatButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16.0),
            chatButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16.0)
        ])
    }
}
