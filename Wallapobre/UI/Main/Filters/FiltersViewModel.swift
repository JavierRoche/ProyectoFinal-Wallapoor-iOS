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
