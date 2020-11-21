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
        label.text = Constants.EMAIL
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = Constants.TypeAnEmail
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
        label.text = Constants.Password.uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = Constants.TypeAnPassword
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
        label.text = Constants.USERNAME
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.isHidden = true
        textField.placeholder = Constants.TypeAnUsername
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
        button.setTitle(Constants.Login, for: .normal)
        button.tintColor = UIColor.black
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnLogin)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var hideButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: Constants.upIcon), for: .normal)
        button.tintColor = UIColor.black
        button.isHidden = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnHideUsername)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(Constants.Register, for: .normal)
        button.tintColor = UIColor.black
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnRegister)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var recoverButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(Constants.RecoverPassword, for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector (tapOnRecover), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var registerAnimation: CABasicAnimation = {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: Constants.keyPathPosition)
        animation.duration = 1.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        return animation
    }()
    
    lazy var loginAnimation: CABasicAnimation = {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: Constants.keyPathPosition)
        animation.duration = 1.5
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        return animation
    }()
    
    lazy var registerPosition: CGPoint = CGPoint(x: 0, y: 0)
    lazy var loginPosition: CGPoint = CGPoint(x: 0, y: 0)
    var onRegisterInterface: Bool = false
    let viewModel: LoginViewModel
    
    
    // MARK: Inits

    init(viewModel: LoginViewModel) {
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
        
        /// Indicamos usuario deslogueado si venimos de un logout
        if viewModel.logoutMessage {
            /// Reinicializamos el manager necesario
            Managers.managerUserLocation = UserLocation()
            Managers.managerUserAuthoritation = UserAuthoritation()
            
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: Constants.Logout, message: Constants.UserLogout)
            }
        }
        
        /// Solicitamos permisos de geolocalizacion al usuario
        guard let _ = viewModel.askForLocationPermissions() else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: Constants.Error, message: "\(Constants.fatalErrorAuth)\n\(Constants.fatalErrorNeedLoc)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /// Inicializamos valores globales para una CAAnimation
        registerPosition = CGPoint(x: registerButton.layer.position.x, y: registerButton.layer.position.y)
        loginPosition = CGPoint(x: loginButton.layer.position.x, y: loginButton.layer.position.y)
    }
    
    
    // MARK: User Interactions
    
    @objc private func tapOnLogin(sender: UIButton!) {
        self.login()
    }
    
    @objc private func tapOnRegister(sender: UIButton!) {
        /// Abrimos el panel de registro o lanzamos el registro
        if !onRegisterInterface {
            self.openRegisterInterface()
            
        } else {
            /// Solicitamos permisos de geolocalizacion al usuario
            guard let _ = viewModel.askForLocationPermissions() else {
                self.register()
                return
            }
            
            /// Si no hay permisos de localizacion damos un mensaje informativo
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: Constants.Error, message: "\(Constants.fatalErrorAuth)\n\(Constants.fatalErrorNeedLoc)")
            }
        }
    }
    
    @objc private func tapOnHideUsername(sender: UIButton!) {
        self.closeRegisterInterface()
    }
    
    @objc private func tapOnRecover(sender: UIButton!) {
        self.recover()
    }
    
    
    // MARK: Private Functions
    
    fileprivate func openRegisterInterface() {
        /// Creamos posicion inicial y final aplicando traslacion vertical para botones de registro y login
        var startPosition: CGPoint = CGPoint(x: registerPosition.x, y: registerPosition.y)
        registerAnimation.fromValue = startPosition
        registerAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: 90))
        registerButton.layer.add(registerAnimation, forKey: Constants.keyPathPosition)
        
        startPosition = CGPoint(x: loginPosition.x, y: loginPosition.y)
        loginAnimation.fromValue = startPosition
        loginAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: 90))
        loginButton.layer.add(loginAnimation, forKey: Constants.keyPathPosition)
    }
    
    fileprivate func closeRegisterInterface() {
        /// Creamos posicion inicial y final aplicando traslacion vertical para botones de registro y login
        var startPosition: CGPoint = CGPoint(x: registerPosition.x, y: registerPosition.y)
        registerAnimation.fromValue = startPosition
        registerAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: -90))
        registerButton.layer.add(registerAnimation, forKey: Constants.keyPathPosition)
        
        startPosition = CGPoint(x: loginPosition.x, y: loginPosition.y)
        loginAnimation.fromValue = startPosition
        loginAnimation.toValue = startPosition.applying(.init(translationX: 0.0, y: -90))
        loginButton.layer.add(loginAnimation, forKey: Constants.keyPathPosition)
    }
    
    fileprivate func login() {
        /// Comprobamos que el usuario ha introducido un email y un pass
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text else {
            DispatchQueue.main.async {
                self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            }
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario y logueamos
        let user: User = User.init(id: String(), email: email, password: password)
        
        self.viewModel.logUser(user: user, onSuccess: { [weak self] user in
            self?.viewModel.getUserLogged(user: user, onSuccess: { (user) in
                self?.createMainScene(user: user)
                
            }) { (error) in
                DispatchQueue.main.async {
                    self?.showAlert(title: Constants.Error, message: error.localizedDescription)
                }
            }
            
        }) { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: Constants.Error, message: error.localizedDescription)
            }
        }
    }
    
    fileprivate func register() {
        /// Comprobamos que el usuario ha introducido un email y un pass
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text, let username = usernameTextField.text else {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: Constants.Warning, message: Constants.MissingData)
            }
            return
        }
        
        if email.isEmpty || password.isEmpty || username.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: Constants.Warning, message: Constants.MissingData)
            }
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario y registramos
        let user: User = User.init(id: String(), email: email, password: password)
        self.viewModel.registerUser(user: user, onSuccess: { [weak self] user in
            user.username = username
            self?.viewModel.getUserLogged(user: user, onSuccess: { (user) in
                self?.createMainScene(user: user)
                
            }) { (error) in
                DispatchQueue.main.async {
                    self?.showAlert(title: Constants.Error, message: error.localizedDescription)
                }
            }
            
        }) { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: Constants.Error, message: error.localizedDescription)
            }
        }
    }
    
    fileprivate func recover() {
        /// Comprobamos que el usuario ha introducido un email
        guard let email = emailTextField.text else {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: Constants.Warning, message: Constants.MissingData)
            }
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario
        let user = User.init(id: String(), email: email, password: nil)
        self.viewModel.recoverUser(user: user, onSuccess: {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(title: Constants.Password, message: Constants.PasswordRecovered)
            }
            
        }) { [weak self] error in
            DispatchQueue.main.async {
                self?.showAlert(title: Constants.Error, message: error.localizedDescription)
            }
        }
    }
    
    fileprivate func createMainScene(user: User) {
        /// Liberamos memoria
        Managers.managerUserLocation = nil
        Managers.managerUserAuthoritation = nil
        
        /// Accedemos a la WindowScene de la App para la navegacion
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        
        /// Creamos el con la escena inicial de la App
        let tabBarProvider: NavigationManager = NavigationManager()
        tabBarProvider.userLoggedIn(user: user)
        sceneDelegate.window?.rootViewController = tabBarProvider.activeTab()
        
        /// Eliminamos el controlador del login
        self.dismiss(animated: true, completion: nil)
    }
}
