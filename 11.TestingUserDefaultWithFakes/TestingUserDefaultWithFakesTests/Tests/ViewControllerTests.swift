@testable import TestingUserDefaultWithFakes
import XCTest

class ViewControllerTests: XCTestCase {
    private var sut: ViewController!
    private var defaults: FakeUserDefaults!

    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(identifier: String(describing: ViewController.self))
        defaults = .init()
        sut.userDefaults = defaults
    }

    override func tearDown() {
        sut = nil
        defaults = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.counterLabel, "Counter Label")
        XCTAssertNotNil(sut.incrementButton, "Increment Button")
    }

    func test_viewDidLoad_with7InUserDefaults_shouldShow7InCounterLabel() {
        defaults.integers = ["count": 7]
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.counterLabel.text, "7")
    }

    func test_tappingButton_with12InUserDefaults_shouldWrite13ToUserDefaults() {
        defaults.integers = ["count": 12]
        sut.loadViewIfNeeded()

        tap(sut.incrementButton)

        XCTAssertEqual(defaults.integers["count"], 13)
    }

    func test_tappingButton_with42InUserDefaults_shouldShow43InCounterLabel() {
        defaults.integers = ["count": 42]
        sut.loadViewIfNeeded()

        tap(sut.incrementButton)

        XCTAssertEqual(sut.counterLabel.text, "43")
    }
}
