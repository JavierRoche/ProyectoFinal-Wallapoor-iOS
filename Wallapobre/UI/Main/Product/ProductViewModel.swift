//
//  ProductViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class ProductViewModel {
    
    // MARK: Public Functions
    
    public func uploadImages(images: [UIImage], onSuccess: @escaping (_ urlList: [String]) -> Void, onError: ErrorClosure?) {
        var urlList: [String] = [String]()
        var count: Int = 0
        
        for image in images {
            let fileName = "\(UUID().uuidString).jpg"
            
            Managers.managerStorageFirebase!.saveImageGetUrl(fileName: fileName, image: image, onSuccess: { url in
                /// Añadimos la url recibida a la lista
                urlList.append(url)
                count += 1
                /// Solo salimos cuando se hayan subido todas las imagenes o por error
                if count == images.count {
                    onSuccess(urlList)
                }
                
            }) { error in
                if let retError = onError {
                    retError(error)
                }
            }
        }
    }
    
    func insertProduct(product: Product, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        Managers.managerProductFirestore!.insertProduct(product: product, onSuccess: {
            onSuccess()
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
}

