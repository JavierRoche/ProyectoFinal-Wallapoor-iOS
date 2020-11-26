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
        view.addSubview(deleteProductButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        NSLayoutConstraint.activate([
            chatButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 12.0),
            chatButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -12.0),
            chatButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12.0),
            chatButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -12.0)
        ])
        
        NSLayoutConstraint.activate([
            deleteProductButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 12.0),
            deleteProductButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -12.0),
            deleteProductButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12.0),
            deleteProductButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -12.0)
        ])
    }
}
