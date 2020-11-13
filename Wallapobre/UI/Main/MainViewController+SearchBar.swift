//
//  MainViewController+SearchBar.swift
//  Wallapobre
//
//  Created by APPLE on 08/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit


// MARK: UISearchControll / UISearchBar Delegate

extension MainViewController: UISearchBarDelegate  {
    /// Funcion delegada de UISearchBar para controlar el click en Enter o Buscar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text: String = self.searchController.searchBar.text?.lowercased() else { return }
        if text != "" {
            print("Buscar: \(text)")
            /// Bloqueamos el uso del searchController y resto de la pantalla para la busqueda actual
            searchController.searchBar.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = false
            /// Iniciamos la animacion de waiting
            self.activityIndicator.center = self.view.center
            self.activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
                
            /// TODO
        }
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        /// Presentamos el modal con las opciones de filtrado
        let filtersViewModel: FiltersViewModel = FiltersViewModel(filter: self.viewModel.actualFilter)
        let filtersViewController: FiltersViewController = FiltersViewController(viewModel: filtersViewModel)
        filtersViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: filtersViewController)
        navigationController.modalPresentationStyle = .formSheet
        navigationController.navigationBar.isHidden = true
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    /// Funcion delegada de UISearchBar para controlar el click en Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        /// Vaciamos la caja de busqueda porque un funcionamiento que no conozco rellama a searchBarTextDidEndEditing despues de searchBarCancelButtonClicked, y como haya algo escrito pues se pone a hacer la busqueda masiva
        self.searchController.searchBar.text = ""
    }
}
