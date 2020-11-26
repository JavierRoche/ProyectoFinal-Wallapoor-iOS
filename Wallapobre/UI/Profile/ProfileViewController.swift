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
        let image: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 96, height: 96))
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.layer.masksToBounds = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deleteAvatar)))
        image.image = UIImage(systemName: Constants.iconAvatarHolder)
        image.tintColor = UIColor.tangerine
        image.layer.cornerRadius = 48.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var shoppingSalesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16Regular
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segment: UISegmentedControl = UISegmentedControl()
        segment.backgroundColor = UIColor.tangerine
        segment.insertSegment(withTitle: Constants.selling, at: 0, animated: true)
        segment.insertSegment(withTitle: Constants.sold, at: 1, animated: true)
        segment.insertSegment(withTitle: Constants.searches, at: 2, animated: true)
        segment.insertSegment(withTitle: Constants.messages, at: 3, animated: true)
        segment.selectedSegmentIndex = 0
        segment.layer.cornerRadius = 4.0
        segment.addTarget(self, action: #selector(changeSegment), for: UIControl.Event.valueChanged)
        return segment
    }()
    
    lazy var pinterestLayout: PinterestLayout = {
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        return pinterestLayout
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
    
    lazy var searchesTableView: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cell)
        table.tableFooterView = UIView()
        table.isHidden = true
        table.dataSource = self
        table.delegate = self
        table.separatorColor = UIColor.clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var discussionsTableView: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.register(DiscussionCell.self, forCellReuseIdentifier: String(describing: DiscussionCell.self))
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 30
        table.isHidden = true
        table.dataSource = self
        table.delegate = self
        table.separatorColor = UIColor.clear
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
        
        /// Recuperacion de datos y configuramos la interface
        self.viewModel.delegate = self
        self.viewModel.viewWasLoaded()
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        segmentControl.frame = CGRect(x: 32, y: 250, width: (self.view.bounds.width - 64), height: 31)
        view.addSubview(segmentControl)
        /*NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100.0),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            segmentControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 31.0)
        ])*/
        
        /// Los productos se cargan aqui por si ha entrado desde el profile a modifcarlo
        self.viewModel.viewWasAppear()
    }
    
    
    // MARK: User Interactions
    
    @objc private func tapOnLogout() {
        self.showAlert(forInput: false, onlyAccept: false, title: Constants.userLogout, message: Constants.goingToLogout) { [weak self] _ in
            /// Arrancamos el manager y deslogueamos
            Managers.managerUserAuthoritation = UserAuthoritation()
            Managers.managerUserAuthoritation!.logout(onSuccess: {
                self?.createLoginScene()
                    
            }) { error in
                self?.showAlert(title: Constants.error, message: error.localizedDescription)
            }
        }
    }
    
    @objc private func tapOnSaveUser() {
        self.showAlert(forInput: false, onlyAccept: false, title: Constants.updateProfile, message: Constants.goingToUpdate) { [weak self] _ in
            self?.viewModel.updateProfile(image: self!.avatarImageView.image!, onSuccess: {
                self?.showAlert(title: Constants.success, message: Constants.profileUpdated)
                self?.navigationItem.rightBarButtonItem?.isEnabled = false
                    
            }, onError: { error in
                self?.showAlert(title: Constants.error, message: error.localizedDescription)
            })
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
            self?.avatarImageView.image = UIImage(systemName: Constants.iconAvatarHolder)
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = !self.navigationItem.rightBarButtonItem!.isEnabled
    }
    
    @objc private func changeSegment(sender: UISegmentedControl!) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.viewModel.filterByState(state: .selling)
            collectionView.isHidden = false
            searchesTableView.isHidden = true
            discussionsTableView.isHidden = true
            
        case 1:
            self.viewModel.filterByState(state: .sold)
            collectionView.isHidden = false
            searchesTableView.isHidden = true
            discussionsTableView.isHidden = true
            
        case 2:
            collectionView.isHidden = true
            searchesTableView.isHidden = false
            discussionsTableView.isHidden = true
        
        case 3:
            collectionView.isHidden = true
            searchesTableView.isHidden = true
            discussionsTableView.isHidden = false
            
        default:
            break
        }
    }
    
    
    // MARK: Private Functions
    
    fileprivate func configureUI() {
        /// Creacion del boton de logout y editar
        let logoutLeftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.logout, style: .plain, target: self, action: #selector(tapOnLogout))
        logoutLeftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.leftBarButtonItem = logoutLeftBarButtonItem
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17Regular], for: .normal)
        
        let editRightBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.save, style: .plain, target: self, action: #selector(tapOnSaveUser))
        editRightBarButtonItem.isEnabled = false
        editRightBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.rightBarButtonItem = editRightBarButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17SemiBold], for: .normal)
        
        /// Informacion de usuario
        usernameLabel.text = MainViewModel.user.username
        shoppingSalesLabel.text = "\(MainViewModel.user.shopping) \(Constants.shoppingPlusPipe) \(MainViewModel.user.sales) \(Constants.sales)"
        
        /// Avatar de usuario
        if !MainViewModel.user.avatar.isEmpty {
            guard let url = URL.init(string: MainViewModel.user.avatar) else { return }
            avatarImageView.kf.setImage(with: url) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.avatarImageView.image = value.image
                    
                case .failure(_):
                    self?.avatarImageView.image = UIImage(systemName: Constants.iconAvatarHolder)
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
        locationLabel.text = location
    }
    
    func productCellViewModelsCreated() {
        /// Filtrado inicial ya que el segmentControl aparece en .selling
        self.viewModel.filterByState(state: .selling)
    }
    
    func searchViewModelsCreated() {
        DispatchQueue.main.async { [weak self] in
            self?.searchesTableView.reloadData()
        }
    }
    
    func discussionViewModelsCreated() {
        DispatchQueue.main.async { [weak self] in
            self?.discussionsTableView.reloadData()
        }
    }
    
    func filterApplied() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}


// MARK: ChatViewController Delegate

extension ProfileViewController: ChatViewControllerDelegate {
    func purchaseCompleted() {
        shoppingSalesLabel.text = "\(MainViewModel.user.shopping) \(Constants.shoppingPlusPipe) \(MainViewModel.user.sales) \(Constants.sales)"
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
