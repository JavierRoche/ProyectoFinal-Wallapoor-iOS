//
//  ProductDataEditionCell.swift
//  Wallapobre
//
//  Created by APPLE on 24/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class ProductDataEditionCell: UITableViewCell {
    lazy var lastEditionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var iconImage: UIImageView = {
        let image: UIImageView = UIImageView()
        image.image = UIImage(systemName: Constants.iconEye)
        image.tintColor = UIColor.lightGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var viewersLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.lightGray
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
        self.addSubview(lastEditionLabel)
        self.addSubview(iconImage)
        self.addSubview(viewersLabel)
    }
    
    fileprivate func setData(viewModel: DetailProductViewModel) {
        let lastEdition = Date.fromDateToString(date: viewModel.product.sentDate, format: Constants.dateFormat)
        lastEditionLabel.text = "\(Constants.lastEdition)\(lastEdition)"
        viewersLabel.text = String(viewModel.product.viewers)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            lastEditionLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            lastEditionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
            lastEditionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32.0)
        ])
        
        NSLayoutConstraint.activate([
            iconImage.centerYAnchor.constraint(equalTo: lastEditionLabel.centerYAnchor),
            iconImage.trailingAnchor.constraint(equalTo: viewersLabel.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            viewersLabel.centerYAnchor.constraint(equalTo: lastEditionLabel.centerYAnchor),
            viewersLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -32.0)
        ])
    }
}


