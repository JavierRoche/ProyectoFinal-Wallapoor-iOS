//
//  ProfileViewController.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    /// Objeto del modelo que contiene el perfil del usuario
    let viewModel: ProfileViewModel
    
    
    // MARK: Inits

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
