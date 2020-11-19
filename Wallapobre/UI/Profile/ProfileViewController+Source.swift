//
//  ProfileViewController+Source.swift
//  Wallapobre
//
//  Created by APPLE on 17/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit


// MARK: UICollectionView Delegate

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailProductViewModel: DetailProductViewModel = DetailProductViewModel.init(product: viewModel.getCellViewModel(at: indexPath).product)
        let detailProductViewController: DetailProductViewController = DetailProductViewController.init(viewModel: detailProductViewModel)
        //detailProductViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: detailProductViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
        /// Presentamos el ViewController
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: UICollectionView DataSource

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as? ProductCell else { fatalError() }
        
        let productViewModel: ProductCellViewModel = self.viewModel.getCellViewModel(at: indexPath)
        
        cell.configureCell(viewModel: productViewModel)
        //cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        //collectionView.collectionViewLayout.invalidateLayout()
        return cell
    }
}


// MARK: UITableView Delegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /// Avisamos al MainViewController de la seleccion de una busqueda personal
        delegate?.searchSelected(search: self.viewModel.getRowViewModel(at: indexPath))
        
        /// Accedemos a la WindowScene de la App para la navegacion
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        /// Recuperamos el tabBarController y le indicamos el pop
        let tabBar = sceneDelegate.window?.rootViewController as? UITabBarController
        tabBar?.selectedIndex = 0
        tabBar?.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: UITableView DataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell, for: indexPath)
        cell.textLabel?.text = self.viewModel.getRowViewModel(at: indexPath).title
        return cell
    }
}
