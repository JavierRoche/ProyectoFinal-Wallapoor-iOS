//
//  LoginViewController.swift
//  Wallapobre
//
//  Created by APPLE on 02/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "EMAIL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "Type an email"
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        //textField.delegate = (self as! UITextFieldDelegate)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "PASSWORD"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "Type a password"
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.isSecureTextEntry = true
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        //textField.delegate = (self as! UITextFieldDelegate)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.isHidden = true
        label.font = UIFont.fontStyle14Regular
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "USERNAME"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.isHidden = true
        textField.placeholder = "Type an username"
        textField.font = UIFont.fontStyle16Regular
        textField.textColor = UIColor.black
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        //textField.delegate = (self as! UITextFieldDelegate)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Login", for: .normal)
        button.tintColor = UIColor.black
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnLogin)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var hideButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        button.tintColor = UIColor.black
        button.isHidden = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHideUsername)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Register", for: .normal)
        button.tintColor = UIColor.black
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnRegister)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var recoverButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Recover password", for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector (tapOnRecover), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var registerAnimation: CABasicAnimation = {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.duration = 1.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        return animation
    }()
    
    lazy var loginAnimation: CABasicAnimation = {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.duration = 1.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        return animation
    }()
    
    lazy var registerPosition: CGPoint = CGPoint(x: 0, y: 0)
    lazy var loginPosition: CGPoint = CGPoint(x: 0, y: 0)
    var registerInterface: Bool = false
    lazy var viewModel = LoginViewModel()
    
    
    // MARK: Life Cycle

    override func loadView() {
        self.setViewsHierarchy()
        self.setConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Arrancamos los managers
        Managers.managerUserAuthoritation = UserAuthoritation()
        Managers.managerUserFirestore = UserFirestore()
        
        /// Solicitamos permisos de geolocalizacion al usuario
        viewModel.askForLocationPermissions()
        /// Obtencion de un usuario logueado
        viewModel.checkUserLogged(onSuccess: { [weak self] user in
            if let user = user {
                self?.viewModel.getUserLogged(user: user, onSuccess: { user in
                    self?.viewModel.saveUserLogged(user: user)
                    self?.createScene()
                    
                }) { (error) in
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
            
        }) { error in
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /// Inicializamos valores globales para una CAAnimation
        registerPosition = CGPoint(x: registerButton.layer.position.x, y: registerButton.layer.position.y)
        loginPosition = CGPoint(x: loginButton.layer.position.x, y: loginButton.layer.position.y)
    }
    
    
    // MARK: User Interactions
    
    @objc func tapOnLogin(sender: UIButton!) {
        login()
    }
    
    @objc func tapOnRegister(sender: UIButton!) {
        if !registerInterface {
            openRegisterInterface()
            
        } else {
            register()
        }
    }
    
    @objc func tapOnHideUsername(sender: UIButton!) {
        closeRegisterInterface()
    }
    
    @objc func tapOnRecover(sender: UIButton!) {
        recover()
    }
    
    
    // MARK: Private Functions
    
    fileprivate func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(backgroundView)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(hideButton)
        view.addSubview(recoverButton)
    }
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -8.0),
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -32.0),
            emailTextField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: passwordLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8.0),
            passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32.0),
            usernameLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 26.0),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hideButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 26.0),
            hideButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 26.0),
            registerButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recoverButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64.0),
            recoverButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64.0)
        ])
    }
    
    fileprivate func openRegisterInterface() {
        /// Creamos posicion inicial y final aplicando traslacion vertical para botones de registro y login
        var startPosition: CGPoint = CGPoint(x: registerPosition.x, y: registerPosition.y)
        registerAnimation.fromValue = startPosition
        registerAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: 90))
        registerButton.layer.add(registerAnimation, forKey: "position")
        
        startPosition = CGPoint(x: loginPosition.x, y: loginPosition.y)
        loginAnimation.fromValue = startPosition
        loginAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: 90))
        loginButton.layer.add(loginAnimation, forKey: "position")
    }
    
    fileprivate func closeRegisterInterface() {
        /// Creamos posicion inicial y final aplicando traslacion vertical para botones de registro y login
        var startPosition: CGPoint = CGPoint(x: registerPosition.x, y: registerPosition.y)
        registerAnimation.fromValue = startPosition
        registerAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: -90))
        registerButton.layer.add(registerAnimation, forKey: "position")
        
        startPosition = CGPoint(x: loginPosition.x, y: loginPosition.y)
        loginAnimation.fromValue = startPosition
        loginAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: -90))
        loginButton.layer.add(loginAnimation, forKey: "position")
    }
    
    fileprivate func login() {
        /// Comprobamos que el usuario ha introducido un email y un pass
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text else {
            self.showAlert(title: "Warning", message: "Missing data")
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario y logueamos
        let user: User = User.init(id: "", email: email, password: password)
        
        self.viewModel.logUser(user: user, onSuccess: { [weak self] user in
            self?.viewModel.getUserLogged(user: user, onSuccess: { (user) in
                self?.viewModel.saveUserLogged(user: user)
                self?.createScene()
                
            }) { (error) in
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }) { [weak self] error in
            self?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    fileprivate func register() {
        /// Comprobamos que el usuario ha introducido un email y un pass
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text, let username = usernameTextField.text else {
            self.showAlert(title: "Warning", message: "Missing data")
            return
        }
        
        if email.isEmpty || password.isEmpty || username.isEmpty {
            self.showAlert(title: "Warning", message: "Missing data")
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario y registramos
        let user: User = User.init(id: "", email: email, password: password)
        self.viewModel.registerUser(user: user, onSuccess: { [weak self] user in
            user.username = username
            self?.viewModel.getUserLogged(user: user, onSuccess: { (user) in
                self?.viewModel.saveUserLogged(user: user)
                self?.createScene()
                
            }) { (error) in
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }) { [weak self] error in
            self?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    fileprivate func recover() {
        /// Comprobamos que el usuario ha introducido un email
        guard let email = emailTextField.text else {
            self.showAlert(title: "Warning", message: "Missing data")
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario
        let user = User.init(id: "", email: email, password: nil)
        self.viewModel.recoverUser(user: user, onSuccess: {
            self.showAlert(title: "Password", message: "Password recovered")
            
        }) { [weak self] error in
            self?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    fileprivate func createScene() {
        /// Liberamos memoria
        //Managers.managerUserAuthoritation = nil
        //Managers.managerUserFirestore = nil
        
        /// Accedemos a la WindowScene de la App para la navegacion
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        /// Creamos el TabBar con las pestañas de la App
        let tabBar: TabBarProvider = TabBarProvider.init()
        sceneDelegate.window?.rootViewController = tabBar.activeTab()
        /// Eliminamos el controlador del login
        self.dismiss(animated: true, completion: nil)
    }
}
