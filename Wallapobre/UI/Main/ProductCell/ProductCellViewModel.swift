//
//  ProductCellViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCellViewModel {
    let product: Product
    //let productId: String
    let productImage = UIImageView()
    /*let price: Int
    let title: String*/

    init(product: Product) { //}, image: UIImage) {
        self.product = product
        /*self.productId = product.productId
        self.productImage = image
        self.price = product.price
        self.title = product.title*/
        
        //guard let url = URL.init(string: product.photos[0]) else { return }
        /// Aqui puntualmente no uso KingFisher porque da mejor resultado el nativo
        /*DispatchQueue.global(qos:.userInitiated).async {
            guard let data = try? Data(contentsOf: url) else { return }

            DispatchQueue.main.async {
                self.productImage.image = UIImage(data: data)
                self.productImage.setNeedsLayout()
            }
        }*/
        /*self.productImage.kf.setImage(with: url) { result in
            switch result {
            case .success(let value):
                self.productImage.image = value.image
                
            case .failure(_):
                self.productImage.image = UIImage(systemName: Constants.WarningImage)
            }
        }*/
        
    }
}
