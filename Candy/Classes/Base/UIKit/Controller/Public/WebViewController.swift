//
//  WebViewController.swift
//  SwiftHub
//
//  Created by Insect on 7/19/18.
//  Copyright © 2018 Insect. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: ViewController {

    private lazy var webView: WKWebView = {

        let webView = WKWebView(frame: UIScreen.main.bounds)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func makeUI() {
        super.makeUI()
        view.addSubview(webView)
    }

    func loadURL(_ urlString: String?) {

        guard
            let urlString = urlString,
            let url = URL(string: urlString)
        else { return }
        webView.load(URLRequest(url: url))
    }
}
