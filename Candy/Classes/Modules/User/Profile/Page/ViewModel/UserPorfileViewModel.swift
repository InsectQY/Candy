//
//  UserPorfileViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UserPorfileViewModel: ViewModel {

    struct Input {
        let userID: String
    }

    struct Output {

        let userProfile: Driver<UserProfileModel>
    }
}

extension UserPorfileViewModel: ViewModelable {

    func transform(input: UserPorfileViewModel.Input) -> UserPorfileViewModel.Output {

        let userProfile = VideoApi
        .userProfile(input.userID)
        .request()
        .asObservable()
        .mapObject(UserProfileModel.self)
        .asDriverOnErrorJustComplete()

        let output = Output(userProfile: userProfile)
        return output
    }
}
