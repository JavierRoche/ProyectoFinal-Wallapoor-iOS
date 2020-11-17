//
//  FiltersViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

final class FiltersViewModel: Equatable {
    var filter: Filter
    
    
    // MARK: Inits
    
    init(){
        self.filter = Filter()
    }
    
    convenience init(filter: Filter) {
        self.init()
        self.filter = filter
    }
    
    convenience init(motor: Bool, textile: Bool, homes: Bool, informatic: Bool, sports: Bool, services: Bool, distance: Double, text: String) {
        self.init()
        
        self.filter.motor = motor
        self.filter.textile = textile
        self.filter.homes = homes
        self.filter.informatic = informatic
        self.filter.sports = sports
        self.filter.services = services
        self.filter.distance = distance
        self.filter.text = text
    }
    
    
    // MARK: Public Functions
    
    /*func setFilter(motorSwitchValue: Bool, textileSwitchValue: Bool, homesSwitchValue: Bool,
                   informaticSwitchValue: Bool, sportsSwitchValue: Bool, servicesSwitchValue: Bool, slideValue: Double, text: String) -> Filter {
        filter.motor = motorSwitchValue
        filter.textile = textileSwitchValue
        filter.homes = homesSwitchValue
        filter.informatic = informaticSwitchValue
        filter.sports = sportsSwitchValue
        filter.services = servicesSwitchValue
        filter.distance = slideValue
        filter.text = text
        
        return filter
    }*/
    
    
    // MARK: Equatable
    
    static func == (lhs: FiltersViewModel, rhs: FiltersViewModel) -> Bool {
        return lhs.filter == rhs.filter
    }
}

struct Filter: Equatable {
    var motor: Bool = true
    var textile: Bool = true
    var homes: Bool = true
    var informatic: Bool = true
    var sports: Bool = true
    var services: Bool = true
    var distance: Double = 50.0
    var text: String = String()
}
