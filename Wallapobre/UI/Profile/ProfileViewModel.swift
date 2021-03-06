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
    func discussionViewModelsCreated()
    func filterApplied()
    func geocodeLocationed(location: String)
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?
    /// Lista original con todos los productos del usuario descargados de Firestore DB
    private var originalProductList: [ProductCellViewModel] = []
    /// Es la lista de la que tira el Collection View principal
    private var actualProductList: [ProductCellViewModel] = []
    /// Lista original con todos las busquedas de usuario descargadas de Firestore DB
    private var originalSearchList: [Search] = []
    /// Lista original con todas las discussions del usuario descargadas de Firestore DB
    private var originalDiscussionList: [DiscussionCellViewModel] = []

    
    // MARK: Life Cycle
    
    func viewWasLoaded() {
        self.setAddress()
    }
    
    func viewWasAppear() {
        self.getUserProducts()
        self.getUserSearches()
        self.getUserDiscussions()
    }
    

    // MARK: Public Functions
    
    func numberOfItems(in section: Int) -> Int {
        return actualProductList.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> ProductCellViewModel {
        return actualProductList[indexPath.row]
    }
    
    func numberOfSearches(in section: Int) -> Int {
        return originalSearchList.count
    }

    func getSearchViewModel(at indexPath: IndexPath) -> Search {
        return originalSearchList[indexPath.row]
    }
    
    func numberOfDiscussions(in section: Int) -> Int {
        return originalDiscussionList.count
    }

    func getDiscussionViewModel(at indexPath: IndexPath) -> DiscussionCellViewModel {
        return originalDiscussionList[indexPath.row]
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
        let userLocation = CLLocation(latitude: MainViewModel.user.latitude, longitude: MainViewModel.user.longitude)
        
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
            /// Podemos liberar memoria
            Managers.managerStorageFirebase = nil
            
            MainViewModel.user.avatar = url
            /// Actualizamos el registro del usuario
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
            /// Liberamos memoria
            Managers.managerSearchFirestore = nil
            
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
    
    fileprivate func getUserDiscussions() {
        Managers.managerDiscussionFirestore = DiscussionFirestore()
        Managers.managerDiscussionFirestore?.selectDiscussionByUser(user: MainViewModel.user, field: Constants.seller, onSuccess: { [weak self] sellerDiscussions in
            
            /// Una vez tenemos las Discussion en las que el usuario es seller obtenemos las que es buyer
            /// Esto es porque Firestore no permite consultas OR
            Managers.managerDiscussionFirestore?.selectDiscussionByUser(user: MainViewModel.user, field: Constants.buyer, onSuccess: { buyerDiscussions in
                /// Liberamos memoria
                Managers.managerDiscussionFirestore = nil
                
                /// Unimos ambas listas en el modelo y las mapeamos al modelo de celda
                let discussions = sellerDiscussions + buyerDiscussions
                var discussionCellViewModels: [DiscussionCellViewModel] = [DiscussionCellViewModel]()
                var count: Int = 1
                
                for discussion in discussions {
                    self?.getProduct(productId: discussion.productId, onSuccess: { product in
                        /// Comprobamos que el producto se ha recuperado
                        if let product = product {
                            discussionCellViewModels.append(DiscussionCellViewModel(discussion: discussion, product: product))
                            
                        } /*else {
                            let emptyProduct = Product.init(seller: String(), title: String(), category: Category.homes, description: String(), price: 0, photos: [String()], heightMainphoto: 0)
                            discussionCellViewModels.append(DiscussionCellViewModel(discussion: discussion, product: emptyProduct))
                        }*/
                        
                        if count == discussions.count {
                            self?.originalDiscussionList = discussionCellViewModels
                            /// Informamos al controlador para el repintado
                            self?.delegate?.discussionViewModelsCreated()
                        }
                        count += 1
                        
                    }, onError: { _ in })
                }
                
            }, onError: { error in
                /// Ha habido error raro
                print(error.localizedDescription)
            })
            
        }, onError: { error in
            /// Ha habido error raro
            print(error.localizedDescription)
        })
    }
    
    fileprivate func getProduct(productId: String, onSuccess: @escaping (Product?) -> Void, onError: ErrorClosure?) {
        Managers.managerProductFirestore?.selectProductById(productId: productId, onSuccess: { product in
            DispatchQueue.main.async {
                onSuccess(product)
            }
            
        }, onError: { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
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
