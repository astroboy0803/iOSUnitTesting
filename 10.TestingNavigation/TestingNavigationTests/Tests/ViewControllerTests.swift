@testable import TestingNavigation
import ViewControllerPresentationSpy
import XCTest

class ViewControllerTests: XCTestCase {
    var sut: ViewController!

    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(identifier: String(describing: ViewController.self))
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.codePushButton, "Code Push Button")
        XCTAssertNotNil(sut.codeModalButton, "Code Modal Button")
        XCTAssertNotNil(sut.seguePushButton, "Segue Push Button")
        XCTAssertNotNil(sut.segueModalButton, "Segue Modal Button")
    }

    func test_NavigationPushAnimated_shouldTrue() {
        let spyNav = SpyNavigationController(rootViewController: sut)
        XCTAssertNotNil(sut.navigationController)
        tap(sut.codePushButton)
        executeRunLoop()
        XCTAssertNotNil(spyNav.pushViewControllerArgsAnimated.last)
        XCTAssertTrue(spyNav.pushViewControllerArgsAnimated.last!, "Navigation animated flag")
    }

    func test_tappingCodePushButton_shouldPushCodeNextViewController() {
        // StoryBoard的embed navigation必須使用stroyboard的方式叫起viewcontroller才會有效
        // 以程式找出在stroyboard的viewcontroller並初始化的方式是不會embed navigation
        // 也就是說 viewcontroller的navigationController property為nil

        XCTAssertNil(sut.navigationController)
        // 如果要驗證 animated flag, UINavigationController -> SpyNavigationController
        let nav = UINavigationController(rootViewController: sut)
        XCTAssertNotNil(sut.navigationController)
        tap(sut.codePushButton)
        executeRunLoop()
        XCTAssertEqual(nav.viewControllers.count, 2, "navigation stack")

        guard
            let pushedVC = nav.viewControllers.last,
            let codeNextVC = pushedVC as? CodeNextViewController
        else {
            XCTFail("Expected CodeNextViewController, but was \(String(describing: nav.viewControllers.last))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Pushed from code")
    }

    func test_INCORRECT_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        // 要能夠正常的present, viewController必須在目前的window hierarchy中
        UIApplication.shared.windows.first?.rootViewController = sut
        // 這個方法必須把viewcontroller放到window中, 這會導致在測試結束後, 無法將ViewController和PresentedViewController回收
        tap(sut.codeModalButton)
        guard
            let presentedVC = sut.presentedViewController,
            let codeNextVC = presentedVC as? CodeNextViewController
        else {
            XCTFail("Expected CodeNextViewController, but was \(String(describing: sut.presentedViewController))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Modal from code")
    }

    func test_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        let diss = DismissalVerifier()
        let presentationVerifier = PresentationVerifier()
        tap(sut.codeModalButton)
        let codeNextVC: CodeNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(codeNextVC?.label.text, "Modal from code")
    }

    func test_tappingSeguePushButton() {
        let presentationVerifier = PresentationVerifier()
        putInWindow(sut)
        tap(sut.seguePushButton)
        let segueNextVC: SegueNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(segueNextVC?.labelText, "Pushed from segue")
    }

    func test_tappingSegueModalButton_shouldShowSegueNextViewController() {
        // 無法順利將兩個viewcontroller給釋放掉
        let presentationVerifier = PresentationVerifier()
        tap(sut.segueModalButton)
        let segueNextVC: SegueNextViewController? = presentationVerifier.verify(animated: true, presentingViewController: sut)
        XCTAssertEqual(segueNextVC?.labelText, "Modal from segue")
    }
}

class SpyNavigationController: UINavigationController {
    private(set) var pushViewControllerArgsAnimated: [Bool] = []
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushViewControllerArgsAnimated.append(animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        defer {
            _ = pushViewControllerArgsAnimated.dropLast()
        }
        return super.popViewController(animated: animated)
    }
}

// 適用於code base或 xib
class TestableViewController: ViewController {
    var presentCallCount = 0
    var presentArgsViewController: [UIViewController] = []
    var presentArgsAnimated: [Bool] = []
    var presentArgsClosure: [(() -> Void)?] = []

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCallCount += 1
        presentArgsViewController.append(viewControllerToPresent)
        presentArgsAnimated.append(flag)
        presentArgsClosure.append(completion)
    }
}
