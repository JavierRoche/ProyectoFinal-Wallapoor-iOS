//
//  ProfileViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol ProfileViewModelDelegate: class {
    func imageViewModelsCreated()
}

class ProfileViewModel {
    weak var delegate: ProfileViewModelDelegate?

    func viewWasLoaded() {
        
    }
}
