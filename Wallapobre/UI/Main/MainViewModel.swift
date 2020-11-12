//
//  MainViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol MainViewModelDelegate: class {
    func productCellViewModelsCreated()
    func productListCreated(productList: [Product])
}

class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    var originalProductList: [ProductCellViewModel] = []

    func viewWasLoaded() {
        //var count: Int = 0
        
        Managers.managerProductFirestore!.selectProducts(onSuccess: { [weak self] products in
            /// Recibimos los productos recuperados por la busqueda inicial
            self?.originalProductList = products.compactMap({ ProductCellViewModel(product: $0) })
            
            
            
            self?.delegate?.productCellViewModelsCreated()
            
            
            
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
}
