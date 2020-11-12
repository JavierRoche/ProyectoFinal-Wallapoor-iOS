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
        search.searchBar.setImage(UIImage.init(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
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
        button.setTitle("+", for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = UIColor.black
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector (tapOnNewProduct), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// Objeto del modelo que contiene las imagenes
    let viewModel: MainViewModel
    var productList: [Product] = [Product]()
    
    
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
        view.addSubview(newProductButton)
        view.bringSubviewToFront(newProductButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -6.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6.0)
        ])
        
        NSLayoutConstraint.activate([
            newProductButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newProductButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            newProductButton.widthAnchor.constraint(equalToConstant: 64.0),
            newProductButton.heightAnchor.constraint(equalToConstant: 64.0)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Managers.managerProductFirestore = ProductFirestore()
        
        self.viewModel.delegate = self
        self.viewModel.viewWasLoaded()
        
        /// Configuramos la interface y cargamos las fotos en el CollectionView
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newProductButton.layer.cornerRadius = newProductButton.frame.size.height / 2
    }
    
    
    // MARK: Functions
    
    fileprivate func configureUI() {
        /// Asignacion del UISearchController
        self.navigationItem.searchController = searchController
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
}


// MARK: UICollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailProductViewModel: DetailProductViewModel = DetailProductViewModel.init(product: productList[indexPath.row])
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else { fatalError() }
        
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


// MARK: ViewModel Delegate

extension MainViewController: MainViewModelDelegate {
    func productListCreated(productList: [Product]) {
        self.productList = productList
        collectionView.reloadData()
    }
    
    func productCellViewModelsCreated() {
        collectionView.reloadData()
    }
}


// MARK: FilterViewController Delegate

extension MainViewController: FiltersViewControllerDelegate {
    func filterCreated(filter: Filter) {
        print("filterCreated")
        let initialFilter = Filter()
        if filter != initialFilter {
            // Abrir Controller con lista filtrada
        }
    }
}


// MARK: ProductViewController Delegate

extension MainViewController: ProductViewControllerDelegate {
    func productAdded() {
        showAlert(title: "Info", message: "Product uploaded")
    }
}
