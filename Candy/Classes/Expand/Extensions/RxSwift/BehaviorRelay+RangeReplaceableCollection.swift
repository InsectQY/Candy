//
//  BehaviorRelay+RangeReplaceableCollection.swift
//  RxSwiftX
//
//  Created by Insect on 2019/5/27.
//  Copyright © 2018年 Insect. All rights reserved.
//

import RxCocoa

public extension BehaviorRelay where Element: RangeReplaceableCollection {

    var append: AnyObserver<Element> {

        return AnyObserver { [weak self] event in

            guard let self = self else { return }
            
            switch event {
            case .next(let data):
                self.accept(self.value + data)
            case .error(let error):
                print("Data Task Error: \(error)")
            default:
                break
            }
        }
    }
}
