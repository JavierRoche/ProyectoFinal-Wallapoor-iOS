//
//  ProductSellerCell.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class ProductSellerCell: UITableViewCell {
    lazy var avatarImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.image = UIImage(systemName: Constants.faceIcon)
        image.tintColor = UIColor.black
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shoppingSalesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: Life Cycle
    
    public func configureCell(viewModel: DetailProductViewModel) {
        self.setViewsHierarchy()
        self.setConstraints()
        
        guard let seller = viewModel.seller else { return }
        self.setData(seller: seller)
    }

    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        self.addSubview(avatarImageView)
        self.addSubview(usernameLabel)
        self.addSubview(shoppingSalesLabel)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            avatarImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
            avatarImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48.0)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 3.0),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            shoppingSalesLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -3.0),
            shoppingSalesLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 32.0)
        ])
    }
    
    fileprivate func setData(seller: User) {
        if !seller.avatar.isEmpty {
            guard let url = URL.init(string: seller.avatar) else { return }
            avatarImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.avatarImageView.image = value.image
                    
                case .failure(_):
                    self?.avatarImageView.image = UIImage(systemName: Constants.faceIcon)
                }
            }
        }
        usernameLabel.text = seller.username
        shoppingSalesLabel.text = "\(seller.shopping) \(Constants.Shopping) \(seller.sales) \(Constants.Sales)"
    }
}


