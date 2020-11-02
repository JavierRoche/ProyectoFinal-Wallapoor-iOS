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
        let viewModel = MainViewModel()
        let mainViewController: MainViewController = MainViewController(viewModel: viewModel)
        let productViewController: MainViewController = MainViewController(viewModel: viewModel)
        
        mainViewController.tabBarItem = UITabBarItem.init(title: "Productos", image: UIImage.init(systemName: "star.fill"), tag: 0)
        
        //productViewController.tabBarItem = UITabBarItem.init(title: "Nuevo Producto", image: UIImage.init(systemName: "star.fill"), tag: 2)

        let mainNavigationController: UINavigationController = UINavigationController.init(rootViewController: mainViewController)
        //let productNavigationController: UINavigationController = UINavigationController.init(rootViewController: productViewController)
        
        //TabBarProvider.navigation = UINavigationController.init(rootViewController: mainViewController)

        tabBar.viewControllers = [mainNavigationController] //, productNavigationController]
        tabBar.tabBar.barStyle = .default
        tabBar.tabBar.isTranslucent = false
        tabBar.tabBar.tintColor = .black

    }
    
    public func activeTab() -> UITabBarController {
        return tabBar
    }
}

