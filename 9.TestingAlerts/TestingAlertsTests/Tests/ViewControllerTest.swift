@testable import TestingAlerts
import ViewControllerPresentationSpy
import XCTest

class ViewControllerTest: XCTestCase {
    private var sut: ViewController!

    private var alertVerifier: AlertVerifier!

    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
        alertVerifier = .init()
    }

    override func tearDown() {
        sut = nil
        alertVerifier = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.button, "button")
    }

    func test_tappingButton() {
        tap(sut.button)

        // verify就會做驗證
        // 有沒有alert被present
        // title和message是否一致
        // present是否有animation
        // present style(default為.alert)
        // present alert的viewcontroller是不是目前的頁面
        // 自行驗證
        // AlertVerifier的preferredAction與設定是否一致
        alertVerifier.verify(
            title: "Do the Thing?",
            message: "Let us know if you want to do the thing.",
            animated: true,
            actions: [.cancel("Cancel"), .default("OK")],
            presentingViewController: sut
        )
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK", "preferred action")
    }

    func test_executeAlertAction_withOKButton() {
        tap(sut.button)
        do {
            try alertVerifier.executeAction(forButton: "OK")
            // check something
        } catch {
            XCTFail("not found OK button")
        }
    }

    func test_executeAlertAction_withCancelButton() {
        tap(sut.button)
        do {
            try alertVerifier.executeAction(forButton: "Cancel")
            // check something
        } catch {
            XCTFail("not found Cancel button")
        }
    }
}
