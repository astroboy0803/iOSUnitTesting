@testable import ManageDifficultDependencies
import XCTest

private class TestableOverrideViewController: OverrideViewController {
    override func analytics() -> Analytics {
        .init()
    }
}

class OverrideViewControllerTests: XCTestCase {
    func test_viewDidAppear() {
        let sut = TestableOverrideViewController()
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
    }
}
