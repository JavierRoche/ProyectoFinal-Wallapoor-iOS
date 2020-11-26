//
//  ProductDataCell.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class ProductDataCell: UITableViewCell {
    lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle28Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle22SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Regular
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: Life Cycle
    
    public func configureCell(viewModel: DetailProductViewModel) {
        self.setViewsHierarchy()
        self.setConstraints()
        self.setData(viewModel: viewModel)
    }

    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        self.addSubview(priceLabel)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
    }
    
    fileprivate func setData(viewModel: DetailProductViewModel) {
        priceLabel.text = String(viewModel.product.price)
        titleLabel.text = viewModel.product.title
        descriptionLabel.text = viewModel.product.description
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            priceLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            priceLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16.0),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
    }
}

