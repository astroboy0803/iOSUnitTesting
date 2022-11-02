import iOSSnapshotTestCase
@testable import TestingViewAppearanceWithSnapshots

final class ViewControllerSnapshotTests: FBSnapshotTestCase {
    
    private var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: .init(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_example() {
        FBSnapshotVerifyViewController(sut)
    }
}
