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
    
    lazy var selectBuyerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.text = Constants.selectBuyer
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cell)
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.white
        table.separatorColor = UIColor.tangerine
        table.dataSource = self
        table.delegate = self
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
        view.addSubview(selectBuyerLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: selectBuyerLabel.topAnchor, constant: -32.0),
            backgroundView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32.0),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 64.0),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -64.0),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            selectBuyerLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 32.0),
            selectBuyerLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: selectBuyerLabel.bottomAnchor, constant: 16.0),
            tableView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16.0),
            tableView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0),
            tableView.heightAnchor.constraint(equalToConstant: 300.0)
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
        
        self.showAlert(forInput: false, onlyAccept: false, title: Constants.purchasingProcess, message: Constants.buyerSelected) { [weak self] _ in
            guard let user = self?.viewModel.getUser(at: indexPath) else { return }
            /// Devolvemos el control al ChatViewController que se encargara de actualizar todo
            self?.delegate?.buyerSelected(buyer: user)
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
   

// MARK: UITableView DataSource

extension SellingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfUsers(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath)
        /// Informamos los campos
        cell.textLabel?.text = self.viewModel.getUser(at: indexPath).username
        cell.imageView?.tintColor = UIColor.tangerine
        cell.imageView?.contentMode = .scaleToFill
        cell.layer.cornerRadius = 4.0
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.6, height: 0.6)
        cell.layer.shadowOpacity = 0.8
        
        if let url = URL.init(string: self.viewModel.getUser(at: indexPath).avatar ) {
            /// Aqui puntualmente no uso KingFisher porque da mejor resultado el nativo
            DispatchQueue.global(qos:.userInitiated).async {
                guard let data = try? Data(contentsOf: url) else { return }

                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                    cell.layer.shadowRadius = 1.5
                    cell.setNeedsLayout()
                }
            }
            
        } else {
            cell.imageView?.image = UIImage(systemName: Constants.iconImageWarning)
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
