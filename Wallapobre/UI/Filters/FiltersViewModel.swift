//
//  FiltersViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 31/10/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import UIKit

class FiltersViewModel {
    var filter = Filter()
    
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

struct Filter {
    var motor: Bool = false
    var textile: Bool = false
    var homes: Bool = false
    var informatic: Bool = false
    var sports: Bool = false
    var services: Bool = false
    var distance: Float = 20.0
}

