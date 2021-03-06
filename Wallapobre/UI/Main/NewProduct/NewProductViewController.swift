//
//  ProductViewController.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol NewProductViewControllerDelegate: class {
    func productAdded()
}

protocol ModifyProductViewControllerDelegate: class {
    func productModified()
}

class NewProductViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.orange
        indicator.style = UIActivityIndicatorView.Style.large
        return indicator
    }()
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = Constants.productName
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.tintColor = UIColor.tangerine
        textField.layer.borderColor = UIColor.tangerine.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4.0
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var categoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.category
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var categoryTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = Constants.selectCategory
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.tintColor = UIColor.tangerine
        textField.layer.borderColor = UIColor.tangerine.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4.0
        textField.inputView = categoryPicker
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var categoryPicker: UIPickerView = {
        let picker: UIPickerView = UIPickerView()
        picker.backgroundColor = UIColor.lightTangerine
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.description
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = UIFont.fontStyle16Regular
        textView.textColor = UIColor.black
        textView.showsVerticalScrollIndicator = true
        textView.isScrollEnabled = true
        textView.layer.borderColor = UIColor.tangerine.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.returnKeyType = UIReturnKeyType.done
        textView.tintColor = UIColor.tangerine
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.price
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = Constants.priceHolder
        textField.font = UIFont.fontStyle16Regular
        textField.textAlignment = .right
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.tangerine
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.layer.borderColor = UIColor.tangerine.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var euroLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle20SemiBold
        label.textColor = UIColor.black
        label.text = Constants.euro
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var firstStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var secondStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var photo1Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: Constants.iconCameraFill)
        image.tintColor = UIColor.lightTangerine
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo2Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: Constants.iconCameraFill)
        image.tintColor = UIColor.lightTangerine
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo3Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: Constants.iconCameraFill)
        image.tintColor = UIColor.lightTangerine
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo4Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: Constants.iconCameraFill)
        image.tintColor = UIColor.lightTangerine
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    /// Delegado para comunicar la creacion correcta del producto a MainViewController
    weak var creationDelegate: NewProductViewControllerDelegate?
    /// Delegado para comunicar la creacion correcta del producto a ProfileViewController
    weak var modificationDelegate: ModifyProductViewControllerDelegate?
    /// Objeto con el que acceder al manager de Productos
    let viewModel: NewProductViewModel
    /// Listas de apoyo
    private var imageHolderPressed = UIImageView()
    private var imagesList: [UIImage] = [UIImage]()
    
    
    // MARK: Inits

    init(viewModel: NewProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: NewProductViewController.self), bundle: nil)
        
        self.title = Constants.newProduct
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.fontStyle17Bold]
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
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Managers.managerStorageFirebase = nil
    }
    
    
    // MARK: User Interactions
    
    @objc private func tapOnCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapOnUpload() {
        /// Chequeo de datos y confirmacion de usuario
        if areDataRight() {
            self.showAlert(forInput: false, onlyAccept: false, title: Constants.uploadProduct, message: Constants.goingToUpload) { [weak self] _ in
                /// Iniciamos la animacion de waiting y bloqueamos la pantalla
                guard let position = self?.view.center, let activityIndicator = self?.activityIndicator else { return }
                self?.activityIndicator.center = position
                self?.activityIndicator.startAnimating()
                self?.view.addSubview(activityIndicator)
                self?.view.isUserInteractionEnabled = false
                    
                self?.processProduct()
            }
        }
    }
    
    @objc private func pickPhoto(_ sender: UITapGestureRecognizer) {
        /// Recibimos el ultimo imageHolder pulsado y guardamos la imagen en su posicion en la lista
        self.imageHolderPressed = sender.view as! UIImageView
        
        /// Abrimos el controlador de seleccion de imagenes de la libreria
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func deletePhoto(_ sender: UILongPressGestureRecognizer) {
        /// Recibimos el imageHolder del LongPress para ponerle el holder
        let imageView: UIImageView = sender.view as! UIImageView
        DispatchQueue.main.async { [weak self] in
            switch imageView {
            case self?.photo1Image:
                self?.photo1Image.image = UIImage.init(systemName: Constants.iconCameraFill)
                break
                
            case self?.photo2Image:
                self?.photo2Image.image = UIImage.init(systemName: Constants.iconCameraFill)
                break
                
            case self?.photo3Image:
                self?.photo3Image.image = UIImage.init(systemName: Constants.iconCameraFill)
                break
                
            case self?.photo4Image:
                self?.photo4Image.image = UIImage.init(systemName: Constants.iconCameraFill)
                break
                
            default:
                break
            }
        }
    }
    
    
    // MARK: Private Functions
    
    fileprivate func configureUI() {
        /// Creacion del boton de cancelar y publicar
        let cancelLeftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.cancel, style: .plain, target: self, action: #selector(tapOnCancel))
        cancelLeftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.leftBarButtonItem = cancelLeftBarButtonItem
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17Regular], for: .normal)
        
        let uploadRightBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.upload, style: .plain, target: self, action: #selector(tapOnUpload))
        uploadRightBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.rightBarButtonItem = uploadRightBarButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17SemiBold], for: .normal)
        
        /// El interespaciado de los stack hay que definirlo una vez el objeto creado
        firstStack.setCustomSpacing(64, after: photo1Image)
        secondStack.setCustomSpacing(64, after: photo3Image)
        
        /// Se informan los campos si se inicio el controller para modificacion
        self.setProductToModify()
    }
    
    fileprivate func setProductToModify() {
        /// Si se inicio el ViewModel con producto es que estamos en una modificacion
        guard let product = self.viewModel.originalProduct else { return }
        
        /// Cambiamos el valor del titulo y del boton
        self.title = Constants.modifyProduct
        navigationItem.rightBarButtonItem?.title = Constants.update
        
        /// Informamos las cajas de texto
        titleTextField.text = product.title
        categoryTextField.text = product.category.name
        descriptionTextView.text = product.description
        priceTextField.text = String(product.price)
        
        for (index, photo) in product.photos.enumerated() {
            if let url = URL.init(string: photo) {
                switch index {
                case 0:
                    self.photo1Image.kf.setImage(with: url) { [weak self] result in
                        switch result {
                        case .success(let value):
                            self?.photo1Image.image = value.image
                            
                        case .failure(_):
                            self?.photo1Image.image = UIImage(systemName: Constants.iconImageWarning)
                        }
                    }
                    
                case 1:
                    self.photo2Image.kf.setImage(with: url) { [weak self] result in
                        switch result {
                        case .success(let value):
                            self?.photo2Image.image = value.image
                            
                        case .failure(_):
                            self?.photo2Image.image = UIImage(systemName: Constants.iconImageWarning)
                        }
                    }
                    
                case 2:
                    self.photo3Image.kf.setImage(with: url) { [weak self] result in
                        switch result {
                        case .success(let value):
                            self?.photo3Image.image = value.image
                            
                        case .failure(_):
                            self?.photo3Image.image = UIImage(systemName: Constants.iconImageWarning)
                        }
                    }
                    
                default:
                    self.photo4Image.kf.setImage(with: url) { [weak self] result in
                        switch result {
                        case .success(let value):
                            self?.photo4Image.image = value.image
                            
                        case .failure(_):
                            self?.photo4Image.image = UIImage(systemName: Constants.iconImageWarning)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func areDataRight() -> Bool {
        guard let title = titleTextField.text, let description = descriptionTextView.text, let price = priceTextField.text, let category = categoryTextField.text else {
            self.showAlert(title: Constants.warning, message: Constants.missingData)
            return false
        }
        
        if title.isEmpty || description.isEmpty || price.isEmpty || category.isEmpty {
            self.showAlert(title: Constants.warning, message: Constants.missingData)
            return false
        }
        
        guard let _: Int = Int(price) else {
            self.showAlert(title: Constants.warning, message: Constants.priceHasToBe)
            return false
        }
        
        if photo1Image.image != UIImage.init(systemName: Constants.iconCameraFill) {
            if let image = photo1Image.image { imagesList.append(image) }
        }
        
        if photo2Image.image != UIImage.init(systemName: Constants.iconCameraFill) {
            if let image = photo2Image.image { imagesList.append(image) }
        }
        
        if photo3Image.image != UIImage.init(systemName: Constants.iconCameraFill) {
            if let image = photo3Image.image { imagesList.append(image) }
        }
        
        if photo4Image.image != UIImage.init(systemName: Constants.iconCameraFill) {
            if let image = photo4Image.image { imagesList.append(image) }
        }
        
        if imagesList.count == 0 {
            self.showAlert(title: Constants.warning, message: Constants.photoRequired)
            return false
        }
        return true
    }
    
    fileprivate func processProduct() {
        if let _ = self.viewModel.originalProduct {
            self.processModifyProduct()
            
        } else {
            self.processNewProduct()
        }
    }
    
    fileprivate func processNewProduct() {
        /// Subimos las imagenes al Cloud Firebase y esperamos recibir la lista de urls
        self.viewModel.uploadImages(images: self.imagesList, onSuccess: { [weak self] urlList in
            /// Para layout Pinterest necesito guardar la altura de la imagen principal
            guard let mainImage = self?.imagesList[0] else { return }
            let height = self?.viewModel.getHeightMainImage(image: mainImage)
            
            /// Creamos un producto con los datos introducidos
            let product: Product = Product.init(seller: MainViewModel.user.sender.id, title: self?.titleTextField.text ?? String(), category: self?.viewModel.categoryPicked ?? Category.homes, description: self?.descriptionTextView.text ?? String(), price: Int(self?.priceTextField.text ?? String()) ?? 0, photos: urlList, heightMainphoto: height ?? 0)
            
            /// Guardamos el producto en Firestore
            self?.viewModel.insertProduct(product: product, onSuccess: {
                /// Paramos la animacion y avisamos al controlador para informar al usuario
                self?.activityIndicator.stopAnimating()
                self?.creationDelegate?.productAdded()
                
                self?.dismiss(animated: true, completion: nil)
                
            }, onError: { [weak self] error in
                self?.showAlert(title: Constants.error, message: error.localizedDescription)
            })
            
            
        }) { [weak self] error in
            self?.showAlert(title: Constants.error, message: error.localizedDescription)
        }
    }
    
    fileprivate func processModifyProduct() {
        /// Subimos las imagenes al Cloud Firebase y esperamos recibir la lista de urls
        self.viewModel.uploadImages(images: self.imagesList, onSuccess: { [weak self] urlList in
            /// Modificamos el producto inicial antes de lanzar la actualizacion
            guard let product: Product = self?.viewModel.originalProduct else { return }
            product.title = self?.titleTextField.text ?? String()
            product.category = self?.viewModel.categoryPicked ?? product.category
            product.description = self?.descriptionTextView.text ?? String()
            product.price = Int(self?.priceTextField.text ?? String()) ?? 0
            product.photos = urlList
            
            /// Guardamos el producto en Firestore
            self?.viewModel.modifyProduct(product: product, onSuccess: {
                /// Paramos la animacion y avisamos al controlador para informar al usuario
                self?.activityIndicator.stopAnimating()
                self?.modificationDelegate?.productModified()
                
                self?.dismiss(animated: true, completion: nil)
                
            }, onError: { error in
                self?.showAlert(title: Constants.error, message: error.localizedDescription)
            })
            
            
        }) { [weak self] error in
            self?.showAlert(title: Constants.error, message: error.localizedDescription)
        }
    }
}


// MARK: UIImagePicker Delegate

extension NewProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: {
            /// Si se ha seleccionado foto la ubicamos en el hueco selecionado
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.imageHolderPressed.image = pickedImage
                }
            }
        })
    }
}
