//
//  FiltersViewController+Constraints.swift
//  Wallapobre
//
//  Created by APPLE on 15/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

extension FiltersViewController {
    func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(backgroundView)
        view.addSubview(filtersLabel)
        view.addSubview(acceptButton)
        view.addSubview(categoriesLabel)
        view.addSubview(motorLabel)
        view.addSubview(textileLabel)
        view.addSubview(homesLabel)
        view.addSubview(informaticLabel)
        view.addSubview(sportsLabel)
        view.addSubview(servicesLabel)
        view.addSubview(motorSwitch)
        view.addSubview(textileSwitch)
        view.addSubview(homesSwitch)
        view.addSubview(informaticSwitch)
        view.addSubview(sportsSwitch)
        view.addSubview(servicesSwitch)
        view.addSubview(slider)
        view.addSubview(sliderLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            self.backgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
            self.backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.filtersLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16.0),
            self.filtersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.acceptButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16.0),
            self.acceptButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.categoriesLabel.topAnchor.constraint(equalTo: filtersLabel.bottomAnchor, constant: 16.0),
            self.categoriesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.motorLabel.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 16.0),
            self.motorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.motorSwitch.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 16.0),
            self.motorSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.textileLabel.topAnchor.constraint(equalTo: motorLabel.bottomAnchor, constant: 16.0),
            self.textileLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.textileSwitch.topAnchor.constraint(equalTo: motorSwitch.bottomAnchor, constant: 8.0),
            self.textileSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.homesLabel.topAnchor.constraint(equalTo: textileLabel.bottomAnchor, constant: 16.0),
            self.homesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.homesSwitch.topAnchor.constraint(equalTo: textileSwitch.bottomAnchor, constant: 8.0),
            self.homesSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.informaticLabel.topAnchor.constraint(equalTo: homesLabel.bottomAnchor, constant: 16.0),
            self.informaticLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.informaticSwitch.topAnchor.constraint(equalTo: homesSwitch.bottomAnchor, constant: 8.0),
            self.informaticSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.sportsLabel.topAnchor.constraint(equalTo: informaticLabel.bottomAnchor, constant: 16.0),
            self.sportsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.sportsSwitch.topAnchor.constraint(equalTo: informaticSwitch.bottomAnchor, constant: 8.0),
            self.sportsSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.servicesLabel.topAnchor.constraint(equalTo: sportsLabel.bottomAnchor, constant: 16.0),
            self.servicesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.servicesSwitch.topAnchor.constraint(equalTo: sportsSwitch.bottomAnchor, constant: 8.0),
            self.servicesSwitch.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.slider.topAnchor.constraint(equalTo: servicesLabel.bottomAnchor, constant: 32.0),
            self.slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.slider.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            self.sliderLabel.topAnchor.constraint(equalTo: servicesSwitch.bottomAnchor, constant: 8.0),
            self.sliderLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
    }
}
