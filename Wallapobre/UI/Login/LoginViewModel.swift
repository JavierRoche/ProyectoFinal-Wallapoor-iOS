//
//  LoginViewMovel.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol LoginViewModelDelegate: class {
    func mainViewModelsCreated()
}

class LoginViewModel {
    weak var delegate: LoginViewModelDelegate?
    /// Objeto que maneja el modelo
    //var product: Product
    
    
    // MARK: Public Functions
    
    func openDataRegister() {
        
    }
}

