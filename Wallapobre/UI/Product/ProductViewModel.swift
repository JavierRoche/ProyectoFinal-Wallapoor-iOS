//
//  ProductViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol ProductViewModelDelegate: class {
    func mainViewModelsCreated()
}

class ProductViewModel {
    weak var delegate: ProductViewModelDelegate?
    /// Objeto que maneja el modelo
    //var product: Product
    
    
    // MARK: Public Functions
    
    func viewWasLoaded() {
        
    }
}

