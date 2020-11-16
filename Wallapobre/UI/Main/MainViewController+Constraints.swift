//
//  MainViewController+Constraints.swift
//  Wallapobre
//
//  Created by APPLE on 15/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

extension MainViewController {
    func setViewsHierarchy() {
        view = UIView()
        view.backgroundColor = .white

        view.addSubview(collectionView)
        view.addSubview(newProductButton)
        view.addSubview(saveSearchButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6.0),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -6.0)
        ])
        
        NSLayoutConstraint.activate([
            newProductButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newProductButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            //newProductButton.trailingAnchor.constraint(equalTo: saveSearchButton.leadingAnchor, constant: 32.0),
            newProductButton.widthAnchor.constraint(equalToConstant: 64.0),
            newProductButton.heightAnchor.constraint(equalToConstant: 64.0)
        ])
        
        NSLayoutConstraint.activate([
            //saveSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveSearchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            saveSearchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            saveSearchButton.widthAnchor.constraint(equalToConstant: 64.0),
            saveSearchButton.heightAnchor.constraint(equalToConstant: 64.0)
        ])
    }
}
