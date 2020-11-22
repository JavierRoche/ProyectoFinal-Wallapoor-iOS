//
//  MainCell.swift
//  UICollectionViewCustomLayout
//
//  Created by Roberto Garrido on 10/05/2020.
//  Copyright © 2020 Roberto Garrido. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle20Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var viewModel: ProductCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            guard let url = URL.init(string: viewModel.product.photos[0]) else { return }
            self.imageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.imageView.bounds.size.height = CGFloat(viewModel.product.heightMainphoto)
                    self?.imageView.image = value.image
                    
                case .failure(_):
                    self?.imageView.image = UIImage(systemName: Constants.WarningImage)
                }
            }
            priceLabel.text = "\(String(viewModel.product.price))\(Constants.Euro)"
            titleLabel.text = viewModel.product.title
        }
    }
    
    
    //MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /// Borde
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        /// Sombra
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        
        /// Borde de la imagen
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8.0
        
        self.setViewsHierarchy()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Necesario al redibujar el contenido de una celda para evitar varios tipos de errores de dibujado
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(titleLabel)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.6),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.6),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.6),
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0)
        ])
    }
}
