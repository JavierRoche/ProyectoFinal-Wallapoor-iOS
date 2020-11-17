//
//  ProfileViewController.swift
//  Wallapobre
//
//  Created by APPLE on 03/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerDelegate: class {
    func searchSelected(search: Search)
}

class ProfileViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var avatarImageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deleteAvatar)))
        image.image = UIImage(systemName: Constants.faceIcon)
        image.tintColor = UIColor.black
        image.backgroundColor = UIColor.purple
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shoppingSalesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segment: UISegmentedControl = UISegmentedControl()
        segment.backgroundColor = UIColor.tangerine
        segment.insertSegment(withTitle: Constants.Selling, at: 0, animated: true)
        segment.insertSegment(withTitle: Constants.Sold, at: 1, animated: true)
        segment.insertSegment(withTitle: Constants.Searches, at: 2, animated: true)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 5.0
        segment.addTarget(self, action: #selector(changeSegment), for: UIControl.Event.valueChanged)
        return segment
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
        collection.backgroundColor = UIColor.red
        collection.dataSource = self
        collection.delegate = self
        collection.register(ProductCell.self, forCellWithReuseIdentifier: String(describing: ProductCell.self))
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.isHidden = true
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Cell)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    weak var delegate: ProfileViewControllerDelegate?
    /// Objeto del modelo que contiene el perfil del usuario
    let viewModel: ProfileViewModel
    
    
    // MARK: Inits

    init(viewModel: ProfileViewModel) {
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
        
        self.viewModel.delegate = self
        self.viewModel.viewWasLoaded()
        
        /// Configuramos la interface y cargamos las fotos en el CollectionView
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //newProductButton.layer.cornerRadius = newProductButton.frame.size.height / 2
        //saveSearchButton.layer.cornerRadius = saveSearchButton.frame.size.height / 2
        
        segmentControl.frame = CGRect(x: 32, y: 250, width: (self.view.bounds.width - 64), height: 31)
        view.addSubview(segmentControl)
        /*NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100.0),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 31.0)
        ])*/
        
    }
    
    
    // MARK: User Interactions
    
    @objc private func tapOnLogout() {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(forInput: false, onlyAccept: false, title: Constants.UpdateProfile, message: Constants.GoingToUpdate) { _ in
                /// Arrancamos el manager y deslogueamos
                Managers.managerUserAuthoritation = UserAuthoritation()
                Managers.managerUserAuthoritation!.logout(onSuccess: {
                    self?.createLoginScene()
                    
                }) { error in
                    self?.showAlert(title: Constants.Error, message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func tapOnSaveUser() {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(forInput: false, onlyAccept: false, title: Constants.UploadProduct, message: Constants.GoingToUpload) { _ in
                self?.viewModel.updateProfile(image: self!.avatarImageView.image!, onSuccess: {
                    self?.showAlert(title: Constants.Success, message: Constants.AvatarUpdated)
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                    
                }, onError: { error in
                    self?.showAlert(title: Constants.Error, message: error.localizedDescription)
                })
            }
        }
    }
    
    @objc private func tapOnAvatar(_ sender: UITapGestureRecognizer) {
        /// Abrimos el controlador de seleccion de imagenes de la libreria
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func deleteAvatar(_ sender: UILongPressGestureRecognizer) {
        /// Recibimos el imageHolder del LongPress para ponerle el holder
        DispatchQueue.main.async { [weak self] in
            self?.avatarImageView.image = UIImage(systemName: Constants.faceIcon)
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = !self.navigationItem.rightBarButtonItem!.isEnabled
    }
    
    @objc private func changeSegment(sender: UISegmentedControl!) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.viewModel.filterByState(state: .selling)
            collectionView.isHidden = false
            tableView.isHidden = true
            
        case 1:
            self.viewModel.filterByState(state: .sold)
            collectionView.isHidden = false
            tableView.isHidden = true
            
        case 2:
            collectionView.isHidden = true
            tableView.isHidden = false
            
        default:
            break
        }
    }
    
    
    // MARK: Private Functions
    
    fileprivate func configureUI() {
        /// Creacion del boton de logout y editar
        let logoutLeftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.Logout, style: .plain, target: self, action: #selector(tapOnLogout))
        //cancelLeftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.leftBarButtonItem = logoutLeftBarButtonItem
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17Regular], for: .normal)
        
        let editRightBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.Save, style: .plain, target: self, action: #selector(tapOnSaveUser))
        editRightBarButtonItem.isEnabled = false
        //postLeftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.rightBarButtonItem = editRightBarButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17SemiBold], for: .normal)
        
        /// Informacion de usuario
        DispatchQueue.main.async { [weak self] in
            self?.usernameLabel.text = MainViewModel.user.username
            self?.shoppingSalesLabel.text = "\(MainViewModel.user.shopping!) \(Constants.Shopping) \(MainViewModel.user.sales!) \(Constants.Sales)"
        }
        
        /// Avatar de usuario
        if MainViewModel.user.avatar!.isEmpty {
            self.avatarImageView.image = UIImage(systemName: Constants.faceIcon)
            
        } else {
            guard let url = URL.init(string: MainViewModel.user.avatar!) else { return }
            avatarImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { (image,_,_,_) in
                if let image = image {
                    self.avatarImageView.image = image
                }
            }
        }
    }
    
    fileprivate func createLoginScene() {
        /// Liberamos memoria
        Managers.managerUserAuthoritation = nil
        
        /// Accedemos a la WindowScene de la App para la navegacion
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        /// Creamos el con la escena inicial de la App
        let tabBarProvider: NavigationManager = NavigationManager()
        tabBarProvider.userNotLoggedIn(fromLogout: true)
        sceneDelegate.window?.rootViewController = tabBarProvider.activeTab()
        
        /// Eliminamos el controlador del login
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: ProfileViewModel Delegate

extension ProfileViewController: ProfileViewModelDelegate {
    func geocodeLocationed(location: String) {
        DispatchQueue.main.async { [weak self] in
            self?.locationLabel.text = location
        }
    }
    
    func productCellViewModelsCreated() {
        /// Filtrado inicial ya que el segmentControl aparece en .selling
        self.viewModel.filterByState(state: .selling)
    }
    
    func searchViewModelsCreated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func filterApplied() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}


// MARK: UIImagePicker Delegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: {
            /// Si se ha seleccionado foto la ubicamos en el hueco selecionado
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                DispatchQueue.main.async { [weak self] in
                    self?.avatarImageView.image = pickedImage
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
        })
    }
}
