//
//  FiltersViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

final class FiltersViewModel {
    var filter = Filter()
    
    
    // MARK: Inits
    
    init(motor: Bool, textile: Bool, homes: Bool, informatic: Bool, sports: Bool, services: Bool, distance: Float){
        filter.motor = motor
        filter.textile = textile
        filter.homes = homes
        filter.informatic = informatic
        filter.sports = sports
        filter.services = services
        filter.distance = distance
    }
    
    convenience init() {
        self.init(motor: false, textile: false, homes: false, informatic: false, sports: false, services: false, distance: 20.0)
    }
    
    
    // MARK: Public Functions
    
    func setFilter(motorSwitchValue: Bool, textileSwitchValue: Bool, homesSwitchValue: Bool,
                   informaticSwitchValue: Bool, sportsSwitchValue: Bool, servicesSwitchValue: Bool, slideValue: Float) -> Filter {
        filter.motor = motorSwitchValue
        filter.textile = textileSwitchValue
        filter.homes = homesSwitchValue
        filter.informatic = informaticSwitchValue
        filter.sports = sportsSwitchValue
        filter.services = servicesSwitchValue
        filter.distance = slideValue
        
        return filter
    }
}

struct Filter : Equatable {
    var motor: Bool = false
    var textile: Bool = false
    var homes: Bool = false
    var informatic: Bool = false
    var sports: Bool = false
    var services: Bool = false
    var distance: Float = 20.0
}
