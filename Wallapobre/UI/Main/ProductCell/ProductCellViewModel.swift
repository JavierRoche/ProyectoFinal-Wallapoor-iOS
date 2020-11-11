//
//  ProductCellViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class ProductCellViewModel {
    let productId: String
    let productImage: UIImage
    let price: Int
    let title: String

    init(product: Product, image: UIImage) {
        self.productId = product.productId
        self.productImage = image
        self.price = product.price
        self.title = product.title
        
        /*let url = URL.init(string: product.photos[0])
        productImage.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image,_,_,_) in
            if let image = image {
                self.productImage = image
            }
        }*/
    }
}
