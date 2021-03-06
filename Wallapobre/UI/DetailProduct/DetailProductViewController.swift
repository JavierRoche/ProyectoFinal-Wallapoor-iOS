//
//  DetailProductViewController.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol DetailProductViewControllerDelegate: class {
    func productDeleted()
}

class DetailProductViewController: UIViewController {
    lazy var tableView: UITableView = {
        let table: UITableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.register(ProductImagesCell.self, forCellReuseIdentifier: String(describing: ProductImagesCell.self))
        table.register(ProductDataCell.self, forCellReuseIdentifier: String(describing: ProductDataCell.self))
        table.register(ProductDataEditionCell.self, forCellReuseIdentifier: String(describing: ProductDataEditionCell.self))
        table.register(ProductMapCell.self, forCellReuseIdentifier: String(describing: ProductMapCell.self))
        table.register(ProductSellerCell.self, forCellReuseIdentifier: String(describing: ProductSellerCell.self))
        table.register(ProductSocialNetworksCell.self, forCellReuseIdentifier: String(describing: ProductSocialNetworksCell.self))
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30
        table.backgroundColor = UIColor.white
        table.separatorColor = UIColor.tangerine
        table.rowHeight = UITableView.automaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var footerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.tangerine.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var chatButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(Constants.chat, for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.tangerine
        button.layer.cornerRadius = 16.0
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnChat)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var deleteProductButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(Constants.deleteProduct, for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.tangerine
        button.layer.cornerRadius = 16.0
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnDelete)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    /// Objeto del modelo que contiene las imagenes
    let viewModel: DetailProductViewModel
    /// Delegado para comunicar el borrado correcto del producto a MainViewController
    weak var delegate: DetailProductViewControllerDelegate?
    
    
    // MARK: Inits
    
    init(viewModel: DetailProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = String()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: Life Cycle

    override func loadView() {
        setViewsHierarchy()
        setConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Recuperamos el vendedor del producto para configurar el detalle
        self.getSellerUser()
        /// Añadimos un viewer al producto
        self.addViewerToProduct()
    }
    
    
    // MARK: User Interactors
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapOnModify() {
        let newProductViewModel: NewProductViewModel = NewProductViewModel(product: self.viewModel.product)
        let newProductViewController: NewProductViewController = NewProductViewController(viewModel: newProductViewModel)
        newProductViewController.modificationDelegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: newProductViewController)
        navigationController.modalPresentationStyle = .automatic
        
        /// Presentamos el ViewController
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func tapOnChat() {
        let chatViewModel: ChatViewModel = ChatViewModel.init(product: viewModel.product)
        let chatViewController: ChatViewController = ChatViewController()
        chatViewController.viewModel = chatViewModel
        //detailProductViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: chatViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func tapOnDelete() {
        self.showAlert(forInput: false, onlyAccept: false, title: Constants.deleteProduct, message: Constants.goingToDelete) { [weak self] _ in
            /// Borramos el producto de la base de datos de Firestore
            self?.viewModel.deleteProduct(onSuccess: {
                /// Cerramos la ventana de detalle
                self?.navigationController?.popViewController(animated: true)
                /// Informamos al MainViewController para que notifique al usuario
                self?.delegate?.productDeleted()
                    
            }, onError: { error in
                self?.showAlert(title: Constants.error, message: error.localizedDescription)
            })
        }
    }
    
    
    // MARK: Private Functions
    
    fileprivate func getSellerUser() {
        /// Arrancamos el manager y recuperamos el vendedor del producto
        Managers.managerUserFirestore = UserFirestore()
        self.viewModel.getSellerData(onSuccess: { [weak self] user in
            guard let _ = user else {
                self?.showAlert(title: Constants.error, message: Constants.missingSeller) { _ in
                    self?.dismiss(animated: true, completion: nil)
                }
                return
            }
            
            /// Necesitamos el seller para configurar correctamente
            self?.configureUI()
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }) { [weak self] error in
            self?.showAlert(title: Constants.error, message: error.localizedDescription) { _ in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func configureUI() {
        self.navigationController?.navigationBar.tintColor = UIColor.tangerine
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        /// Saldra la opcion de modificar si el producto es del usuario y NO esta vendido
        if self.viewModel.seller?.sender.senderId == MainViewModel.user.sender.senderId && self.viewModel.product.state != .sold {
            let modifyRightBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.modify, style: .plain, target: self, action: #selector(tapOnModify))
            modifyRightBarButtonItem.tintColor = UIColor.tangerine
            navigationItem.rightBarButtonItem = modifyRightBarButtonItem
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17SemiBold], for: .normal)
        }
        
        /// Saldra la opcion de borrar y no chatear si el producto es del usuario
        if self.viewModel.seller?.sender.senderId == MainViewModel.user.sender.senderId {
            chatButton.isHidden = true
            deleteProductButton.isHidden = false
            
        } else {
            chatButton.isHidden = false
            deleteProductButton.isHidden = true
        }
    }
    
    fileprivate func addViewerToProduct() {
        /// Añadimos un viewer al producto y lanzamos la modificacion
        self.viewModel.product.viewers += 1
        self.viewModel.modifyProduct(product: self.viewModel.product)
    }
}


// MARK: ProductImagesCell Delegate

extension DetailProductViewController: ProductImagesCellDelegate {
    func tapOnImageSlider() {
        let fullScreenController = FullScreenSlideshowViewController()
        fullScreenController.inputs = viewModel.urls
        fullScreenController.initialPage = 0
        fullScreenController.modalPresentationStyle = .custom
        
        /// Recuperamos la vista que necesitamos para poder pasarsela al zoom animado
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? ProductImagesCell {   // MARK: ESTO ES SENCILLAMENTE LA POLLA
            let slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: cell.imageSlide, slideshowController: fullScreenController)
            fullScreenController.modalPresentationStyle = .custom
            fullScreenController.transitioningDelegate = slideshowTransitioningDelegate
            self.present(fullScreenController, animated: true, completion: nil)
        }
    }
}


// MARK: ModifyProductViewController Delegate

extension DetailProductViewController: ModifyProductViewControllerDelegate {
    func productModified() {
        self.showAlert(title: Constants.info, message: Constants.productUpdated) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
