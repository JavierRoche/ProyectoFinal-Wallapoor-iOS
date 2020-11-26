//
//  DiscussionCell.swift
//  Wallapobre
//
//  Created by APPLE on 25/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class DiscussionCell: UITableViewCell {
    lazy var productImageView: UIImageView = {
        let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var productLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle20Bold
        label.numberOfLines = 1
        label.tintColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var viewModel: DiscussionCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            guard let url = URL.init(string: viewModel.product.photos[0]) else { return }
            self.productImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.productImageView.image = value.image
                    
                case .failure(_):
                    self?.productImageView.image = UIImage(systemName: Constants.iconImageWarning)
                }
            }
            productLabel.text = viewModel.product.title
        }
    }
    
    
    //MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        /// Borde
        contentView.layer.cornerRadius = 4.0
        contentView.layer.masksToBounds = false
        
        /// Sombra
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        contentView.layer.shadowRadius = 1.5
        contentView.layer.shadowOpacity = 0.8
        
        /// Borde de la imagen
        productImageView.layer.masksToBounds = true
        productImageView.layer.cornerRadius = 8.0
        
        self.setViewsHierarchy()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Necesario al redibujar el contenido de una fila para evitar varios tipos de errores de dibujado
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
    }
    
    
    // MARK: Private Functions
        
    fileprivate func setViewsHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(productLabel)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            productImageView.widthAnchor.constraint(equalToConstant: 60.0),
            productImageView.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        NSLayoutConstraint.activate([
            productLabel.centerYAnchor.constraint(equalTo: productImageView.centerYAnchor),
            productLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16.0),
            productLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        ])
    }
}

