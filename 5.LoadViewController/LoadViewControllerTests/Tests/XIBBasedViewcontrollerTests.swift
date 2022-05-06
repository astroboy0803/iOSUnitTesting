import XCTest
@testable import LoadViewController

class XIBBasedViewcontrollerTests: XCTestCase {
    func test_loading() {
        let sut = XIBBasedViewController()
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.label)
    }
}
