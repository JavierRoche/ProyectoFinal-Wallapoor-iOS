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
    func filterApplied()
}

class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    /// Lista original con todos los productos descargados de Firebase DB
    private var originalProductList: [ProductCellViewModel] = []
    /// Es la foto tras volver de la scena de seleccion de filtros
    private var auxiliarProductList: [ProductCellViewModel] = []
    /// Es la lista de la que tira el Collection View principal
    private var actualProductList: [ProductCellViewModel] = []
    private var originalFilter: Filter = Filter()
    private var actualFilter: Filter = Filter()

    
    // MARK: Public Functions
    
    func viewWasLoaded() {
        Managers.managerProductFirestore = ProductFirestore()
        
        Managers.managerProductFirestore!.selectProducts(onSuccess: { [weak self] products in
            /// Habria que aplicar antes el filtro antes de mapear, pero todas las funciones del modelo funcionan con ProductCellViewModel asi que...
            /// Mapeamos los productos del area inicial al modelo de celda
            let productCellViewModels = products.compactMap({ ProductCellViewModel(product: $0) })
            /// Aplicamos el filtro de distancia a la lista original descargada
            self?.filterByDistance(productCellViewModels: productCellViewModels, onSuccess: { productCellViewModels in
                self?.originalProductList = productCellViewModels
                self?.updateSituation(initialSituation: true, productCellViewModels: productCellViewModels)
                
                /*self?.actualProductList = productCellViewModels
                
                /// Avisamos al controlador de que el modelo de datos se ha creado
                self?.delegate?.productCellViewModelsCreated()*/
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
        return actualProductList.count
    }

    func getCellViewModel(at indexPath: IndexPath) -> ProductCellViewModel {
        return actualProductList[indexPath.row]
    }
    
    func showUpSaveSearchButton() -> Bool {
        return self.actualFilter == self.originalFilter
    }
    
    func getActualFilter() -> Filter {
        return self.actualFilter
    }
    
    func applyFilter(filter: Filter) {
        var productCellViewModels: [ProductCellViewModel] = self.originalProductList
        
        if !filter.motor { productCellViewModels = filterByCategory(productCellViewModels: productCellViewModels, category: Category.motor) }
        if !filter.textile { productCellViewModels = filterByCategory(productCellViewModels: productCellViewModels, category: Category.textile) }
        if !filter.homes { productCellViewModels = filterByCategory(productCellViewModels: productCellViewModels, category: Category.homes) }
        if !filter.informatic { productCellViewModels = filterByCategory(productCellViewModels: productCellViewModels, category: Category.informatic) }
        if !filter.sports { productCellViewModels = filterByCategory(productCellViewModels: productCellViewModels, category: Category.sports) }
        if !filter.services { productCellViewModels = filterByCategory(productCellViewModels: productCellViewModels, category: Category.services) }
        /// Podemos llegar aqui con la lista ya vacia
        if filter.distance != 50.0 && !productCellViewModels.isEmpty {
            /// Aplicamos el filtro de distancia a la lista original descargada
            self.filterByDistance(productCellViewModels: productCellViewModels, toDistance: Double(filter.distance * 1000.0), onSuccess: { [weak self] productCellViewModels in
                self?.updateSituation(initialSituation: false, productCellViewModels: productCellViewModels, filter: filter)
            })
            
        } else {
            self.updateSituation(initialSituation: false, productCellViewModels: productCellViewModels, filter: filter)
        }
    }
    
    func filterByText(text: String){
        var filteredProductList: [ProductCellViewModel] = []
        /// Por cada producto comprobamos si su title contiene la cadena buscada
        filteredProductList = self.auxiliarProductList.compactMap { productCellViewModel in
            if productCellViewModel.product.title.lowercased().contains(text) {
                return productCellViewModel
            }
            return nil
        }
        
        /// Para no cargarme la que tiene el filtro principal
        //self.auxiliarProductList = self.actualProductList
        self.actualProductList = filteredProductList
        /// Tambien tenemos que actualizar el filtro actual
        self.actualFilter.text = text
    }
    
    func cancelFilterByText() {
        self.actualProductList = self.auxiliarProductList
        self.actualFilter.text = String()
    }
    
    
    
    func insertSearch(search: Search, onSuccess: @escaping () -> Void, onError: ErrorClosure?) {
        Managers.managerSearchFirestore = SearchFirestore()
        Managers.managerSearchFirestore!.insertSearch(search: search, onSuccess: {
            onSuccess()
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    // MARK: Private Functions
    
    fileprivate func filterByCategory(productCellViewModels: [ProductCellViewModel], category: Category) -> [ProductCellViewModel] {
        var filteredProductList: [ProductCellViewModel] = []
        filteredProductList = productCellViewModels.compactMap { productCellViewModel in
            if productCellViewModel.product.category.rawValue != category.rawValue {
                return productCellViewModel
            }
            return nil
        }
        return filteredProductList
    }
    
    //comprueba de cada producto la distancia con el usuario
    fileprivate func filterByDistance(productCellViewModels: [ProductCellViewModel], toDistance: Double = 50000.0, onSuccess: @escaping ([ProductCellViewModel]) -> Void) {
        /// Obtenemos la localizacion del usuario logueado
        let userLocation: CLLocation = CLLocation(latitude: Managers.managerUserLocation!.getUserLogged().latitude!, longitude: Managers.managerUserLocation!.getUserLogged().longitude!)
        
        /// Inicializamos valores para el algoritmo que buscara por cada usuario si esta en rango con el user logueado
        var filteredProductCellViewModels: [ProductCellViewModel] = [ProductCellViewModel]()
        var count: Int = 1
        
        for productCellViewModel in productCellViewModels {
            self.getSellerData(product: productCellViewModel.product, onSuccess: { user in
                /// Comprobamos que el usuario del producto se ha recuperado
                if let user = user {
                    /// Con locations del producto calculamos la distancia al usuario en metros y linea recta
                    let productLocation = CLLocation(latitude: user.latitude!, longitude: user.longitude!)
                    let distance = productLocation.distance(from: userLocation)
                    if distance <= toDistance {
                        filteredProductCellViewModels.append(productCellViewModel)
                    }
                    
                    if count == productCellViewModels.count {
                        onSuccess(filteredProductCellViewModels)
                    }
                    count += 1
                }
                
                /// El producto se ignora si ha habido error
            }, onError: { _ in })
        }
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
    
    fileprivate func updateSituation(initialSituation: Bool, productCellViewModels: [ProductCellViewModel], filter: Filter = Filter()) {
        /// Guardamos la foto tras volver de la seleccion de categorias
        self.auxiliarProductList = productCellViewModels
        /// Mapeamos los productos del area elegida en el filtro al modelo de celda
        self.actualProductList = productCellViewModels
        /// Actualizamos o inicializamos el filtro segun si viene informado
        self.actualFilter = filter
        
        /// Avisamos al controlador de que el modelo de datos se ha creado
        if initialSituation {
            self.originalFilter = filter
            self.delegate?.productCellViewModelsCreated()
            
        } else {
            self.delegate?.filterApplied()
        }
    }
}
