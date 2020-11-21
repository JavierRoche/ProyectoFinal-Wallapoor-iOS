//
//  ChatViewController.swift
//  Wallapobre
//
//  Created by APPLE on 11/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    /// Objeto con el que acceder al manager de Productos
    var viewModel: ChatViewModel!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        guard let _ = viewModel else { return }
        
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        self.configureUI()
        self.fetchMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Managers.managerDiscussionFirestore = nil
        Managers.managerMessageFirestore = nil
    }
    
    
    // MARK: User Interactions
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func runTransaction() {
        /// Pedimos confirmacion al vendedor y lanzamos la transaccion
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(forInput: false, onlyAccept: false, title: Constants.SellProduct, message: Constants.GoingToSell) { _ in
                
                /// Creamos la escena con el modelo de Filter del ultimo Filter almacenado
                let sellingViewModel: SellingViewModel = SellingViewModel()
                let sellingViewController: SellingViewController = SellingViewController(viewModel: sellingViewModel)
                sellingViewController.delegate = self
                let navigationController: UINavigationController = UINavigationController.init(rootViewController: sellingViewController)
                navigationController.modalPresentationStyle = .formSheet
                navigationController.navigationBar.isHidden = true
                
                /// Presentamos el modal con las ultimas opciones de filtrado almacenadas
                self?.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: Private Functions
    
    fileprivate func configureUI() {
        /// Definicion del boton back
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.arrowIcon), style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        /// Definicion del boton enviar mensaje
        let newMessageInputBar = MessageInputBar()
        newMessageInputBar.sendButton.tintColor = UIColor.black
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar
        reloadInputViews()
        
        /// Definicion del boton de aceptar trato
        let inputBarButtonDeal: InputBarButtonItem = InputBarButtonItem()
        inputBarButtonDeal.configure { item in
            item.spacing = .fixed(10)
            item.image = UIImage(named: Constants.Deal) //?.withRenderingMode(.alwaysTemplate)
            item.setSize(CGSize(width: 80, height: 80), animated: true)
            item.onSelected { _ in
                item.tintColor = UIColor.gray
                self.runTransaction()
            }
            item.onDeselected { _ in
                item.tintColor = UIColor.lightGray
            }
        }
        /// Añadimos los botones creados a la InputBar
        messageInputBar.setStackViewItems([inputBarButtonDeal], forStack: .bottom, animated: true)
    }
    
    fileprivate func confirmPurchase() {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: Constants.Success, message: Constants.PurchaseCompleted)
        }
    }
}


// MARK: SellingViewController Delegate

extension ChatViewController: SellingViewControllerDelegate {
    func buyerSelected(buyer: User) {
        guard let product: Product = self.viewModel.product else { return }
        product.state = .sold
        
        /// Modificamos el estado del producto selling a sold
        self.viewModel.modifyProduct(product: product, onSuccess: {
            
            /// Añadimos una venta al vendedor
            MainViewModel.user.sales += 1
            self.viewModel.updateUser(user: MainViewModel.user, onSuccess: {
                
                /// Añadimos la compra al comprador
                buyer.shopping += 1
                self.viewModel.updateUser(user: buyer, onSuccess: {
                    self.confirmPurchase()
                    
                }, onError: { error in
                    self.showAlert(title: Constants.Error, message: error.localizedDescription) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            }, onError: { error in
                self.showAlert(title: Constants.Error, message: error.localizedDescription) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }, onError: { error in
            self.showAlert(title: Constants.Error, message: error.localizedDescription) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
