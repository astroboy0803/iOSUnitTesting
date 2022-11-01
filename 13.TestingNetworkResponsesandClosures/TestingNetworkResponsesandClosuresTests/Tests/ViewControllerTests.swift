@testable import TestingNetworkResponsesandClosures
import ViewControllerPresentationSpy
import XCTest

class ViewControllerTests: XCTestCase {
    private var sut: ViewController!
    private var alertVerifier: AlertVerifier!
    private var spyURLSession: SpyURLSession!

    override func setUp() {
        super.setUp()
        alertVerifier = .init()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(identifier: String(describing: ViewController.self))
        spyURLSession = .init()
        sut.session = spyURLSession
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        alertVerifier = nil
        sut = nil
        spyURLSession = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.button, "Request Button")
    }

    func test_searchForBookCall_withSuccessResponse_shouldSavaDataInResults() {
        let handleResultCalled = expectation(description: "handleResults")
        sut.handleResults = { _ in
            handleResultCalled.fulfill()
        }
        tap(sut.button)
        spyURLSession.dataTaskArgsCompletionHandler.first?(jsonData(), response(statusCode: 200), nil)
        waitForExpectations(timeout: 0.01)

        // assert 也可以加在 closure 中
        // 1. 為符合 Arrange Act Assert 原則
        // 2. 程式 top-down 以提升可讀性與維護性
        XCTAssertEqual(sut.results, [.init(artistName: "Artist", trackName: "Track", averageUserRating: 2.5, genres: ["Foo", "Bar"])])
    }

    func test_searchForBookNetworkCall_withSuccessBeforeAsync_shouldNotSaveDataInResults() {
        tap(sut.button)
        spyURLSession.dataTaskArgsCompletionHandler.first?(jsonData(), response(statusCode: 200), nil)
        XCTAssertEqual(sut.results, [])
    }

    private func jsonData() -> Data {
        """
        {
            "results": [
                {
                    "artistName": "Artist",
                    "trackName": "Track",
                    "averageUserRating": 2.5,
                    "genres": [
                        "Foo",
                        "Bar"
                    ]
                }
            ]
        }
        """.data(using: .utf8)!
    }

    private func response(statusCode: Int) -> HTTPURLResponse? {
        .init(url: .init(string: "http://DUMMY")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }

    func test_searchForBookNetworkCall_withError_shouldShowAlert() {
        // arrange
        tap(sut.button)
        let alertShow = expectation(description: "alert show")
        alertVerifier.testCompletion = {
            alertShow.fulfill()
        }

        // act
        spyURLSession.dataTaskArgsCompletionHandler.first?(nil, nil, TestError(message: "oh no"))

        // assert
        waitForExpectations(timeout: 0.01)
        verifyErrorAlert(message: "oh no")
    }
    
    func test_searchForBookNetworkCall_withErrorPreAsync_shouldNotShowAlert() {
        tap(sut.button)
        spyURLSession.dataTaskArgsCompletionHandler.first?(nil, nil, TestError(message: "DUMMY"))
        XCTAssertEqual(alertVerifier.presentedCount, .zero)
    }

    private func verifyErrorAlert(message: String, file: StaticString = #file, line: UInt = #line) {
        alertVerifier.verify(title: "Network Problem", message: message, animated: true, actions: [.default("OK")], presentingViewController: sut, file: file, line: line)
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK", "preferred action", file: file, line: line)
    }
}
