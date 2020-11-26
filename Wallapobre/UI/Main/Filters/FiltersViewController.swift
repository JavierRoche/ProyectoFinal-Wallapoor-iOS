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
        let view: UIView = UIView()
        view.layer.cornerRadius = 8.0
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var filtersByCategoryLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.filtersByCategory
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var acceptButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        button.setImage(UIImage(systemName: Constants.iconCheckmark, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)), for: .normal)
        button.layer.cornerRadius = button.frame.size.height / 2
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor.tangerine
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.tangerine.cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector (acceptFilter), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var motorLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.motor.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textileLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.textile.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var homesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.homes.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var informaticLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.informatic.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sportsLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.sports.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var servicesLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle16SemiBold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Category.services.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var motorSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.onTintColor = UIColor.tangerine
        switchy.set(width: 40, height: 24)
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var textileSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.onTintColor = UIColor.tangerine
        switchy.set(width: 40, height: 24)
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var homesSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.onTintColor = UIColor.tangerine
        switchy.set(width: 40, height: 24)
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var informaticSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.onTintColor = UIColor.tangerine
        switchy.set(width: 40, height: 24)
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var sportsSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.onTintColor = UIColor.tangerine
        switchy.set(width: 40, height: 24)
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var servicesSwitch: UISwitch = {
        let switchy: UISwitch = UISwitch()
        switchy.onTintColor = UIColor.tangerine
        switchy.set(width: 40, height: 24)
        switchy.translatesAutoresizingMaskIntoConstraints = false
        return switchy
    }()
    
    lazy var filterByDistanceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle18Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.filterByDistance
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider: UISlider = UISlider()
        slider.maximumValue = 50
        slider.minimumValue = 0
        slider.tintColor = UIColor.tangerine
        slider.isContinuous = true
        slider.addTarget(self, action: #selector (sliderValueDidChange), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var valueSliderLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.fontStyle22Bold
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.text = Constants.maxDistance
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    /// Objeto del modelo que contiene las caracteristicasa del filtro
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
        motorSwitch.isOn = self.viewModel.filter.motor
        textileSwitch.isOn = self.viewModel.filter.textile
        homesSwitch.isOn = self.viewModel.filter.homes
        informaticSwitch.isOn = self.viewModel.filter.informatic
        sportsSwitch.isOn = self.viewModel.filter.sports
        servicesSwitch.isOn = self.viewModel.filter.services
        valueSliderLabel.text = String(Int(self.viewModel.filter.distance))
        slider.value = Float(self.viewModel.filter.distance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let newFilter: FiltersViewModel = FiltersViewModel.init(motor: motorSwitch.isOn, textile: textileSwitch.isOn, homes: homesSwitch.isOn, informatic: informaticSwitch.isOn, sports: sportsSwitch.isOn, services: servicesSwitch.isOn, distance: Double(slider.value), text: String())
        /// Si el filtro se ha modificado con respecto al actual
        if newFilter != self.viewModel {
            delegate?.newFilterCreated(filter: newFilter.filter)
        }
    }
    
    
    // MARK: User Interactions
    
    @objc private func sliderValueDidChange(sender: UISlider!) {
        sender.value = round(sender.value / 10) * 10
        DispatchQueue.main.async { [weak self] in
            self?.valueSliderLabel.text = String(Int(sender.value))
        }
    }
    
    @objc private func acceptFilter(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
}
