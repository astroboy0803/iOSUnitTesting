//
//  MySingletonViewControllerTests.swift
//  ManageDifficultDependenciesTests
//
//  Created by BruceHuang on 2022/5/6.
//

@testable import ManageDifficultDependencies
import XCTest

class MySingletonViewControllerTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        MySingletonAnalytics.stubbedInstance = .init()
    }

    override class func tearDown() {
        MySingletonAnalytics.stubbedInstance = nil
        super.tearDown()
    }

    func test_viewDidAppear() {
        let sut = MySingletonViewController()
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
    }
}
