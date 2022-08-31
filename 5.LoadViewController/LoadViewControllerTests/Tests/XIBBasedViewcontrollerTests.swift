@testable import LoadViewController
import XCTest

class XIBBasedViewcontrollerTests: XCTestCase {
    func test_loading() {
        let sut = XIBBasedViewController()
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.label)
    }
}
