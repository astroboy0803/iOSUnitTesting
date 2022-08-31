//
//  MyClassTests.swift
//  TestLifeCycleTests
//
//  Created by BruceHuang on 2022/5/1.
//

@testable import TestLifeCycle
import XCTest

class MyClassTests: XCTestCase {
    // Problems without Clean Room:
    // 1. 在使用前就init
    // 2. deinit不會被執行
    // 3. global side effects
    private var sut: MyClass!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_methodOne() {
        sut.methodOne()
    }

    func test_methodTwo() {
        sut.methodTwo()
    }
}
