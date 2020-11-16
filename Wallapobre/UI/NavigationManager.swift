//
//  NavigationManager.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class NavigationManager: UITabBarController {
    /*lazy var tabBar: UITabBarController = {
        let tabBar: UITabBarController = UITabBarController()
        return tabBar
    }()*/
    
    
    var oneTime: Bool = true
    /*init() {
        super.init()
        
        let mainViewModel = MainViewModel()
        let mainViewController: MainViewController = MainViewController(viewModel: mainViewModel)
        let profileViewModel = ProfileViewModel()
        let profileViewController: ProfileViewController = ProfileViewController(viewModel: profileViewModel)
        
        mainViewController.tabBarItem = UITabBarItem.init(title: Constants.Accept, image: UIImage.init(systemName: Constants.starIcon), tag: 0)
        profileViewController.tabBarItem = UITabBarItem.init(title: Constants.Perfil, image: UIImage.init(systemName: Constants.starIcon), tag: 2)

        let mainNavigationController: UINavigationController = UINavigationController.init(rootViewController: mainViewController)
        let profileNavigationController: UINavigationController = UINavigationController.init(rootViewController: profileViewController)
        
        //TabBarProvider.navigation = UINavigationController.init(rootViewController: mainViewController)

        self.viewControllers = [mainNavigationController, profileNavigationController]
        self.tabBar.barStyle = .default
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .black
    }*/
    
    public func activeTab() -> UITabBarController {
        return self
    }
    
    func checkUserLogged(onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        /// Chequea usuario logueado en UserAuthoritation
        Managers.managerUserAuthoritation!.isLogged(onSuccess: { [weak self] user in
            if user != nil && self!.oneTime {
                /// Devolvemos el user logueado
                onSuccess(user)
                
            } else if user == nil && self!.oneTime {
                /// Configuramos la escena inicial para usuario NO logueado
                self?.userNotLoggedIn(fromLogout: false)
                
                /// Devolvemos nil
                onSuccess(user)
            }
            /// Por algun motivo de Firebase esta funcion se rellama. Lo evito.
            self?.oneTime = false
            
        }) { error in
            if let retError = onError {
                retError(error)
            }
        }
    }
    
    func getUserLogged(user: User, onSuccess: @escaping (User?) -> Void, onError: ErrorClosure?) {
        Managers.managerUserFirestore!.selectUser(userId: user.sender.senderId, onSuccess: { [weak self] user in
            /// Configuramos la escena inicial para usuario logueado
            self?.userLoggedIn(user: user!)
            
            /// El usuario existe en Firestore BD
            onSuccess(user)
            
        }) { error in
            /// Ha habido error raro
            if let retError = onError {
                retError(error)
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
        let mainViewModel: MainViewModel = MainViewModel(user: user)
        let mainViewController: MainViewController = MainViewController(viewModel: mainViewModel)
        let profileViewModel = ProfileViewModel()
        let profileViewController: ProfileViewController = ProfileViewController(viewModel: profileViewModel)
        
        mainViewController.tabBarItem = UITabBarItem.init(title: Constants.Accept, image: UIImage.init(systemName: Constants.starIcon), tag: 0)
        profileViewController.tabBarItem = UITabBarItem.init(title: Constants.Perfil, image: UIImage.init(systemName: Constants.starIcon), tag: 1)

        let mainNavigationController: UINavigationController = UINavigationController.init(rootViewController: mainViewController)
        let profileNavigationController: UINavigationController = UINavigationController.init(rootViewController: profileViewController)

        self.viewControllers = [mainNavigationController, profileNavigationController]
        self.tabBar.barStyle = .default
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .black
    }
    
    func userNotLoggedIn(fromLogout: Bool) {
        let loginViewModel: LoginViewModel = LoginViewModel(fromLogout: fromLogout)
        let loginViewController: LoginViewController = LoginViewController(viewModel: loginViewModel)
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController.navigationBar.isHidden = true
        
        self.viewControllers = [navigationController]
        self.tabBar.barStyle = .default
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .black
    }
}

