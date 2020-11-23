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
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - (layout.minimumInteritemSpacing * 3), height: 180.0)
        layout.minimumInteritemSpacing = 16.0
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
        collection.backgroundColor = UIColor.white
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
        let button: UIButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 48.0, height: 48.0))
        button.setImage(UIImage(systemName: Constants.plusIcon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)), for: .normal)
        button.layer.cornerRadius = button.frame.size.height / 2
        button.backgroundColor = UIColor.tangerine
        button.tintColor = UIColor.white
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector (tapOnNewProduct), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var saveSearchButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 48.0, height: 48.0))
        button.setImage(UIImage(systemName: Constants.starIcon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)), for: .normal)
        button.layer.cornerRadius = button.frame.size.height / 2
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor.tangerine
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.tangerine.cgColor
        button.layer.masksToBounds = true
        //button.isHidden = true
        button.addTarget(self, action: #selector (tapOnSaveSearch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    /// Objeto del modelo que contiene las imagenes
    let viewModel: MainViewModel
    
    
    // MARK: Inits

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: MainViewController.self), bundle: nil)
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
        /// Evitamos que al volver de otras pantallas sin NavigationBar, esta no aparezca
        self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    
    // MARK: User Interactions
    
    @objc private func tapOnNewProduct(sender: UIButton!) {
        let newProductViewModel: NewProductViewModel = NewProductViewModel(product: nil)
        let newProductViewController: NewProductViewController = NewProductViewController(viewModel: newProductViewModel)
        newProductViewController.creationDelegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: newProductViewController)
        navigationController.modalPresentationStyle = .automatic
        
        /// Presentamos el ViewController
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func tapOnSaveSearch(sender: UIButton!) {
        self.showAlert(forInput: true, onlyAccept: false, title: Constants.SaveSearch, message: Constants.NameForPersonal, inputKeyboardType: UIKeyboardType.alphabet) { inputText in
            /// Nos aseguramos de que el usuario ha introducido un nombre
            guard let text = inputText else { return }
            /// Creamos la Search actual
            let actualSearch: Search = Search.init(searcher: MainViewModel.user.sender.senderId, title: text, filter: self.viewModel.getActualFilter())
                
            /// Guardamos la Search en Firestore
            self.viewModel.insertSearch(search: actualSearch, onSuccess: {
                self.showAlert(title: Constants.Success, message: Constants.PersonalSearchSaved)
                    
            }, onError: { error in
                self.showAlert(title: Constants.Error, message: error.localizedDescription)
            })
        }
    }
    
    
    // MARK: Public Functions
    
    func activateActivityIndicator() {
        activityIndicator.center = self.view.center
        view.addSubview(self.activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        searchController.searchBar.isUserInteractionEnabled = false
    }
    
    func deactivateActivityIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
        searchController.searchBar.isUserInteractionEnabled = true
    }
    
    func saveButtonFadeIn() {
        let saveSearchButtonOriginalTransform = saveSearchButton.transform
        let newProductButtonOriginalTransform = newProductButton.transform
        let movement = (UIScreen.main.bounds.width / 2) - (newProductButton.bounds.size.width / 2)
        let saveSearchButtonTranslatedTransform = saveSearchButtonOriginalTransform.translatedBy(x: movement, y: 0.0)
        let newProductButtonTranslatedTransform = newProductButtonOriginalTransform.translatedBy(x: 24.0, y: 0.0)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.saveSearchButton.transform = saveSearchButtonTranslatedTransform
            self.newProductButton.transform = newProductButtonTranslatedTransform
        })
    }
    
    func saveButtonFadeOut() {
        let saveSearchButtonOriginalTransform = saveSearchButton.transform
        let newProductButtonOriginalTransform = newProductButton.transform
        let movement = (UIScreen.main.bounds.width / 2) - (newProductButton.bounds.size.width / 2)
        let saveSearchButtonTranslatedTransform = saveSearchButtonOriginalTransform.translatedBy(x: -movement, y: 0.0)
        let newProductButtonTranslatedTransform = newProductButtonOriginalTransform.translatedBy(x: -24.0, y: 0.0)
        
        UIView.animate(withDuration: 1.0, animations: {
            self.saveSearchButton.transform = saveSearchButtonTranslatedTransform
            self.newProductButton.transform = newProductButtonTranslatedTransform
        })
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
        if self.viewModel.showUpSaveSearchButton() {
            self.saveButtonFadeOut()
            
        } else {
            self.saveButtonFadeIn()
        }
        
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


// MARK: NewProductViewController Delegate

extension MainViewController: NewProductViewControllerDelegate {
    func productAdded() {
        self.showAlert(forInput: false, onlyAccept: true, title: Constants.Info, message: Constants.ProductUploaded, actionHandler: { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
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


// MARK: ProfileViewController Delegate

extension MainViewController: DetailProductViewControllerDelegate {
    func productDeleted() {
        self.showAlert(title: Constants.Info, message: Constants.ProductDeleted)
    }
}
