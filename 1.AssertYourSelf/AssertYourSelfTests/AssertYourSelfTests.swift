//
//  AssertYourSelfTests.swift
//  AssertYourSelfTests
//
//  Created by BruceHuang on 2022/4/26.
//

@testable import AssertYourSelf
import XCTest

class AssertYourSelfTests: XCTestCase {
    func test_fail() {
        XCTFail("We have a problem")
    }

    func test_fail_withInterpolatedMessage() {
        let answer = 42
        XCTFail("The Answer to the Greate Question is \(answer)")
    }

    func test_avoidConditionalCode() {
        let success = false
        if !success {
            XCTFail()
        }
    }

    func test_assertTrue() {
        let success = false
        XCTAssertTrue(success)
    }

    func test_assertNil() {
        let optionalValue: Int? = 123
        XCTAssertNil(optionalValue)
    }

    struct SimpleStruct {
        let x: Int
        let y: Int
    }

    func test_assertNil_withSimpleStruct() {
        let optionalValue: SimpleStruct? = .init(x: 1, y: 2)
        XCTAssertNil(optionalValue)
    }

    struct StructWithDescription: CustomStringConvertible {
        let x: Int
        let y: Int
        var description: String {
            "(\(x), \(y))"
        }
    }

    func test_assertNil_withSelfDescribingType() {
        let optionalValue: StructWithDescription? = .init(x: 1, y: 2)
        XCTAssertNil(optionalValue)
    }

    func test_assertEqual() {
        let actual = "actual"
        XCTAssertEqual(actual, "expected")
    }

    func test_assertEqual_withOptional() {
//        let result: String? = "foo"
        // 另一種optional的寫法
        let result: String? = .some("foo")
        XCTAssertEqual(result, "bar")
    }

    func test_floatingPointDanger() {
        let result = 0.1 + 0.2
        XCTAssertEqual(result, 0.3)
    }

    func test_floatingPointFixed() {
        let result = 0.1 + 0.2
//        XCTAssertEqual(result, 0.3)
        // result因浮點數溢位問題 = 0.30000000000000004
        // result - 0.3 = 0.00000000000000004
        // 所以accuracy > 0.00000000000000004 = success
        // 反之 fail
//        XCTAssertEqual(result, 0.3, accuracy: 0.00000000000000003)
//        XCTAssertEqual(result, 0.3, accuracy: 0.00000000000000004)
        XCTAssertEqual(result, 0.3, accuracy: 0.0000000000000000556)
//        XCTAssertEqual(result, 0.3, accuracy: 0.00000000000000006)
    }

    func test_messageOverkill() {
        let actual = "actual"
        XCTAssertEqual(actual, "expected", "Expected \"expected\" but got \"\(actual)\"")
    }
}
