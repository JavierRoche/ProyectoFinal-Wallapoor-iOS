//
//  DiscussionCellViewModel.swift
//  Wallapobre
//
//  Created by APPLE on 25/11/2020.
//  Copyright © 2020 Javier Roche. All rights reserved.
//

import Foundation

class DiscussionCellViewModel {
    var discussion: Discussion!
    var product: Product!


    // MARK: Inits

    init(discussion: Discussion, product: Product){
        self.discussion = discussion
        self.product = product
    }
}
