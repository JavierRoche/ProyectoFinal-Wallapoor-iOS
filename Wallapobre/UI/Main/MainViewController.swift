//
//  ViewController.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    lazy var pinterestLayout: PinterestLayout = {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        return pinterestLayout
    }()

    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = CGSize(width: 160.0, height: 160.0)
        layout.minimumInteritemSpacing = 16.0
        layout.sectionInset = UIEdgeInsets(top: 32.0, left: 32.0, bottom: 32.0, right: 32.0)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.gray
        collection.dataSource = self
        collection.delegate = self
        collection.register(ProductCell.self, forCellWithReuseIdentifier: String(describing: ProductCell.self))
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy var searchController: UISearchController = {
        let search: UISearchController = UISearchController()
        search.searchBar.searchTextField.clearButtonMode = .never
        search.searchBar.showsBookmarkButton = true
        search.searchBar.setImage(UIImage.init(systemName: Constants.filterIcon), for: .bookmark, state: .normal)
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.automaticallyShowsCancelButton = true
        return search
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.orange
        indicator.style = UIActivityIndicatorView.Style.large
        return indicator
    }()
    
    lazy var newProductButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle(Constants.plusIcon, for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = UIColor.black
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector (tapOnNewProduct), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var saveSearchButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: Constants.starIcon), for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = UIColor.yellow
        button.layer.masksToBounds = true
        button.isHidden = true
        button.addTarget(self, action: #selector (tapOnSaveSearch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Objeto del modelo que contiene las imagenes
    let viewModel: MainViewModel
    
    
    // MARK: Inits

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: Life Cycle

    override func loadView() {
        self.setViewsHierarchy()
        self.setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Iniciamos la animacion de actividad previa a la carga inicial
        self.activityIndicator.center = self.view.center
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
        self.view.isUserInteractionEnabled = false
        
        /// Damos al modelo via libre para cargarse
        self.viewModel.delegate = self
        self.viewModel.viewWasLoaded()
        
        /// Asignacion del UISearchController
        self.navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newProductButton.layer.cornerRadius = newProductButton.frame.size.height / 2
        saveSearchButton.layer.cornerRadius = saveSearchButton.frame.size.height / 2
    }
    
    
    // MARK: User Interactions
    
    @objc func tapOnNewProduct(sender: UIButton!) {
        let newProductViewModel: NewProductViewModel = NewProductViewModel()
        let newProductViewController: NewProductViewController = NewProductViewController(viewModel: newProductViewModel)
        newProductViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: newProductViewController)
        navigationController.modalPresentationStyle = .automatic
        
        /// Presentamos el ViewController
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func tapOnSaveSearch(sender: UIButton!) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(forInput: true, onlyAccept: false, title: Constants.SaveSearch, message: Constants.NameForPersonal, inputKeyboardType: UIKeyboardType.alphabet) { inputText in
                /// Nos aseguramos de que el usuario ha introducido un nombre
                guard let text = inputText else { return }
                /// Creamos la Search actual
                let actualSearch: Search = Search.init(searcher: MainViewModel.user.sender.senderId, title: text, filter: self!.viewModel.getActualFilter())
                
                /// Guardamos el producto en Firestore
                self?.viewModel.insertSearch(search: actualSearch, onSuccess: {
                    self?.showAlert(forInput: false, onlyAccept: true, title: Constants.Success, message: Constants.PersonalSearchSaved)
                    Managers.managerSearchFirestore = nil
                    
                }, onError: { error in
                    self?.showAlert(title: Constants.Error, message: error.localizedDescription)
                    Managers.managerSearchFirestore = nil
                })
            }
        }
    }
}


// MARK: UICollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
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

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as? ProductCell else { fatalError() }
        
        let productViewModel: ProductCellViewModel = self.viewModel.getCellViewModel(at: indexPath)
        
        cell.configureCell(imageUrl: productViewModel.product.photos[0],
                           price: productViewModel.product.price,
                           title: productViewModel.product.title)
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


// MARK: MainViewModel Delegate

extension MainViewController: MainViewModelDelegate {
    func productCellViewModelsCreated() {
        /// Paramos el indicador de actividad y recargamos el collection
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        collectionView.reloadData()
    }
    
    func filterApplied() {
        /// Paramos el indicador de actividad y recargamos el collection
        activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        collectionView.reloadData()
        
        /// Ofrecemos guardar la busquedea tras un filtrado
        saveSearchButton.isHidden = self.viewModel.showUpSaveSearchButton()
    }
}


// MARK: FilterViewController Delegate

extension MainViewController: FiltersViewControllerDelegate {
    func newFilterCreated(filter: Filter) {
        self.viewModel.applyFilter(filter: filter)
    }
}


// MARK: ProductViewController Delegate

extension MainViewController: ProductViewControllerDelegate {
    func productAdded() {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: Constants.Info, message: Constants.ProductUploaded)
        }
    }
}
