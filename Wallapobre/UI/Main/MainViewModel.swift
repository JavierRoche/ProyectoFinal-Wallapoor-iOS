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
        
        Managers.managerProductFirestore!.selectProducts(onSuccess: { [weak self] productList in
            self?.delegate?.productListCreated(productList: productList)
            /*for product in productList {
                
                guard let imageURL = URL(string: product.photos[0]) else { return }
                
                /// Comienza la ejecucion concurrente
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    /// La clase Data tiene un init con los contenidos de una URL
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    let image = UIImage(data: imageData)

                    DispatchQueue.main.async {
                        self?.originalProductList.append(ProductCellViewModel(product: product, image: image ?? UIImage(systemName: "camera.fill")!))
                        count += 1
                        if count == productList.count {
                            self?.delegate?.productCellViewModelsCreated()
                        }
                    }
                }
                
                //self.originalProductList.append(ProductCellViewModel(product: product))
            }*/
            
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
