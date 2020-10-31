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
        
        mainViewController.tabBarItem = UITabBarItem.init(title: "Productos", image: UIImage.init(systemName: "star.fill"), tag: 0)

        TabBarProvider.navigation = UINavigationController.init(rootViewController: mainViewController)

        tabBar.viewControllers = [TabBarProvider.navigation!]
        tabBar.tabBar.barStyle = .default
        tabBar.tabBar.isTranslucent = false
        tabBar.tabBar.tintColor = .black

    }
    
    public func activeTab() -> UITabBarController {
        return tabBar
    }
}

