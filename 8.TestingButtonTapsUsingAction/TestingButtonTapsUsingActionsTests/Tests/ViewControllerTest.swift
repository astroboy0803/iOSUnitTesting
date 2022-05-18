import XCTest
@testable import TestingButtonTapsUsingActions

class ViewControllerTest: XCTestCase {
    
    var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(identifier: String(describing: ViewController.self))
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_outlets_shouldBeConnected() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.button, "button")
    }
    
    func test_tappingButton() {
        sut.loadViewIfNeeded()
        tap(sut.button)
    }
}
