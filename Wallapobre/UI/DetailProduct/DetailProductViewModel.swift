//
//  DetailProductViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import ImageSlideshow

class DetailProductViewModel {
    var product: Product
    var seller: User?
    var urls = [KingfisherSource]()
    
    
    // MARK: Inits
    
    init(product: Product){
        self.product = product
        
        for url in product.photos {
            if let url = URL.init(string: url) {
                urls.append(KingfisherSource.init(url: url))
            }
        }
    }
    
    
    // MARK: Public Functions
    
    func getSellerData(onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        Managers.managerUserFirestore!.selectUser(userId: self.product.seller, onSuccess: { user in
            self.seller = user
            DispatchQueue.main.async {
                onSuccess(user)
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func deleteProduct(onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Iniciamos el manager y borramos el producto
        Managers.managerProductFirestore!.deleteProduct(product: self.product, onSuccess: {
            DispatchQueue.main.async {
                onSuccess()
            }
            
        }, onError: { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        })
    }
}
