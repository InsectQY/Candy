//
//  PYSearchViewController+Rx.swift
//  Candy
//
//  Created by Insect on 2019/5/21.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation
import PYSearch

extension Reactive where Base: PYSearchViewController {

    var searchSuggestions: Binder<[String]> {

        Binder(base) { vc, suggestions in
            vc.searchSuggestions = suggestions
        }
    }
}
