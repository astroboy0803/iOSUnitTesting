import XCTest
@testable import LoadViewController

class CodeBasedViewControllerTests: XCTestCase {
    func test_loading() {
        let sut = CodeBasedViewController(data: "DUMMY")
        sut.loadViewIfNeeded()
    }
}
