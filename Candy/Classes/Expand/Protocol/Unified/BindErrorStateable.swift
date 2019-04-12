//
//  BindErrorStateable.swift
//  Candy
//
//  Created by Insect on 2019/4/12.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

protocol BindErrorStateable: class {

    func bindErrorToShowToast(_ error: ErrorTracker)
}
