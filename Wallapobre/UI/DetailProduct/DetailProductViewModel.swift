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
    
    func getSellerData(viewModel: DetailProductViewModel, onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        Managers.managerUserFirestore!.selectUser(userId: viewModel.product.seller, onSuccess: { user in
            self.seller = user
            onSuccess(user)
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
}
