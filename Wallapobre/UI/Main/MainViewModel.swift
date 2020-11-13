//
//  MainViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import CoreLocation

protocol MainViewModelDelegate: class {
    func productCellViewModelsCreated()
}

class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    var originalProductList: [ProductCellViewModel] = []
    var filteredProductList: [ProductCellViewModel] = []

    
    // MARK: Public Functions
    
    func viewWasLoaded() {
        //var count: Int = 0
        
        Managers.managerProductFirestore!.selectProducts(onSuccess: { [weak self] products in
            /// Aplicamos el filtro de distancia a la lista original descargada
            self?.filterByDistance(products: products, onSuccess: { products in
                /// Mapeamos los productos del area inicial al modelo de celda
                self?.originalProductList = products.compactMap({ ProductCellViewModel(product: $0) })
                
                /// Avisamos al controlador de que el modelo de datos se ha creado
                self?.delegate?.productCellViewModelsCreated()
            })
            
        }, onError: { error in
            /// Ha habido error raro
            print(error.localizedDescription)
            /*if let retError = onError {
                retError(error)
            }*/
        })
    }

    func numberOfItems(in section: Int) -> Int {
        return originalProductList.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> ProductCellViewModel {
        return originalProductList[indexPath.row]
    }
    
    
    // MARK: Private Functions
    
    //comprueba de cada producto la distancia con el usuario
    fileprivate func filterByDistance(products: [Product], onSuccess: @escaping ([Product]) -> Void) {
        let userLocation: CLLocation = CLLocation(latitude: Managers.managerUserLocation!.getUserLogged().latitude!, longitude: Managers.managerUserLocation!.getUserLogged().longitude!)
        var filteredProductList: [Product] = [Product]()
        var count: Int = 1
        
        for product in products {
            self.getSellerData(product: product, onSuccess: { user in
                /// Comprobamos que el usuario del producto se ha recuperado
                if let user = user {
                    /// Con locations del producto calculamos la distancia al usuario en metros y linea recta
                    let productLocation = CLLocation(latitude: user.latitude!, longitude: user.longitude!)
                    let distance = productLocation.distance(from: userLocation)
                    if distance < 50000.0 {
                        filteredProductList.append(product)
                    }
                    
                    if count == products.count {
                        onSuccess(filteredProductList)
                    }
                    count += 1
                }
                
                /// El producto se ignora si ha habido error
            }, onError: { _ in })
        }
        /*products.compactMap({ [weak self] product in
           
        })*/
        
        
    }
    
    fileprivate func getSellerData(product: Product, onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        Managers.managerUserFirestore!.selectUser(userId: product.seller, onSuccess: { user in
            onSuccess(user)
            
        }, onNonexistent: {
            onSuccess(nil)
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
}
