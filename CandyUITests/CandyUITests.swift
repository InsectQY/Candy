//
//  CandyUITests.swift
//  CandyUITests
//
//  Created by apple on 2019/2/14.
//  Copyright © 2019 Insect. All rights reserved.
//

import XCTest

class CandyUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {

        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {

    }

    func testExample() {

    }

    func testScreenshotSearch() {
    XCUIApplication().navigationBars["Candy.VideoHallView"].staticTexts.children(matching: .textField).element.tap()

        snapshot("01_videoHall_search_screen")
    }

    func testScreenshotVideoList() {

        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["视频"].tap()
        sleep(5)
        snapshot("02_videoList_screen")
    }

    func testScreenshotUGCList() {

        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["小视频"].tap()
        sleep(5)
        snapshot("03_UGCVideo_screen")
    }
}
