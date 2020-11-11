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
        image.image = UIImage(systemName: "faceid")
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
        label.text = "UsernameLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: Life Cycle
    
    public func configureCell(seller: User) {
        self.setViewsHierarchy()
        self.setConstraints()
        self.setData(seller: seller)
    }


    /*override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }*/

    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        self.addSubview(avatarImageView)
        self.addSubview(usernameLabel)
    }
    
    
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32.0),
            avatarImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32.0),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48.0)
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 3.0),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16.0)
        ])
    }
    
    fileprivate func setData(seller: User) {
        //avatarImageView.image = seller.avatar
        usernameLabel.text = seller.username
    }
}


