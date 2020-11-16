//
//  SceneDelegate.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var user: User = User(id: String(), email: String(), password: String())

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        /// Obtenemos la escena y la navegacion para la ventana antes de iniciar
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        //Managers.managerUserLocation = UserLocation()
        /// Creamos la escena de la App y la asignamos a la Window
        /*let tabBar: TabBarProvider = TabBarProvider.init()
        window?.rootViewController = tabBar.activeTab()
        window?.makeKeyAndVisible()*/
        /// Si el user no esta logueado arranca la escena de Login
        /*let loginViewController: LoginViewController = LoginViewController()
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController.navigationBar.isHidden = true
        
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()*/
        
        
        /// El manager del usuario logueado y geolocalizacion se inicializa aqui para que no se destruya
        Managers.managerUserLocation = UserLocation()
        Managers.managerUserAuthoritation = UserAuthoritation()
        Managers.managerUserFirestore = UserFirestore()
        
        let tabBarProvider: TabBarProvider = TabBarProvider()
        /// Obtencion de un usuario logueado
        tabBarProvider.checkUserLogged(onSuccess: { [weak self] user in
            if let user = user {
                tabBarProvider.getUserLogged(user: user, onSuccess: { user in
                    guard let user = user else { return }
                    Managers.managerUserLocation?.saveUserLogged(user: user)
                    
                    self?.window?.rootViewController = tabBarProvider.activeTab()
                    self?.window?.makeKeyAndVisible()
                    
                }) { error in
                    tabBarProvider.closeApp(error: error.localizedDescription)
                }
                
            } else {
                self?.window?.rootViewController = tabBarProvider.activeTab()
                self?.window?.makeKeyAndVisible()
            }
            
        }) { error in
            tabBarProvider.closeApp(error: error.localizedDescription)
        }
        
        
        
        /*
        /// El manager del usuario logueado y geolocalizacion se inicializa aqui para que no se destruya
        Managers.managerUserLocation = UserLocation()
        Managers.managerUserAuthoritation = UserAuthoritation()
        
        /// Chequea usuario logueado en UserAuthoritation para arrancar directamente
        Managers.managerUserAuthoritation!.isLogged(onSuccess: { [weak self] user in
            if let user = user {
                /// Guardamos en el manager el usuario logueado
                Managers.managerUserLocation?.saveUserLogged(user: user)
                
                /// Creamos la escena de la App y la asignamos a la Window
                let tabBar: TabBarProvider = TabBarProvider.init()
                self?.window?.rootViewController = tabBar.activeTab()
                
            } else {
                /// Si el user no esta logueado arranca la escena de Login
                let loginViewController: LoginViewController = LoginViewController()
                let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
                navigationController.navigationBar.isHidden = true
                
                self?.window?.rootViewController = navigationController
            }
            
            //self?.window = UIWindow(windowScene: windowScene)
            self?.window?.makeKeyAndVisible()
            
        }) { error in
            let alert = UIAlertController(title: Constants.Error, message: error.localizedDescription, preferredStyle: .alert)
            alert.showAlert()
            /// Abortamos la App pues hay algun problema en Firestore
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        }*/
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

