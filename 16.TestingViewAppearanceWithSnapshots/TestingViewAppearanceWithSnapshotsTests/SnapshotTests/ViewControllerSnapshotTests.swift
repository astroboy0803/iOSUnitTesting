import iOSSnapshotTestCase
@testable import TestingViewAppearanceWithSnapshots

final class ViewControllerSnapshotTests: FBSnapshotTestCase {
    private var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let env = ProcessInfo().environment
        guard let device = env["SIMULATOR_DEVICE_NAME"], let version = env["SIMULATOR_RUNTIME_VERSION"], device.hasSuffix("iPhone 13 Pro") && version == "15.5" else {
            fatalError("device and version are not match")
        }
        
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
