//
//  MainViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol MainViewModelDelegate: class {
    func mainViewModelsCreated()
}

class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    var mainCellViewModels: [MainCellViewModel] = []

    func viewWasLoaded() {
        for index in stride(from: 1, to: 19, by: 1) {
            guard let image = UIImage(named: "\(index)") else { continue }
            mainCellViewModels.append(MainCellViewModel(image: image))
        }

        delegate?.mainViewModelsCreated()
    }

    func numberOfItems(in section: Int) -> Int {
        return mainCellViewModels.count
    }

    func viewModel(at indexPath: IndexPath) -> MainCellViewModel {
        return mainCellViewModels[indexPath.row]
    }
}
