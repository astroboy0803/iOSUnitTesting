@testable import ManageDifficultDependencies
import XCTest

class ClosurePropertyViewControllerTests: XCTestCase {
    func test_viewDidAppear() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ClosurePropertyViewController = storyboard.instantiateViewController(identifier: .init(describing: ClosurePropertyViewController.self))
        sut.loadViewIfNeeded()
        sut.makeAnalytics = { .init() }
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
    }
}
