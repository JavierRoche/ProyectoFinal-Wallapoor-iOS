//
//  ProfileViewController+Constraints.swift
//  Wallapobre
//
//  Created by APPLE on 15/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

extension ProfileViewController {
    func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(backgroundView)
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(locationLabel)
        view.addSubview(shoppingSalesLabel)
        view.addSubview(segmentControl)
        view.addSubview(collectionView)
        view.addSubview(searchesTableView)
        view.addSubview(discussionsTableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 96.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 96.0)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 8.0),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4.0),
            locationLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16.0),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            shoppingSalesLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -8.0),
            shoppingSalesLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16.0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6.0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6.0)
        ])
        
        NSLayoutConstraint.activate([
            searchesTableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16.0),
            searchesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchesTableView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            searchesTableView.trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            discussionsTableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16.0),
            discussionsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            discussionsTableView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            discussionsTableView.trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor)
        ])
    }
}
