@testable import TestingOutletConnections
import XCTest

class OutletConnectionsViewControllerTest: XCTestCase {
    func test_outlets_shouldBeConnected() {
        let sut = OutletConnectionsViewController()
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.label, "label")
        XCTAssertNotNil(sut.button, "button")
    }
}
