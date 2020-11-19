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
        self.activateActivityIndicator()
        
        /// Damos al modelo via libre para cargarse
        self.viewModel.delegate = self
        self.viewModel.viewWasLoaded()
        
        /// Asignacion del UISearchController
        self.navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newProductButton.layer.cornerRadius = newProductButton.frame.size.height / 2
        saveSearchButton.layer.cornerRadius = saveSearchButton.frame.size.height / 2
        self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    
    // MARK: User Interactions
    
    @objc func tapOnNewProduct(sender: UIButton!) {
        let newProductViewModel: NewProductViewModel = NewProductViewModel(product: nil)
        let newProductViewController: NewProductViewController = NewProductViewController(viewModel: newProductViewModel)
        newProductViewController.creationDelegate = self
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
                let actualSearch: Search = Search.init(searcher: MainViewModel.user.sender.senderId, title: text, filter: self?.viewModel.getActualFilter() ?? Filter())
                
                /// Guardamos la Search en Firestore
                self?.viewModel.insertSearch(search: actualSearch, onSuccess: {
                    self?.showAlert(forInput: false, onlyAccept: true, title: Constants.Success, message: Constants.PersonalSearchSaved)
                    
                }, onError: { error in
                    self?.showAlert(title: Constants.Error, message: error.localizedDescription)
                })
            }
        }
    }
    
    
    // MARK: Private Functions
    
    fileprivate func activateActivityIndicator() {
        activityIndicator.center = self.view.center
        view.addSubview(self.activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        searchController.searchBar.isUserInteractionEnabled = false
    }
    
    fileprivate func deactivateActivityIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
        searchController.searchBar.isUserInteractionEnabled = true
    }
}


// MARK: MainViewModel Delegate

extension MainViewController: MainViewModelDelegate {
    func productCellViewModelsCreated() {
        /// Paramos el indicador de actividad y recargamos el collection
        self.deactivateActivityIndicator()
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func filterApplied() {
        /// Si el texto del filtro no esta vacio es que venimos de la lista de busquedas personales en Profile
        if !self.viewModel.getActualFilter().text.isEmpty {
            /// Bloqueamos el uso del searchController y resto de la pantalla para la busqueda actual
            self.activateActivityIndicator()
            self.viewModel.filterByText(text: viewModel.getActualFilter().text)
        }
        
        /// Paramos la animacion y liberamos el uso del searchController y del resto de la interface
        self.deactivateActivityIndicator()
        
        /// Ofrecemos guardar la busquedea tras un filtrado
        saveSearchButton.isHidden = self.viewModel.showUpSaveSearchButton()
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}


// MARK: FilterViewController Delegate

extension MainViewController: FiltersViewControllerDelegate {
    func newFilterCreated(filter: Filter) {
        self.viewModel.applyFilter(filter: filter)
    }
}


// MARK: ProductViewController Delegate

extension MainViewController: NewProductViewControllerDelegate {
    func productAdded() {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: Constants.Info, message: Constants.ProductUploaded)
        }
    }
}


// MARK: ProfileViewController Delegate

extension MainViewController: ProfileViewControllerDelegate {
    func searchSelected(search: Search) {
        /// Primero se aplica la parte del filtro correspondiente a categorias y distancia
        /// Al volver de applyFilter(), en filterApplied(), si hay algo en el texto del filtro tenemos que aplicarlo tambien
        self.viewModel.applyFilter(filter: search.filter)
    }
}
