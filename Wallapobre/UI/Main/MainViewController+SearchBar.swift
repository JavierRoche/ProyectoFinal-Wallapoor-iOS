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
    /// Funcion delegada de UISearchBar para controlar cada caracter introducido
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == Constants.newParagraph {
            searchBar.resignFirstResponder()
            return false
        }
        
        /// Aplicamos el filtro textual a la lista ACTUAL, NO a la original que tiene todo
        guard var storedText: String = self.searchController.searchBar.text?.lowercased() else { return false }
        /// Si ha pulsado DELETE quitamos un caracter al acumulado
        if text.count == 0 && range.length > 0 {
            storedText = String(storedText.dropLast())
        }
        
        if storedText.isEmpty && text.isEmpty {
            /// Volvemos a cargar todas las imagenes previas al filtrado textual
            self.viewModel.cancelFilterByText()
            
        } else {
            /// Lanzamos la busqueda con el texto acumulado mas lo pulsado
            self.viewModel.filterByText(text: (storedText + text).lowercased())
        }

        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
        /// Ofrecemos guardar la busquedea tras un filtrado
        self.coordinateSituation()
        
        return true
    }
    
    
    /// Funcion delegada de UISearchBar para controlar el click en Enter o Buscar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text: String = self.searchController.searchBar.text?.lowercased() else { return }
        if !text.isEmpty {
            /// Bloqueamos el uso del searchController y resto de la pantalla para la busqueda actual
            self.activateActivityIndicator()
                
            /// Aplicamos el filtro textual a la lista ACTUAL, NO a la original que tiene todo
            self.viewModel.filterByText(text: text)
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
            
            /// Ofrecemos guardar la busquedea tras un filtrado
            self.coordinateSituation()
            
            /// Paramos la animacion y liberamos el uso del searchController y del resto de la interface
            self.deactivateActivityIndicator()
        }
    }
    
    /// Funcion delegada para controlar el tap en la imagen de Bookmark
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        /// Creamos la escena con el modelo de Filter del ultimo Filter almacenado
        let filtersViewModel: FiltersViewModel = FiltersViewModel(filter: self.viewModel.getActualFilter())
        let filtersViewController: FiltersViewController = FiltersViewController(viewModel: filtersViewModel)
        filtersViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: filtersViewController)
        navigationController.modalPresentationStyle = .formSheet
        navigationController.navigationBar.isHidden = true
        
        /// Presentamos el modal con las ultimas opciones de filtrado almacenadas
        self.present(navigationController, animated: true, completion: nil)
    }
    
    /// Funcion delegada de UISearchBar para controlar el click en Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        /// Vaciar la caja de busqueda evita problemas
        self.searchController.searchBar.text = String()
        
        /// Volvemos a cargar todas las imagenes previas al filtrado textual
        self.viewModel.cancelFilterByText()
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
        /// Ofrecemos guardar la busquedea tras un filtrado
        self.coordinateSituation()
    }
}
