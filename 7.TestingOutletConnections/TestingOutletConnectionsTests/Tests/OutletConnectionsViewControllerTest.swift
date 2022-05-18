import XCTest
@testable import TestingOutletConnections

class OutletConnectionsViewControllerTest: XCTestCase {
    func test_outlets_shouldBeConnected() {
        let sut = OutletConnectionsViewController()
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.label, "label")
        0(sut.button, "button0")
    }
}
