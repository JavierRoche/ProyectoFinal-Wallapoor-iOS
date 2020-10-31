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

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MainCell", bundle: nil), forCellWithReuseIdentifier: "MainCell")
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let search: UISearchController = UISearchController()
        search.searchBar.searchTextField.clearButtonMode = .never
        search.searchBar.showsBookmarkButton = true
        search.searchBar.setImage(UIImage.init(systemName: "tag"), for: .bookmark, state: .normal)
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
        view = UIView()
        view.backgroundColor = .white

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6.0)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewWasLoaded()
        
        /// Configuramos la interface y cargamos las fotos en el CollectionView
        self.configureUI()
    }
    
    
    // MARK: Functions
    
    fileprivate func configureUI() {
        /// Asignacion del UISearchController y atributos del navigationController
        self.navigationItem.searchController = searchController
        /// Creacion del boton de menu para abrir el menu desplaegable lateral
        /*let menu: UIBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuTapped))
        self.navigationItem.searchController?.toolbarItems?.append(menu)*/
        
    }
    
    @objc func menuTapped() {
        // TODO
    }
    
    @objc func uploadProduct() {
        // TODO
    }
}


// MARK: ViewModel Delegate

extension MainViewController: MainViewModelDelegate {
    func mainViewModelsCreated() {
        collectionView.reloadData()
    }
}


// MARK: FilterViewController Delegate

extension MainViewController: FiltersDelegate {
    func filterCreated(filter: Filter) {
        print("filterCreated")
        // TODO : Aplicar filtro
    }
}



// MARK: UICollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
    // TODO: Clic en elemento del colection
}


// MARK: UICollectionView DataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as? MainCell else { fatalError() }
        cell.viewModel = viewModel.viewModel(at: indexPath)
        return cell
    }
}


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
        print("searchBarBookmarkButtonClicked")
        /// Presentamos el modal con las opciones de filtrado
        let viewModel = FiltersViewModel()
        let filtersViewController: FiltersViewController = FiltersViewController(viewModel: viewModel)
        filtersViewController.delegate = self
        
        TabBarProvider.navigation?.modalPresentationStyle = .formSheet
        TabBarProvider.navigation?.navigationBar.isHidden = true
        
        self.present(filtersViewController, animated: true, completion: nil)
    }
    
    /// Funcion delegada de UISearchBar para controlar el click en Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        /// Vaciamos la caja de busqueda porque un funcionamiento que no conozco rellama a searchBarTextDidEndEditing despues de searchBarCancelButtonClicked, y como haya algo escrito pues se pone a hacer la busqueda masiva
        self.searchController.searchBar.text = ""
    }
}


// MARK: UICollectionViewLayout Delegate

extension MainViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.viewModel(at: indexPath).image.size.height
    }
}
