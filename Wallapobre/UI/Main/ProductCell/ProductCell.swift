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
    lazy var backgroundViewCell: UIView = {
        let view: UIView = UIView(frame: self.contentView.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = false
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle17Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //  cell.viewModel = viewModel.viewModel(at: indexPath)
    
    //lazy var cellHeight: CGFloat = 0
    
    var viewModel: ProductCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            /*let url = URL.init(string: viewModel.productImage)
            imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image,_,_,_) in
                if let image = image {
                    self.imageView.image = image
                }
            }*/
            //imageView.image = viewModel.productImage
            DispatchQueue.main.async { [weak self] in
                self?.priceLabel.text = String(viewModel.product.price)
                self?.titleLabel.text = viewModel.product.title
            }
            
            self.setViewsHierarchy()
            self.setConstraints()
        }
    }
    
    //MARK: Life Cycle
    
    public func configureCell(viewModel: ProductCellViewModel) {
        /// Aplicamos la jerarquia de vistas y propiedades
        self.setViewsHierarchy()
        /// Pintamos la foto
        self.setInfo(viewModel: viewModel)
        /// Fijamos las constraints de los elementos
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
        self.addSubview(imageView)
        self.addSubview(priceLabel)
        self.addSubview(titleLabel)
    }
    
    fileprivate func setInfo(viewModel: ProductCellViewModel) {
        let url = URL.init(string: viewModel.product.photos[0])
        
        imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image,_,_,_) in
            if let image = image {
                self.imageView.image = image
            }
        }
        
        DispatchQueue.main.async {
            self.priceLabel.text = String(viewModel.product.price)
            self.titleLabel.text = viewModel.product.title
            //self.imageView.setNeedsLayout()
        }
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16.0),
            priceLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16.0),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16.0)
        ])
    }
}
