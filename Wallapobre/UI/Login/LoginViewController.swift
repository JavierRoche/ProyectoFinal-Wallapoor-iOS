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
    
    
    // MARK: Life Cycle

    override func loadView() {
        setViewsHierarchy()
        setConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let manager: UserFirebase = UserFirebase()
        manager.isLogged(onSuccess: { (user) in
            if let _ = user {
                // TOO: NAVIGATE
            }
        }, onError: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /// Inicializamos valores globales para una CAAnimation
        registerPosition = CGPoint(x: registerButton.layer.position.x, y: registerButton.layer.position.y)
        loginPosition = CGPoint(x: loginButton.layer.position.x, y: loginButton.layer.position.y)
    }
    
    
    // MARK: User Interactions
    
    @objc func tapOnLogin(sender: UIButton!) {
        /// Accedemos a la WindowScene de la App para la navegacion
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        /// Creamos el TabBar con las pestañas de la App
        let tabBar: TabBarProvider = TabBarProvider.init()
        sceneDelegate.window?.rootViewController = tabBar.activeTab()
        /// Eliminamos el controlador del login
        self.dismiss(animated: true, completion: nil)
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
            self.backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -8.0),
            self.emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            self.passwordLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.emailTextField.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -32.0),
            self.emailTextField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor),
            self.emailTextField.trailingAnchor.constraint(equalTo: passwordLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8.0),
            self.passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            self.passwordLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            self.passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            self.passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            self.usernameLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32.0),
            self.usernameLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            self.usernameLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            self.usernameTextField.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            self.usernameTextField.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 26.0),
            self.loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.hideButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 26.0),
            self.hideButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 26.0),
            self.registerButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.recoverButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64.0),
            self.recoverButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64.0)
        ])
    }
    
    fileprivate func openRegisterInterface() {
        /// Creamos una posicion inicial y una final aplicando una traslacion en vertical
        var startPosition: CGPoint = CGPoint(x: registerPosition.x, y: registerPosition.y)
        registerAnimation.fromValue = startPosition
        registerAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: 90))
        
        /// Al ser una animacion de Core Animation se incluye en la layer de la vista, no en la vista
        registerButton.layer.add(registerAnimation, forKey: "position")
        
        /// Creamos una posicion inicial y una final aplicando una traslacion en vertical
        startPosition = CGPoint(x: loginPosition.x, y: loginPosition.y)
        loginAnimation.fromValue = startPosition
        loginAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: 90))
        
        /// Al ser una animacion de Core Animation se incluye en la layer de la vista, no en la vista
        loginButton.layer.add(loginAnimation, forKey: "position")
    }
    
    fileprivate func closeRegisterInterface() {
        /// Creamos una posicion inicial y una final aplicando una traslacion en vertical
        var startPosition: CGPoint = CGPoint(x: registerPosition.x, y: registerPosition.y)
        registerAnimation.fromValue = startPosition
        registerAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: -90))
        
        /// Al ser una animacion de Core Animation se incluye en la layer de la vista, no en la vista
        registerButton.layer.add(registerAnimation, forKey: "position")
        
        /// Creamos una posicion inicial y una final aplicando una traslacion en vertical
        startPosition = CGPoint(x: loginPosition.x, y: loginPosition.y)
        loginAnimation.fromValue = startPosition
        loginAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: -90))
        
        /// Al ser una animacion de Core Animation se incluye en la layer de la vista, no en la vista
        loginButton.layer.add(loginAnimation, forKey: "position")
    }
    
    fileprivate func login() {
        /// Comprobamos que el usuario ha introducido un email y un pass
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            self.showAlert(title: "Warning", message: "Missing data")
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario
        let user: User = User.init(id: "", email: email, password: password)
        let manager: UserFirebase = UserFirebase()
        /// Obtenemos el manager del interactor y hacemos el login
        manager.login(user: user, onSuccess: { (user) in
            // TODO: Navigate donde sea
            
        }) { (error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    fileprivate func register() {
        /// Comprobamos que el usuario ha introducido un email y un pass
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            self.showAlert(title: "Warning", message: "Missing data")
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario
        let user: User = User.init(id: "", email: email, password: password)
        let manager: UserFirebase = UserFirebase()
        manager.register(user: user, onSuccess: { (user) in
            // TODO: Navigate donde sea
            
        }) { (error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
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
        let manager: UserFirebase = UserFirebase()
        manager.recoverPassword(user: user, onSuccess: { (user) in
            self.showAlert(title: "Password", message: "Password recovered")
            
        }) { (error) in
            self.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
}