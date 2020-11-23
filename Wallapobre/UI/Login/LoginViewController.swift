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
            /// Reinicializamos los managers necesarios
            Managers.managerUserLocation = UserLocation()
            Managers.managerUserAuthoritation = UserAuthoritation()
            
            self.showAlert(title: Constants.Logout, message: Constants.UserLogout)
        }
        
        /// Solicitamos permisos de geolocalizacion al usuario
        guard let _ = viewModel.askForLocationPermissions() else { return }
        
        self.showAlert(title: Constants.Error, message: "\(Constants.fatalErrorAuth)\n\(Constants.fatalErrorNeedLoc)")
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
            self.showAlert(title: Constants.Error, message: "\(Constants.fatalErrorAuth)\n\(Constants.fatalErrorNeedLoc)")
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
        let originalTransform = registerButton.transform
        let translatedTransform = originalTransform.translatedBy(x: 0.0, y: 90.0)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.registerButton.transform = translatedTransform
            self.loginButton.transform = translatedTransform
            
        }) { _ in
            self.onRegisterInterface = true
            /// Mostramos interface de registro
            self.loginButton.isHidden = true
            self.hideButton.isHidden = false
            self.usernameLabel.isHidden = false
            self.usernameTextField.isHidden = false
        }
    }
    
    fileprivate func closeRegisterInterface() {
        self.onRegisterInterface = false
        /// Ocultamos interface de registro
        self.loginButton.isHidden = false
        self.hideButton.isHidden = true
        self.usernameLabel.isHidden = true
        self.usernameTextField.isHidden = true
        
        let originalTransform = registerButton.transform
        let translatedTransform = originalTransform.translatedBy(x: 0.0, y: -90.0)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.registerButton.transform = translatedTransform
            self.loginButton.transform = translatedTransform
        })
    }
    
    fileprivate func login() {
        /// Comprobamos que el usuario ha introducido un email y un pass y que los campos no esten vacios
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text else {
            self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            return
        }
        
        if email.isEmpty || password.isEmpty {
            self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario y logueamos
        let user: User = User.init(id: String(), email: email, password: password)
        
        self.viewModel.logUser(user: user, onSuccess: { [weak self] user in
            self?.viewModel.getUserLogged(user: user, onSuccess: { (user) in
                self?.createMainScene(user: user)
                
            }) { (error) in
                self?.showAlert(title: Constants.Error, message: error.localizedDescription)
            }
            
        }) { [weak self] error in
            self?.showAlert(title: Constants.Error, message: error.localizedDescription)
        }
    }
    
    fileprivate func register() {
        /// Comprobamos que el usuario ha introducido un email, un pass y un username, y que los campos no esten vacios
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text, let username = usernameTextField.text else {
            self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            return
        }
        
        if email.isEmpty || password.isEmpty || username.isEmpty {
            self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario y registramos
        let user: User = User.init(id: String(), email: email, password: password)
        
        self.viewModel.registerUser(user: user, onSuccess: { [weak self] user in
            user.username = username
            self?.viewModel.getUserLogged(user: user, onSuccess: { (user) in
                self?.createMainScene(user: user)
                
            }) { (error) in
                self?.showAlert(title: Constants.Error, message: error.localizedDescription)
            }
            
        }) { [weak self] error in
            self?.showAlert(title: Constants.Error, message: error.localizedDescription)
        }
    }
    
    fileprivate func recover() {
        /// Comprobamos que el usuario ha introducido un email y que los campos no esten vacios
        guard let email = emailTextField.text?.lowercased() else {
            self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            return
        }
        
        if email.isEmpty {
            self.showAlert(title: Constants.Warning, message: Constants.MissingData)
            return
        }
        
        /// Inicializamos un User con los datos introducidos por el usuario
        let user = User.init(id: String(), email: email, password: nil)
        
        self.viewModel.recoverUser(user: user, onSuccess: {
            self.showAlert(title: Constants.Password, message: Constants.PasswordRecovered)
            
        }) { [weak self] error in
            self?.showAlert(title: Constants.Error, message: error.localizedDescription)
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
        
        self.dismiss(animated: true, completion: nil)
    }
}
