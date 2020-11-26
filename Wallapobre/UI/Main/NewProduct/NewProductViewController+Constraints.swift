//
//  NewProductViewController+Constraints.swift
//  Wallapobre
//
//  Created by APPLE on 15/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

extension NewProductViewController {
    func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(categoryLabel)
        view.addSubview(categoryTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(priceLabel)
        view.addSubview(priceTextField)
        view.addSubview(euroLabel)
        view.addSubview(firstStack)
        view.addSubview(secondStack)
        
        firstStack.addArrangedSubview(photo1Image)
        firstStack.addArrangedSubview(photo2Image)
        secondStack.addArrangedSubview(photo3Image)
        secondStack.addArrangedSubview(photo4Image)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32.0)
        ])
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 32.0),
            categoryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8.0),
            categoryTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
            categoryTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32.0)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 32.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8.0),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0),
            descriptionTextView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -64.0),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 32.0),
            priceLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8.0),
            priceTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            euroLabel.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor),
            euroLabel.leadingAnchor.constraint(equalTo: priceTextField.trailingAnchor, constant: 4.0)
        ])
        
        NSLayoutConstraint.activate([
            firstStack.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 32.0),
            firstStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            secondStack.topAnchor.constraint(equalTo: firstStack.bottomAnchor, constant: 32.0),
            secondStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            photo1Image.widthAnchor.constraint(equalToConstant: 100.0),
            photo1Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            photo2Image.widthAnchor.constraint(equalToConstant: 100.0),
            photo2Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            photo3Image.widthAnchor.constraint(equalToConstant: 100.0),
            photo3Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        NSLayoutConstraint.activate([
            photo4Image.widthAnchor.constraint(equalToConstant: 100.0),
            photo4Image.heightAnchor.constraint(equalToConstant: 100.0)
        ])
    }
}
