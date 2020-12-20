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
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let detailProductViewModel: DetailProductViewModel = DetailProductViewModel.init(product: viewModel.getCellViewModel(at: indexPath).product)
        let detailProductViewController: DetailProductViewController = DetailProductViewController.init(viewModel: detailProductViewModel)
        
        /// Presentamos el ViewController
        self.navigationController?.pushViewController(detailProductViewController, animated: true)
    }
}


// MARK: UICollectionView DataSource

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as? ProductCell else { fatalError() }
        cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
}


// MARK: UITableView Delegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch tableView {
        case searchesTableView:
            /// Avisamos al MainViewController de la seleccion de una busqueda personal
            delegate?.searchSelected(search: self.viewModel.getSearchViewModel(at: indexPath))
            
            /// Accedemos a la WindowScene de la App para la navegacion
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
            
            /// Recuperamos el tabBarController y le indicamos el pop
            let tabBar = sceneDelegate.window?.rootViewController as? UITabBarController
            tabBar?.selectedIndex = 0
            tabBar?.navigationController?.popToRootViewController(animated: true)
            
        case discussionsTableView:
            /// Lanzamos la ventana de chat
            let chatViewModel: ChatViewModel = ChatViewModel.init(discussion: viewModel.getDiscussionViewModel(at: indexPath).discussion, product: viewModel.getDiscussionViewModel(at: indexPath).product)
            let chatViewController: ChatViewController = ChatViewController()
            chatViewController.viewModel = chatViewModel
            //detailProductViewController.delegate = self
            let navigationController: UINavigationController = UINavigationController.init(rootViewController: chatViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
            
        default:
            break
        }
    }
}

// MARK: UITableView DataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case searchesTableView:
            return self.viewModel.numberOfSearches(in: section)
            
        case discussionsTableView:
            return self.viewModel.numberOfDiscussions(in: section)
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case searchesTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath)
            cell.textLabel?.text = self.viewModel.getSearchViewModel(at: indexPath).title
            return cell
            
        case discussionsTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DiscussionCell.self), for: indexPath) as? DiscussionCell else { fatalError() }
            cell.viewModel = self.viewModel.getDiscussionViewModel(at: indexPath)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}


// MARK: UICollectionViewLayout Delegate

extension ProfileViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.viewModel.getCellViewModel(at: indexPath).product.heightMainphoto)
    }
}
