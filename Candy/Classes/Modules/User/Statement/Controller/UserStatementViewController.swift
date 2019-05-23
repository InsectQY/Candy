//
//  UserStatementViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/7.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class UserStatementViewController: WebViewController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadURL(_ urlString: String?) {
        super.loadURL("http://www.bjshenchao.com/yszc.html")
    }
}
