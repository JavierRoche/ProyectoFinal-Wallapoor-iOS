//
//  MainViewController+Source.swift
//  Wallapobre
//
//  Created by APPLE on 18/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit


// MARK: UICollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let detailProductViewModel: DetailProductViewModel = DetailProductViewModel.init(product: viewModel.getProductViewModel(at: indexPath).product)
        let detailProductViewController: DetailProductViewController = DetailProductViewController.init(viewModel: detailProductViewModel)
        detailProductViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: detailProductViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}


// MARK: UICollectionView DataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfProducts(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as? ProductCell else { fatalError() }
        
        let productViewModel: ProductCellViewModel = self.viewModel.getProductViewModel(at: indexPath)
        
        cell.configureCell(viewModel: productViewModel)
        //cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        //collectionView.collectionViewLayout.invalidateLayout()
        return cell
    }
}


// MARK: UICollectionViewLayout Delegate

extension MainViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        //var totalHeight: CGFloat = 0
        //totalHeight += viewModel.getCellViewModel(at: indexPath).productImage.image?.size.height ?? 0
        //totalHeight += viewModel.getCellViewModel(at: indexPath).price.boun
        //return viewModel.getCellViewModel(at: indexPath).productImage.size.height
        return 180
    }
}