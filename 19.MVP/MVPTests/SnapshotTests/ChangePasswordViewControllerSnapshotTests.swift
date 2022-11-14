import iOSSnapshotTestCase
@testable import MVP

final class ChangePasswordViewControllerSnapshotTests: FBSnapshotTestCase {
    
    private var sut: ChangePasswordViewController!
    
    override func setUp() {
        super.setUp()
        
        let env = ProcessInfo().environment
        guard let device = env["SIMULATOR_DEVICE_NAME"], let version = env["SIMULATOR_RUNTIME_VERSION"], device.hasSuffix("iPhone 13 Pro") && version == "15.5" else {
            fatalError("device and version are not match")
        }
        
        recordMode = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        sut.labels = .init(okButtonLabel: "OK", enterNewPasswordMessage: "Please enter a new password.", newPasswordTooShortMessage: "The new password should at least 6 characters.", confirmationPasswordDoesNotMatchMessage: "Ther new password and the confirmation password don't match. Please try again.", successMessage: "Your password has been successfully changed.")
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_blur() {
        setupValidPasswordEntries()
        tap(sut.submitButton)
//        FBSnapshotVerifyViewController(sut)
        verifySnapshot()
    }
    
    private func verifySnapshot(file: StaticString = #file, line: UInt = #line) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.addSubview(sut.view)
        FBSnapshotVerifyViewController(sut, file: file, line: line)
    }
}

extension ChangePasswordViewControllerSnapshotTests {
    private func setupValidPasswordEntries() {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
}
