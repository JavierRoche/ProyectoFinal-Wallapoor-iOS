//
//  ProfileViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import CoreLocation

protocol ProfileViewModelDelegate: class {
    func productCellViewModelsCreated()
    func searchViewModelsCreated()
    func filterApplied()
    func geocodeLocationed(location: String)
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?
    /// Lista original con todos los productos del usuario descargados de Firebase DB
    private var originalProductList: [ProductCellViewModel] = []
    /// Es la lista de la que tira el Collection View principal
    private var actualProductList: [ProductCellViewModel] = []
    /// Lista original con todos las busquedas de usuario descargadas de Firebase DB
    private var originalSearchList: [Search] = []

    
    // MARK: Life Cycle
    
    func viewWasLoaded() {
        self.setAddress()
        self.getUserProducts()
        self.getUserSearches()
    }
    
    
    // MARK: Public Functions
    
    func numberOfItems(in section: Int) -> Int {
        return actualProductList.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> ProductCellViewModel {
        return actualProductList[indexPath.row]
    }
    
    func numberOfRows(in section: Int) -> Int {
        return originalSearchList.count
    }

    func getRowViewModel(at indexPath: IndexPath) -> Search {
        return originalSearchList[indexPath.row]
    }
    
    func filterByState(state: ProductState){
        var filteredProducts: [ProductCellViewModel] = []
        
        /// Por cada producto comprobamos su estado
        filteredProducts = self.originalProductList.compactMap { productCellViewModel in
            if productCellViewModel.product.state == state {
                return productCellViewModel
            }
            return nil
        }
        
        /// Actualizamos la lista segun productos comprados o vendidos
        self.actualProductList = filteredProducts
        self.delegate?.filterApplied()
    }
    
    func setAddress() {
        let userLocation = CLLocation(latitude: MainViewModel.user.latitude!,
                                      longitude: MainViewModel.user.longitude!)
        
        /// Aplicamos geolocalizacion inversa con un CLGeocoder
        let geocoder = CLGeocoder()
        /// El closure nos devuelve las placemarks o el error
        geocoder.reverseGeocodeLocation(userLocation) { [weak self] placemarks, error in
            if let error = error {
                print(error)
            }
            
            guard let placemark = placemarks?.first else {
                print(CLError.geocodeFoundNoResult)
                return
            }
            
            /// Extraemos la informacion, la formateamos y la pintamos
            let postalCode = placemark.postalCode ?? String()
            let locality = placemark.locality ?? String()
            
            /// Informamos al controlador para el repintado
            self?.delegate?.geocodeLocationed(location: "\(postalCode), \(locality)")
        }
    }
    
    func updateProfile(image: UIImage, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        /// Primero subimos la foto
        self.uploadImages(image: image, onSuccess: { url in
            MainViewModel.user.avatar = url
            /// Actualizamos el registro del usuario
            Managers.managerUserFirestore = UserFirestore()
            Managers.managerUserFirestore!.updateUser(user: MainViewModel.user, onSuccess: {
                onSuccess()
                
            }) { error in
                if let retError = onError {
                    DispatchQueue.main.async {
                        retError(error)
                    }
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
    
    
    // MARK: Private Functions
    
    fileprivate func getUserProducts() {
        Managers.managerProductFirestore = ProductFirestore()
        Managers.managerProductFirestore!.selectProductBySeller(userId: MainViewModel.user.sender.senderId, onSuccess: { [weak self] products in
            /// Mapeamos los productos al modelo de celda
            let productCellViewModels = products.compactMap({ ProductCellViewModel(product: $0) })
            
            /// Actualizamos la situacion de los modelos
            self?.originalProductList = productCellViewModels
            self?.actualProductList = productCellViewModels
            
            /// Informamos al controlador para el repintado
            self?.delegate?.productCellViewModelsCreated()
            
        }, onError: { error in
            /// Ha habido error raro
            print(error.localizedDescription)
        })
    }
    
    fileprivate func getUserSearches() {
        Managers.managerSearchFirestore = SearchFirestore()
        Managers.managerSearchFirestore!.selectSearchs(onSuccess: { [weak self] searches in
            /// Actualizamos la situacion de los modelos
            self?.originalSearchList = searches
            
            /// Informamos al controlador para el repintado
            self?.delegate?.searchViewModelsCreated()
            
        }, onNonexistent: {
            self.originalSearchList = []
            
        }, onError: { error in
            /// Ha habido error raro
            print(error.localizedDescription)
        })
    }
    
    fileprivate func uploadImages(image: UIImage, onSuccess: @escaping (_ urlList: String) -> Void, onError: ErrorClosure?) {
        let fileName = "\(UUID().uuidString).jpg"
        Managers.managerStorageFirebase = StorageFirebase()
        Managers.managerStorageFirebase!.saveImageGetUrl(fileName: fileName, image: image, onSuccess: { url in
            /// Añadimos la url recibida a la lista
            DispatchQueue.main.async {
                onSuccess(url)
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
