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
        
        let detailProductViewModel = DetailProductViewModel.init(product: viewModel.getCellViewModel(at: indexPath).product)
        let detailProductViewController = DetailProductViewController.init(viewModel: detailProductViewModel)
        detailProductViewController.delegate = self
        self.navigationController?.pushViewController(detailProductViewController, animated: true)
        /*
        
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: detailProductViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)*/
    }
}


// MARK: UICollectionView DataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as? ProductCell else { fatalError() }
        cell.viewModel = self.viewModel.getCellViewModel(at: indexPath)
        return cell
    }
}


// MARK: UICollectionViewLayout Delegate

extension MainViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.viewModel.getCellViewModel(at: indexPath).product.heightMainphoto)
    }
}
