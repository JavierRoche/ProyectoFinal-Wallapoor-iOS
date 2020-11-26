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

protocol ChatViewControllerDelegate: class {
    func purchaseCompleted()
}

class ChatViewController: MessagesViewController {
    /// Objeto con el que acceder al manager de Productos
    var viewModel: ChatViewModel!
    /// Delegado para comunicar el borrado correcto del producto a MainViewController
    weak var delegate: ChatViewControllerDelegate?
    
    
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
    
    fileprivate func sellingProcess() {
        /// Creamos la escena con el modelo de Filter del ultimo Filter almacenado
        let sellingViewModel: SellingViewModel = SellingViewModel()
        let sellingViewController: SellingViewController = SellingViewController(viewModel: sellingViewModel)
        sellingViewController.delegate = self
        self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(sellingViewController, animated: true, completion: nil)
    }
    
    
    // MARK: Private Functions
    
    fileprivate func configureUI() {
        /// Definicion del boton back
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Constants.iconChevronLeft), style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        /// Definicion del boton enviar mensaje
        let newMessageInputBar = MessageInputBar()
        newMessageInputBar.sendButton.setTitleColor(UIColor.tangerine, for: .normal)
        newMessageInputBar.sendButton.setTitleColor(UIColor.lightTangerine, for: .highlighted)
        newMessageInputBar.separatorLine.tintColor = UIColor.tangerine
        newMessageInputBar.tintColor = UIColor.tangerine
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar
        reloadInputViews()
        
        /// Definicion del boton de aceptar trato si el user es el dueño del producto
        if viewModel.product.seller == MainViewModel.user.sender.senderId {
            let inputBarButtonDeal: InputBarButtonItem = InputBarButtonItem()
            inputBarButtonDeal.configure { item in
                item.spacing = .fixed(10)
                if viewModel.product.state == .sold { item.isEnabled = false }
                item.image = UIImage(named: Constants.iconDeal)
                item.setSize(CGSize(width: 60, height: 60), animated: true)
                item.onSelected { _ in
                    item.tintColor = UIColor.gray
                    self.sellingProcess()
                }
                item.onDeselected { _ in
                    item.tintColor = UIColor.lightGray
                }
            }
            /// Añadimos los botones creados a la InputBar
            messageInputBar.setStackViewItems([inputBarButtonDeal], forStack: .bottom, animated: true)
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
                    self.delegate?.purchaseCompleted()
                    self.showAlert(title: Constants.success, message: Constants.purchaseCompleted) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }, onError: { error in
                    self.dismiss(animated: true, completion: nil)
                })
                
            }, onError: { error in
                self.showAlert(title: Constants.error, message: error.localizedDescription) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }, onError: { error in
            self.showAlert(title: Constants.error, message: error.localizedDescription) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
