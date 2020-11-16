//
//  FiltersViewController.swift
//  Wallapobre
//
//  Created by APPLE on 30/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func newFilterCreated(filter: Filter)
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
        label.text = Constants.Filtros
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var acceptButton: UIButton = {
        let button: UIButton = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(Constants.Accept, for: .normal)
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
        label.text = Constants.CATEGORIES
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var motorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.motor.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.textile.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var homesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.homes.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var informaticLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.informatic.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sportsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.sports.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var servicesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.services.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var motorSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        //switchy.isOn = true
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var textileSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        //switchy.isOn = true
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var homesSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        //switchy.isOn = true
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var informaticSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        //switchy.isOn = true
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var sportsSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        //switchy.isOn = true
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var servicesSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        //switchy.isOn = true
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var slider: UISlider = {
        let slider: UISlider = UISlider()
        slider.maximumValue = 50
        slider.minimumValue = 0
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
        label.text = Constants.number50
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
        DispatchQueue.main.async { [weak self] in
            self?.motorSwitch.isOn = self!.viewModel.filter.motor
            self?.textileSwitch.isOn = self!.viewModel.filter.textile
            self?.homesSwitch.isOn = self!.viewModel.filter.homes
            self?.informaticSwitch.isOn = self!.viewModel.filter.informatic
            self?.sportsSwitch.isOn = self!.viewModel.filter.sports
            self?.servicesSwitch.isOn = self!.viewModel.filter.services

            self?.sliderLabel.text = String(Int(self!.viewModel.filter.distance))
            self?.slider.value = Float(self!.viewModel.filter.distance)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let newFilter: FiltersViewModel = FiltersViewModel.init(motor: motorSwitch.isOn, textile: textileSwitch.isOn, homes: homesSwitch.isOn, informatic: informaticSwitch.isOn, sports: sportsSwitch.isOn, services: servicesSwitch.isOn, distance: Double(slider.value), text: String())
        /// Si el filtro se ha modificado con respecto al actual
        if newFilter != self.viewModel {
            delegate?.newFilterCreated(filter: newFilter.filter)
        }
    }
    
    
    // MARK: User Interactions
    
    @objc func sliderValueDidChange(sender: UISlider!) {
        sender.value = round(sender.value / 10) * 10
        DispatchQueue.main.async { [weak self] in
            self?.sliderLabel.text = String(Int(sender.value))
        }
    }
    
    @objc func acceptFilter(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
}
