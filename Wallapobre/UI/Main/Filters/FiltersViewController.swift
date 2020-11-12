//
//  FiltersViewController.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func filterCreated(filter: Filter)
}

class FiltersViewController: UIViewController {
    lazy var backgroundView: UIView = {
        let view: UIView = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var filtersLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle22Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "Filtros"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var acceptButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Aceptar", for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector (acceptFilter), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var categoriesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "CATEGORÍAS"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var motorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.motor.rawValue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.textile.rawValue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var homesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.homes.rawValue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var informaticLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.informatic.rawValue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sportsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.sports.rawValue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var servicesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.services.rawValue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var motorSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.isOn = false
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var textileSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.isOn = false
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var homesSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.isOn = false
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var informaticSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.isOn = false
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var sportsSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.isOn = false
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var servicesSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.isOn = false
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var slider: UISlider = {
        let slider: UISlider = UISlider()
        slider.maximumValue = 40
        slider.minimumValue = 0
        slider.value = 20
        slider.isContinuous = true
        slider.addTarget(self, action: #selector (sliderValueDidChange), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var sliderLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = "20"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    /// Objeto del modelo que contiene las imagenes
    let viewModel: FiltersViewModel
    /// Delegado para comunicar la creacion del filtro
    weak var delegate: FiltersViewControllerDelegate?
    
    
    // MARK: Inits

    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: FiltersViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //MARK: Life Cycle
    
    override func loadView() {
        setViewsHierarchy()
        setConstraints()
    }
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let newFilter: Filter = viewModel.setFilter(motorSwitchValue: motorSwitch.isOn,
                                                    textileSwitchValue: textileSwitch.isOn,
                                                    homesSwitchValue: homesSwitch.isOn,
                                                    informaticSwitchValue: informaticSwitch.isOn,
                                                    sportsSwitchValue: sportsSwitch.isOn,
                                                    servicesSwitchValue: servicesSwitch.isOn,
                                                    slideValue: slider.value, text: String())
        if newFilter != viewModel.filter {
            delegate?.filterCreated(filter: newFilter)
        }
    }
    
    
    // MARK: Private Functions
       
    fileprivate func setViewsHierarchy() {
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
    
    fileprivate func setConstraints() {
        NSLayoutConstraint.activate([
            self.backgroundView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
            self.backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.filtersLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16.0),
            self.filtersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.acceptButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16.0),
            self.acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.categoriesLabel.topAnchor.constraint(equalTo: filtersLabel.bottomAnchor, constant: 16.0),
            self.categoriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.motorLabel.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 16.0),
            self.motorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.motorSwitch.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 16.0),
            self.motorSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.textileLabel.topAnchor.constraint(equalTo: motorLabel.bottomAnchor, constant: 16.0),
            self.textileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.textileSwitch.topAnchor.constraint(equalTo: motorSwitch.bottomAnchor, constant: 8.0),
            self.textileSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.homesLabel.topAnchor.constraint(equalTo: textileLabel.bottomAnchor, constant: 16.0),
            self.homesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.homesSwitch.topAnchor.constraint(equalTo: textileSwitch.bottomAnchor, constant: 8.0),
            self.homesSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.informaticLabel.topAnchor.constraint(equalTo: homesLabel.bottomAnchor, constant: 16.0),
            self.informaticLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.informaticSwitch.topAnchor.constraint(equalTo: homesSwitch.bottomAnchor, constant: 8.0),
            self.informaticSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.sportsLabel.topAnchor.constraint(equalTo: informaticLabel.bottomAnchor, constant: 16.0),
            self.sportsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.sportsSwitch.topAnchor.constraint(equalTo: informaticSwitch.bottomAnchor, constant: 8.0),
            self.sportsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.servicesLabel.topAnchor.constraint(equalTo: sportsLabel.bottomAnchor, constant: 16.0),
            self.servicesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.servicesSwitch.topAnchor.constraint(equalTo: sportsSwitch.bottomAnchor, constant: 8.0),
            self.servicesSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
        NSLayoutConstraint.activate([
            self.slider.topAnchor.constraint(equalTo: servicesLabel.bottomAnchor, constant: 32.0),
            self.slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.slider.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            self.sliderLabel.topAnchor.constraint(equalTo: servicesSwitch.bottomAnchor, constant: 8.0),
            self.sliderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        ])
        
    }
    
    
    // MARK: User Interactions
    
    @objc func sliderValueDidChange(sender: UISlider!) {
        sender.value = round(sender.value / 10) * 10
        sliderLabel.text = String(sender.value)
    }
    
    @objc func acceptFilter(sender: UIButton!) {
        dismiss(animated: true)
    }
}
