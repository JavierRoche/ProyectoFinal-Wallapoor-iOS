//
//  TabBarProvider.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class TabBarProvider {
    lazy var tabBar: UITabBarController = {
        let tabBar: UITabBarController = UITabBarController()
        return tabBar
    }()
    
    static var navigation: UINavigationController?
    
    init() {
        let mainViewModel = MainViewModel()
        let mainViewController: MainViewController = MainViewController(viewModel: mainViewModel)
        let profileViewModel = ProfileViewModel()
        let profileViewController: ProfileViewController = ProfileViewController(viewModel: profileViewModel)
        
        mainViewController.tabBarItem = UITabBarItem.init(title: Constants.Accept, image: UIImage.init(systemName: Constants.starIcon), tag: 0)
        profileViewController.tabBarItem = UITabBarItem.init(title: Constants.Perfil, image: UIImage.init(systemName: Constants.starIcon), tag: 2)

        let mainNavigationController: UINavigationController = UINavigationController.init(rootViewController: mainViewController)
        let profileNavigationController: UINavigationController = UINavigationController.init(rootViewController: profileViewController)
        
        //TabBarProvider.navigation = UINavigationController.init(rootViewController: mainViewController)

        tabBar.viewControllers = [mainNavigationController, profileNavigationController]
        tabBar.tabBar.barStyle = .default
        tabBar.tabBar.isTranslucent = false
        tabBar.tabBar.tintColor = .black
    }
    
    public func activeTab() -> UITabBarController {
        return tabBar
    }
}

