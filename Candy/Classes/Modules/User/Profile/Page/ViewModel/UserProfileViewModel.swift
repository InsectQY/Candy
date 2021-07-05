//
//  UserProfileViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/3.
//  Copyright © 2019 Insect. All rights reserved.
//

import Foundation

final class UserProfileViewModel: ViewModel {

    struct Input {
        let userID: String
    }

    struct Output {
        let userProfile: Driver<UserProfileModel>
    }
}

extension UserProfileViewModel: ViewModelable {

    func transform(input: UserProfileViewModel.Input) -> UserProfileViewModel.Output {

        let userProfile = UserApi
        .profile(input.userID)
        .request()
        .mapKKModelData(UserProfileModel.self)
        .asObservable()
        .asDriverOnErrorJustComplete()

        let output = Output(userProfile: userProfile)
        return output
    }
}
