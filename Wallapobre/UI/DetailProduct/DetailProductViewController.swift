//
//  DetailProductViewController.swift
//  Wallapobre
//
//  Created by APPLE on 09/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import ImageSlideshow

class DetailProductViewController: UIViewController {
    lazy var tableView: UITableView = {
        let table: UITableView = UITableView(frame: .zero, style: .grouped)
        table.register(ProductImagesCell.self, forCellReuseIdentifier: String(describing: ProductImagesCell.self))
        table.register(ProductDataCell.self, forCellReuseIdentifier: String(describing: ProductDataCell.self))
        table.register(ProductMapCell.self, forCellReuseIdentifier: String(describing: ProductMapCell.self))
        table.register(ProductSellerCell.self, forCellReuseIdentifier: String(describing: ProductSellerCell.self))
        table.register(ProductSocialNetworksCell.self, forCellReuseIdentifier: String(describing: ProductSocialNetworksCell.self))
        table.dataSource = self
        table.delegate = self
        table.estimatedRowHeight = 30
        table.rowHeight = UITableView.automaticDimension
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var footerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var chatButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Chat", for: .normal)
        button.tintColor = UIColor.black
        button.backgroundColor = UIColor.cyan
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnChat)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    /// Objeto del modelo que contiene las imagenes
    let viewModel: DetailProductViewModel
    
    
    // MARK: Inits
    
    init(viewModel: DetailProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        
        /// Arrancamos el manager y recuperamos el vendedor del producto
        Managers.managerUserFirestore = UserFirestore()
        self.viewModel.getSellerData(viewModel: viewModel, onSuccess: { user in
            guard let _ = user else {
                self.showAlert(title: "Error", message: "Missing seller")
                self.dismiss(animated: true, completion: nil)
                return
            }
            self.tableView.reloadData()
            
        }) { (error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Managers.managerUserFirestore = nil
    }
    
    
    // MARK: User Interactors
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
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
    
    
    // MARK: Private Functions
    
    fileprivate func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(tableView)
        view.addSubview(footerView)
        view.addSubview(chatButton)
        
        /// Boton superior para salir del chat
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.alpha = 0.4
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            //footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        NSLayoutConstraint.activate([
            chatButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16.0),
            chatButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16.0),
            chatButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16.0),
            chatButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16.0)
        ])
    }
}


// MARK: ProductImagesCell Delegate

extension DetailProductViewController: ProductImagesCellDelegate {
    func tapOnImageSlider() {
        let fullScreenController = FullScreenSlideshowViewController()
        fullScreenController.inputs = viewModel.urls
        fullScreenController.initialPage = 0
        fullScreenController.modalPresentationStyle = .custom
        
        /// Recuperamos el la vista que necesitamos para poder pasarsela al zoom animado
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? ProductImagesCell {   // MARK: ESTO ES SENCILLAMENTE LA POLLA
            let slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: cell.imageSlide, slideshowController: fullScreenController)
            fullScreenController.modalPresentationStyle = .custom
            fullScreenController.transitioningDelegate = slideshowTransitioningDelegate
            present(fullScreenController, animated: true, completion: nil)
        }
    }
}
