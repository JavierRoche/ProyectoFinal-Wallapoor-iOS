//
//  ProductViewController.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit
import MessageKit

class ProductViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "TITLE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "Producto nuevo"
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
        label.text = "CATEGORY"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var categoryTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "Select category"
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
        label.text = "DESCRIPTION"
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
        label.text = "PRICE"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "00.00"
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.numbersAndPunctuation
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
        image.backgroundColor = UIColor.gray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: "camera.fill")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo2Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.backgroundColor = UIColor.gray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: "camera.fill")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo3Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.backgroundColor = UIColor.gray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: "camera.fill")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var photo4Image: UIImageView = {
        let image: UIImageView = UIImageView()
        image.backgroundColor = UIColor.gray
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickPhoto)))
        image.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        image.image = UIImage.init(systemName: "camera.fill")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8.0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    /// Objeto con el que acceder al manager de Productos
    let viewModel: ProductViewModel
    /// Objetos para almacenar datos de pantalla
    var categories: [String] = [Category.motor.rawValue, Category.textile.rawValue, Category.homes.rawValue, Category.informatic.rawValue, Category.sports.rawValue, Category.services.rawValue]
    private var imagesList: [UIImage] = []
    private var lastImageHolderPressed = UIImageView()
    
    
    // MARK: Inits

    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ProductViewController.self), bundle: nil)
        
        self.title = "Nuevo producto"
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

        viewModel.viewWasLoaded()
        configureUI()
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
            self.backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 90.0),
            self.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            self.titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            self.titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            self.categoryLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 32.0),
            self.categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            self.categoryTextField.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8.0),
            self.categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 32.0),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            self.descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8.0),
            self.descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            self.descriptionTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64.0),
            self.descriptionTextView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        NSLayoutConstraint.activate([
            self.priceLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 32.0),
            self.priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            self.priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8.0),
            self.priceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            self.firstStack.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 32.0),
            self.firstStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.secondStack.topAnchor.constraint(equalTo: firstStack.bottomAnchor, constant: 32.0),
            self.secondStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.photo1Image.widthAnchor.constraint(equalToConstant: 100.0),
            self.photo1Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            self.photo2Image.widthAnchor.constraint(equalToConstant: 100.0),
            self.photo2Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            self.photo3Image.widthAnchor.constraint(equalToConstant: 100.0),
            self.photo3Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            self.photo4Image.widthAnchor.constraint(equalToConstant: 100.0),
            self.photo4Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        
    }
    
    fileprivate func configureUI() {
        /// Creacion del boton de cancelar y publicar
        let cancelLeftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tapOnCancel))
        //cancelLeftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.leftBarButtonItem = cancelLeftBarButtonItem
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17Regular], for: .normal)
        
        let postLeftBarButtonItem: UIBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(tapOnUpload))
        //postLeftBarButtonItem.tintColor = UIColor.tangerine
        navigationItem.rightBarButtonItem = postLeftBarButtonItem
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontStyle17SemiBold], for: .normal)
        
        
        /// El interespaciado de los stack hay que definirlo una vez el objeto creado
        firstStack.setCustomSpacing(32, after: photo1Image)
        secondStack.setCustomSpacing(32, after: photo3Image)
    }
    
    fileprivate func areDataRight() -> Bool {
        guard let title = titleTextField.text, let description = descriptionTextView.text, let price = priceTextField.text, let category = categoryTextField.text else {
            self.showAlert(title: "Warning", message: "Missing data")
            return false
        }
        if title.isEmpty || description.isEmpty || price.isEmpty || category.isEmpty {
            self.showAlert(title: "Warning", message: "Missing data")
            return false
        }
        guard let _: Int = Int(price) else {
            self.showAlert(title: "Warning", message: "Price has to be a number")
            return false
        }
        if photo1Image.image != UIImage.init(systemName: "camera.fill") {
            if let image = photo1Image.image { self.imagesList.append(image) }
        }
        if photo2Image.image != UIImage.init(systemName: "camera.fill") {
            if let image = photo2Image.image { self.imagesList.append(image) }
        }
        if photo3Image.image != UIImage.init(systemName: "camera.fill") {
            if let image = photo3Image.image { self.imagesList.append(image) }
        }
        if photo4Image.image != UIImage.init(systemName: "camera.fill") {
            if let image = photo4Image.image { self.imagesList.append(image) }
        }
        if self.imagesList.count == 0 {
            self.showAlert(title: "Warning", message: "At less 1 photo is required")
            return false
        }
        return true
    }
    
    fileprivate func askUserConfirmation() {
        let alertConfirmationController = UIAlertController(title: "Upload object", message: "Going to upload a product", preferredStyle: .alert)
        alertConfirmationController.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action) in
            /// TODO: Subir imagenes, Recuperar urls, Guardar Producto, Limpiar contenedores
        }))
        alertConfirmationController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertConfirmationController, animated: true, completion: nil)
        
    }
    
    
    // MARK: User Interactors
    
    @objc private func tapOnCancel() {
        /// Eliminamos el controlador
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func tapOnUpload() {
        /// Chequeo de datos y confirmacion de usuario
        if areDataRight() {
            askUserConfirmation()
        }
    }
    
    @objc private func pickPhoto(_ sender: UITapGestureRecognizer) {
        /// Recibimos el ultimo imageHolder pulsado y guardamos la imagen en su posicion en la lista
        lastImageHolderPressed = sender.view as! UIImageView
        
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
            photo1Image.image = UIImage.init(systemName: "camera.fill")
            break
        case photo2Image:
            photo2Image.image = UIImage.init(systemName: "camera.fill")
            break
        case photo3Image:
            photo3Image.image = UIImage.init(systemName: "camera.fill")
            break
        case photo4Image:
            photo4Image.image = UIImage.init(systemName: "camera.fill")
            break
        default:
            break
        }
    }
}


// MARK: UIImagePicker Delegate

extension ProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: {
            /// Si se ha seleccionado foto la ubicamos en el hueco selecionado
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.lastImageHolderPressed.image = pickedImage
            }
        })
    }
}
