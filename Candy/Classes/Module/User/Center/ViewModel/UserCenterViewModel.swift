//
//  UserCenterViewModel.swift
//  QYNews
//
//  Created by Insect on 2019/1/7.
//  Copyright © 2019 Insect. All rights reserved.
// swiftlint:disable force_try

import Foundation

final class UserCenterViewModel: ViewModel {

    struct Input {
        let loginTap: ControlEvent<Void>
    }

    struct Output {

        let dataSource: Driver<[UserCenterModel]>
        let loginResult: Driver<UserInfoModel>
    }
}

extension UserCenterViewModel: ViewModelable {

    //  swiftlint:disable force_unwrapping
    func transform(input: UserCenterViewModel.Input) -> UserCenterViewModel.Output {

        // 用户中心tableView数据
        let data = try! Data(contentsOf: R.file.user_centerPlist()!)
        var dataSource = try! PropertyListDecoder().decode([UserCenterModel].self, from: data)
        dataSource.removeLast()
        dataSource.removeLast()

        // 点击了登录
        let loginRes = input.loginTap
        .filter { !userManager.isLogin() }
        .flatMapLatest { _  in
            WeChatApi.login()
            .catchErrorJustComplete()
        }.flatMapLatest { [unowned self] in
            self.request(token: $0.token, openid: $0.openID)
        }.asDriverOnErrorJustComplete()

        let output = Output(dataSource: Driver.just(dataSource),
                            loginResult: loginRes)
        return output
    }
}

extension UserCenterViewModel {

    func request(token: String, openid: String) -> Driver<UserInfoModel> {

        return WeChatApi.userInfo(token: token, openid: openid)
        .request()
        .trackActivity(loading)
        .trackError(error)
        .mapObject(UserInfoModel.self, atKeyPath: nil)
        .asDriverOnErrorJustComplete()
    }
}
