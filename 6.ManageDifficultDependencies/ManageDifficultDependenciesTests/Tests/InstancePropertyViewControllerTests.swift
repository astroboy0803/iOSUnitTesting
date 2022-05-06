import XCTest
@testable import ManageDifficultDependencies

class InstancePropertyViewControllerTests: XCTestCase {
    
    func test_viewDidAppear() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: InstancePropertyViewController = storyboard.instantiateViewController(identifier: String(describing: InstancePropertyViewController.self))
        sut.analytics = .init()
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
    }
}
