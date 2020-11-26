//
//  ProductViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class NewProductViewModel {
    /// Objetos para almacenar datos de pantalla
    private let categories = [Category.motor, Category.textile, Category.homes, Category.informatic, Category.sports, Category.services]
    /// Se guarda la categoria seleccionada para el producto
    var categoryPicked: Category?
    /// Instancia del producto cuando es una modificacion
    let originalProduct: Product?
    
    
    // MARK: Inits
    
    init(product: Product?){
        self.originalProduct = product
    }
    
    // MARK: Public Functions
    
    func numberOfCategories() -> Int {
        return categories.count
    }
    
    func getCategoryViewModel(at row: Int) -> String {
        return categories[row].name
    }
    
    func uploadImages(images: [UIImage], onSuccess: @escaping (_ urlList: [String]) -> Void, onError: ErrorClosure?) {
        var urlList: [String] = [String]()
        var count: Int = 0
        
        /// Iniciamos el manager de almacenamiento
        Managers.managerStorageFirebase = StorageFirebase()
        
        for image in images {
            let fileName = "\(UUID().uuidString).jpg"
            
            Managers.managerStorageFirebase!.saveImageGetUrl(fileName: fileName, image: image, onSuccess: { url in
                /// Añadimos la url recibida a la lista
                urlList.append(url)
                count += 1
                /// Solo salimos cuando se hayan subido todas las imagenes o por error
                if count == images.count {
                    DispatchQueue.main.async {
                        onSuccess(urlList)
                    }
                }
                
            }) { error in
                if let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
                }
            }
        }
    }
    
    func insertProduct(product: Product, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Iniciamos el manager e insertamos el producto
        Managers.managerProductFirestore!.insertProduct(product: product, onSuccess: {
            DispatchQueue.main.async {
                onSuccess()
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func modifyProduct(product: Product, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Iniciamos el manager e insertamos el producto
        Managers.managerProductFirestore!.modifyProduct(product: product, onSuccess: {
            DispatchQueue.main.async {
                onSuccess()
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func getHeightMainImage(image: UIImage) -> Double {
        /// Importante: el peso de una imagen no varia su tamaño en pixels (no es del todo cierto)
        let scaledImage = image.scaleToWidth(scale: UIScreen.main.bounds.width)
        return Double((scaledImage.size.height * scaledImage.scale) / 2)
    }
}

