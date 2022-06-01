import XCTest
@testable import TestingNetworkRequestsWithMocks

class ViewControllerTests: XCTestCase {
    
    private var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.button, "Request Button")
    }
    
    func test_tappingButton_shouldMakeDataTaskToSearchForEBookOutFromBoneville() {
        let mockURLSession = MockURLSession()
        sut.session = mockURLSession
        tap(sut.button)
        
        mockURLSession.verifyDataTask(with: .init(url: .init(string: "https://itunes.apple.com/search?media=ebook&term=out%20from%20boneville")!))
    }
}
