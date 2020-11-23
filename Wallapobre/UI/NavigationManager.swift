//
//  NavigationManager.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class NavigationManager: UITabBarController {
    
    
    var oneTime: Bool = true
    
    
    public func activeTab() -> UITabBarController {
        return self
    }
    
    func checkUserLogged(onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        /// Chequea usuario logueado en UserAuthoritation
        Managers.managerUserAuthoritation!.isLogged(onSuccess: { [weak self] user in
            if user != nil && self!.oneTime {
                /// Devolvemos el user logueado
                DispatchQueue.main.async {
                    onSuccess(user)
                }
                
            } else if user == nil && self!.oneTime {
                /// Configuramos la escena inicial para usuario NO logueado
                self?.userNotLoggedIn(fromLogout: false)
                
                /// Devolvemos nil
                DispatchQueue.main.async {
                    onSuccess(user)
                }
            }
            /// Por algun motivo de Firebase esta funcion se rellama. Lo evito.
            self?.oneTime = false
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func getUserLogged(user: User, onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        Managers.managerUserFirestore!.selectUser(userId: user.sender.senderId, onSuccess: { [weak self] user in
            /// Configuramos la escena inicial para usuario logueado
            self?.userLoggedIn(user: user!)
            
            /// El usuario existe en Firestore BD
            DispatchQueue.main.async {
                onSuccess(user)
            }
            
        }) { error in
            if let retError = onError {
                DispatchQueue.main.async {
                    retError(error)
                }
            }
        }
    }
    
    func closeApp(error: String) {
        let alert = UIAlertController(title: Constants.Error, message: error, preferredStyle: .alert)
        alert.showAlert()
        /// Abortamos la App pues hay algun problema en Firestore
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
    
    func userLoggedIn(user: User) {
        /// Configuracion del UITabBarController para usuario logueado
        let mainViewModel: MainViewModel = MainViewModel(user: user)
        let mainViewController: MainViewController = MainViewController(viewModel: mainViewModel)
        let profileViewModel = ProfileViewModel()
        let profileViewController: ProfileViewController = ProfileViewController(viewModel: profileViewModel)
        profileViewController.delegate = mainViewController
        
        mainViewController.tabBarItem = UITabBarItem.init(title: Constants.Shopping, image: UIImage.init(systemName: Constants.iconArchieveboxFill), tag: 0)
        profileViewController.tabBarItem = UITabBarItem.init(title: Constants.Perfil, image: UIImage.init(systemName: Constants.iconPersonFill), tag: 1)

        let mainNavigationController: UINavigationController = UINavigationController.init(rootViewController: mainViewController)
        let profileNavigationController: UINavigationController = UINavigationController.init(rootViewController: profileViewController)

        self.viewControllers = [mainNavigationController, profileNavigationController]
        self.tabBar.barStyle = .default
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.tangerine
    }
    
    func userNotLoggedIn(fromLogout: Bool) {
        /// Configuracion del UITabBarController para usuario NO logueado
        let loginViewModel: LoginViewModel = LoginViewModel(fromLogout: fromLogout)
        let loginViewController: LoginViewController = LoginViewController(viewModel: loginViewModel)
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController.navigationBar.isHidden = true
        
        self.viewControllers = [navigationController]
        self.tabBar.barStyle = .default
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor.tangerine
    }
}

