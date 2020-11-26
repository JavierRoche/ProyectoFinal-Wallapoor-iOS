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
        view.addSubview(filtersByCategoryLabel)
        view.addSubview(acceptButton)
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
        view.addSubview(filterByDistanceLabel)
        view.addSubview(valueSliderLabel)
        view.addSubview(slider)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: filtersByCategoryLabel.topAnchor, constant: -32.0),
            backgroundView.bottomAnchor.constraint(equalTo: valueSliderLabel.bottomAnchor, constant: 32.0),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 64.0),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -64.0),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filtersByCategoryLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 32.0),
            filtersByCategoryLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            acceptButton.centerYAnchor.constraint(equalTo: backgroundView.topAnchor),
            acceptButton.centerXAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 40.0),
            acceptButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        NSLayoutConstraint.activate([
            motorLabel.topAnchor.constraint(equalTo: filtersByCategoryLabel.bottomAnchor, constant: 32.0),
            motorLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            motorSwitch.centerYAnchor.constraint(equalTo: motorLabel.centerYAnchor),
            motorSwitch.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            textileLabel.topAnchor.constraint(equalTo: motorLabel.bottomAnchor, constant: 16.0),
            textileLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            textileSwitch.centerYAnchor.constraint(equalTo: textileLabel.centerYAnchor),
            textileSwitch.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            homesLabel.topAnchor.constraint(equalTo: textileLabel.bottomAnchor, constant: 16.0),
            homesLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            homesSwitch.centerYAnchor.constraint(equalTo: homesLabel.centerYAnchor),
            homesSwitch.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            informaticLabel.topAnchor.constraint(equalTo: homesLabel.bottomAnchor, constant: 16.0),
            informaticLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            informaticSwitch.centerYAnchor.constraint(equalTo: informaticLabel.centerYAnchor),
            informaticSwitch.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            sportsLabel.topAnchor.constraint(equalTo: informaticLabel.bottomAnchor, constant: 16.0),
            sportsLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            sportsSwitch.centerYAnchor.constraint(equalTo: sportsLabel.centerYAnchor),
            sportsSwitch.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            servicesLabel.topAnchor.constraint(equalTo: sportsLabel.bottomAnchor, constant: 16.0),
            servicesLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0)
        ])
        
        NSLayoutConstraint.activate([
            servicesSwitch.centerYAnchor.constraint(equalTo: servicesLabel.centerYAnchor),
            servicesSwitch.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            filterByDistanceLabel.topAnchor.constraint(equalTo: servicesLabel.bottomAnchor, constant: 32.0),
            filterByDistanceLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueSliderLabel.topAnchor.constraint(equalTo: filterByDistanceLabel.bottomAnchor, constant: 16.0),
            valueSliderLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            slider.centerYAnchor.constraint(equalTo: valueSliderLabel.centerYAnchor),
            slider.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -32.0),
            slider.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
}
