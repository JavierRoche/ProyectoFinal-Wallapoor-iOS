//
//  ProductViewController.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol ProductViewControllerDelegate: class {
    func productAdded()
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
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.TITLE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = Constants.NewProduct
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
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
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.CATEGORY
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var categoryTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = Constants.SelectCategory
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.inputView = categoryPicker
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var categoryPicker: UIPickerView = {
        let picker: UIPickerView = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.DESCRIPTION
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = UIFont.fontStyle16Regular
        textView.textColor = UIColor.black
        textView.showsVerticalScrollIndicator = true
        textView.isScrollEnabled = true
        textView.layer.borderColor = CGColor.init(srgbRed: 196/255.0, green: 196/255.0, blue: 196/255.0, alpha: 0.75)
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 5.0;
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.returnKeyType = UIReturnKeyType.done
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.PRICE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = Constants.price0000
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var firstStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var secondStack: UIStackView = {
        let stack: UIStackView = UIStackView()
        stack.spacing = 32
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var photo1Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: Constants.cameraIcon)
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo2Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: Constants.cameraIcon)
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo3Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: Constants.cameraIcon)
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo4Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: Constants.cameraIcon)
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    /// Delegado para comunicar la creacion correcta del producto
    weak var delegate: ProductViewControllerDelegate?
    /// Objeto con el que acceder al manager de Productos
    let viewModel: NewProductViewModel
    /// Objetos para almacenar datos de pantalla
    var categories = [Category.motor, Category.textile, Category.homes, Category.informatic, Category.sports, Category.services]
    private var imageHolderPressed = UIImageView()
    var imagesList: [UIImage] = [UIImage]()
    
    
    // MARK: Inits

    init(viewModel: NewProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: NewProductViewController.self), bundle: nil)
        
        self.title = Constants.NewProduct
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
        
        Managers.managerStorageFirebase = StorageFirebase()
        Managers.managerProductFirestore = ProductFirestore()
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Managers.managerStorageFirebase = nil
        Managers.managerProductFirestore = nil
    }
    
    
    // MARK: User Interactors
    
    @objc private func tapOnCancel() {
        /// Eliminamos el controlador
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapOnUpload() {
        /// Chequeo de datos y confirmacion de usuario
        if areDataRight() {
            self.showAlert(forInput: false, onlyAccept: false, title: Constants.UploadProduct, message: Constants.GoingToUpload) { _ in
                /// Iniciamos la animacion de waiting y bloqueamos la pantalla
                self.activityIndicator.center = self.view.center
                self.activityIndicator.startAnimating()
                self.view.addSubview(self.activityIndicator)
                self.view.isUserInteractionEnabled = false
                
                self.processProduct()
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
        switch imageView {
        case photo1Image:
            photo1Image.image = UIImage.init(systemName: Constants.cameraIcon)
            break
        case photo2Image:
            photo2Image.image = UIImage.init(systemName: Constants.cameraIcon)
            break
        case photo3Image:
            photo3Image.image = UIImage.init(systemName: Constants.cameraIcon)
            break
        case photo4Image:
            photo4Image.image = UIImage.init(systemName: Constants.cameraIcon)
            break
        default:
            break
        }
    }
    
    
    // MARK: Private Functions
    
    fileprivate func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(categoryLabel)
        view.addSubview(categoryTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(priceLabel)
        view.addSubview(priceTextField)
        view.addSubview(firstStack)
        view.addSubview(secondStack)
        
        firstStack.addArrangedSubview(photo1Image)
        firstStack.addArrangedSubview(photo2Image)
        secondStack.addArrangedSubview(photo3Image)
        secondStack.addArrangedSubview(photo4Image)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 90.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 32.0),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8.0),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 32.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8.0),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            descriptionTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64.0),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 32.0),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8.0),
            priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            firstStack.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 32.0),
            firstStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            secondStack.topAnchor.constraint(equalTo: firstStack.bottomAnchor, constant: 32.0),
            secondStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            photo1Image.widthAnchor.constraint(equalToConstant: 100.0),
            photo1Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            photo2Image.widthAnchor.constraint(equalToConstant: 100.0),
            photo2Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            photo3Image.widthAnchor.constraint(equalToConstant: 100.0),
            photo3Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            photo4Image.widthAnchor.constraint(equalToConstant: 100.0),
            photo4Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
    }
    
    fileprivate func configureUI() {
        /// Creacion del boton de cancelar y publicar
        let cancelLeftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.Cancel, style: .plain, target: self, action: #selector(tapOnCancel))
        //cancelLeftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.leftBarButtonItem = cancelLeftBarButtonItem
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17Regular], for: .normal)
        
        let postLeftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: Constants.Upload, style: .plain, target: self, action: #selector(tapOnUpload))
        //postLeftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.rightBarButtonItem = postLeftBarButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17SemiBold], for: .normal)
        
        /// El interespaciado de los stack hay que definirlo una vez el objeto creado
        firstStack.setCustomSpacing(32, after: photo1Image)
        secondStack.setCustomSpacing(32, after: photo3Image)
    }
    
    fileprivate func areDataRight() -> Bool {
        guard let title = titleTextField.text, let description = descriptionTextView.text, let price = priceTextField.text, let category = categoryTextField.text else {
            self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            return false
        }
        if title.isEmpty || description.isEmpty || price.isEmpty || category.isEmpty {
            self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            return false
        }
        guard let _: Int = Int(price) else {
            self.showAlert(title: Constants.Warning, message: Constants.PriceHasToBe)
            return false
        }
        if photo1Image.image != UIImage.init(systemName: Constants.cameraIcon) {
            if let image = photo1Image.image { imagesList.append(image) }
        }
        if photo2Image.image != UIImage.init(systemName: Constants.cameraIcon) {
            if let image = photo2Image.image { imagesList.append(image) }
        }
        if photo3Image.image != UIImage.init(systemName: Constants.cameraIcon) {
            if let image = photo3Image.image { imagesList.append(image) }
        }
        if photo4Image.image != UIImage.init(systemName: Constants.cameraIcon) {
            if let image = photo4Image.image { imagesList.append(image) }
        }
        if imagesList.count == 0 {
            self.showAlert(title: Constants.Warning, message: Constants.OnePhotoAtLess)
            return false
        }
        return true
    }
    
    fileprivate func processProduct() {
        /// Subimos las imagenes al Cloud Firebase y esperamos recibir la lista de urls
        self.viewModel.uploadImages(images: self.imagesList, onSuccess: { [weak self] urlList in
            let product: Product = Product.init(seller: Managers.managerUserLocation!.getUserLogged().sender.id,
                                                title: (self?.titleTextField.text!)!,
                                                category: self?.viewModel.categoryPicked! ?? Category.homes,
                                                description: (self?.descriptionTextView.text!)!,
                                                price: Int((self?.priceTextField.text!)!)!, photos: urlList)
            /// Guardamos el producto en Firestore
            self?.viewModel.insertProduct(product: product, onSuccess: {
                /// Paramos la animacion y avisamoa la controlador para informar al usuario
                self?.activityIndicator.stopAnimating()
                self?.delegate?.productAdded()
                
                self?.dismiss(animated: true, completion: nil)
                
            }, onError: { error in
                self?.showAlert(title: Constants.Error, message: error.localizedDescription)
            })
            
            
        }) { [weak self] error in
            self?.showAlert(title: Constants.Error, message: error.localizedDescription)
        }
    }
}


// MARK: UIImagePicker Delegate

extension NewProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: {
            /// Si se ha seleccionado foto la ubicamos en el hueco selecionado
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.imageHolderPressed.image = pickedImage
            }
        })
    }
}
