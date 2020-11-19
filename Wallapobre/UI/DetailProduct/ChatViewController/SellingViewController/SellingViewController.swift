//
//  SellingViewController.swift
//  Wallapobre
//
//  Created by APPLE on 19/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol SellingViewControllerDelegate: class {
    func buyerSelected(buyer: User)
}

class SellingViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Cell)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    /// Objeto del modelo que contiene las caracteristicasa del filtro
    let viewModel: SellingViewModel
    /// Delegado para comunicar la seleccion del buyer
    weak var delegate: SellingViewControllerDelegate?
    
    
    // MARK: Inits

    init(viewModel: SellingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: SellingViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //MARK: Life Cycle
    
    override func loadView() {
        view = UIView()
        
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            self.backgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
            //self.backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16.0),
            self.tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16.0),
            self.tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0),
            self.tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ])
    }
    
    override func viewDidLoad() {
        /// Damos al modelo via libre para cargarse
        self.viewModel.delegate = self
        self.viewModel.viewWasLoaded()
    }
}


// MARK: UITableView Delegate

extension SellingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(forInput: false, onlyAccept: false, title: Constants.UpdatePurchase, message: Constants.SelectABuyer) { _ in
                guard let user = self?.viewModel.getUser(at: indexPath) else { return }
                /// Devolvemos el control al ChatViewController que se encargara de actualizar todo
                self?.delegate?.buyerSelected(buyer: user)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
   

// MARK: UITableView DataSource

extension SellingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfUsers(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell, for: indexPath)
        /// Ignoramos el user que se corresponda con el user logueado
        if self.viewModel.getUser(at: indexPath).sender.senderId == MainViewModel.user.sender.senderId { return UITableViewCell() }
        
        /// Informamos los campos
        cell.textLabel?.text = self.viewModel.getUser(at: indexPath).username
        if let url = URL.init(string: self.viewModel.getUser(at: indexPath).avatar ) {
            /// Aqui puntualmente no uso KingFisher porque da mejor resultado el nativo
            DispatchQueue.global(qos:.userInitiated).async {
                guard let data = try? Data(contentsOf: url) else { return }

                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                    cell.setNeedsLayout()
                }
            }
            
        } else {
            cell.imageView?.image = UIImage(systemName: Constants.WarningImage)
        }
        
        return cell
    }
}


// MARK: SellingViewModel Delegate

extension SellingViewController: SellingViewModelDelegate {
    func viewModelsCreated() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
