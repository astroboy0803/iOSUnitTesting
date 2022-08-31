@testable import ManageDifficultDependencies
import XCTest

class InstanceInitializerViewControllerTests: XCTestCase {
    func test_viewDidAppear() {
        let sut = InstanceInitializerViewController(analytics: .init())
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
    }
}
