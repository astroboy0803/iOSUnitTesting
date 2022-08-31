//
//  CoveredClassTests.swift
//  CodeCoverageTests
//
//  Created by BruceHuang on 2022/5/1.
//

@testable import CodeCoverage
import XCTest

class CoveredClassTests: XCTestCase {
    // characterization test
    // 1. call from the test and get result
    // 2. assertion
    // 3. run the test
    // 4. adjustment
    // 5. test pass

//    func test_max_with1And2_shouldReturnSomething() {
//        let result = CoveredClass.max(1, 2)
//        XCTAssertEqual(result, -123)
//    }

    // good test name
    // 1. what the test is exercising -> function name
    // 2. the condition of the test -> input information
    // 3. the expected result

    func test_max_with1And2_shouldReturn2() {
        let result = CoveredClass.max(1, 2)
        XCTAssertEqual(result, 2)
    }

    func test_max_with3And2_shouldReturn3() {
        let result = CoveredClass.max(3, 2)
        XCTAssertEqual(result, 3)
    }

    func test_commaSeparated_from2to4_shouldReturn234SeparatedByCommas() {
        let result = CoveredClass.commaSeparated(from: 2, to: 4)
        XCTAssertEqual(result, "2,3,4")
    }

    func test_commaSeparated_from2to4_shouldReturn2WithNoComma() {
        let result = CoveredClass.commaSeparated(from: 2, to: 2)
        XCTAssertEqual(result, "2")
    }

    func test_area_withWidth7_shouldBe49() {
        let sut = CoveredClass()
        sut.width = 7
        XCTAssertEqual(sut.area, 49)
    }
}
