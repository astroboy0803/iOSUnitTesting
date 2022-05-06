import XCTest
@testable import ManageDifficultDependencies

class ClosureInitializerViewControllerTests: XCTestCase {
    
    func test_viewDidAppear() {
        let sut = ClosureInitializerViewController {
            .init()
        }
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
    }
}
