//
//  LoginViewController+Constraints.swift
//  Wallapobre
//
//  Created by APPLE on 15/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

extension LoginViewController {
    func setViewsHierarchy() {
        view = UIView()
        
        view.addSubview(backgroundView)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(hideButton)
        view.addSubview(recoverButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -8.0),
            emailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.bottomAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: -32.0),
            emailTextField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: passwordLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8.0),
            passwordLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 32.0),
            usernameLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            usernameTextField.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            usernameTextField.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 26.0),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hideButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 26.0),
            hideButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 26.0),
            registerButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recoverButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64.0),
            recoverButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64.0)
        ])
    }
}
