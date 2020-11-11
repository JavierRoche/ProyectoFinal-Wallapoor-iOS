//
//  ProductSocialNetworksCell.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class ProductSocialNetworksCell: UITableViewCell {
    lazy var backgroundViewCell: UIView = {
        let view: UIView = UIView(frame: self.contentView.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var facebookImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var twitterImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var mailImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var whatsappImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    //MARK: Life Cycle
    
    public func configureCell(seller: User) {
        self.setViewsHierarchy()
        self.setConstraints()
    }


    /*override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 8.0
        contentView.layer.masksToBounds = true
    }*/

    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        self.addSubview(backgroundViewCell)
        self.addSubview(facebookImageView)
        self.addSubview(twitterImageView)
        self.addSubview(mailImageView)
        self.addSubview(whatsappImageView)
    }
    
    
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}


