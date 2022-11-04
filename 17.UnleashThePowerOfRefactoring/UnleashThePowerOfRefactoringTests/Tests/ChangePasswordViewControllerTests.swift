@testable import UnleashThePowerOfRefactoring
import ViewControllerPresentationSpy
import XCTest

final class ChangePasswordViewControllerTests: XCTestCase {
    private var sut: ChangePasswordViewController!
    
    private var passwordChanger: MockPasswordChanger!
    
    private var alertVerifier: AlertVerifier!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        passwordChanger = .init()
        sut.passwordChanger = passwordChanger
        alertVerifier = .init()
        
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        executeRunLoop()
        sut = nil
        passwordChanger = nil
        alertVerifier = nil
        super.tearDown()
    }
    
    // MARK: outlet connected
        
    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.navigationBar, "navigationBar")
        XCTAssertNotNil(sut.cancelBarButton, "cancelBarButton")
        XCTAssertNotNil(sut.oldPasswordTextField, "oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField, "newPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField, "confirmPasswordTextField")
        XCTAssertNotNil(sut.submitButton, "submitButton")
    }
    
    // MARK: components' attributes
    
    func test_navigationBar_shouldHaveTitle() {
        XCTAssertEqual(sut.navigationBar.topItem?.title, "Change Password")
    }
    
    func test_cancelBarButton_shouldBeSystemItemCancel() {
        XCTAssertEqual(systemItem(for: sut.cancelBarButton), .cancel)
    }
    
    func test_oldPasswordTextField_shouldHavePlaceHolder() {
        XCTAssertEqual(sut.oldPasswordTextField.placeholder, "Current Password")
    }
    
    func test_newPasswordTextField_shouldHavePlaceHolder() {
        XCTAssertEqual(sut.newPasswordTextField.placeholder, "New Password")
    }
    
    func test_confirmPasswordTextField_shouldHavePlaceHolder() {
        XCTAssertEqual(sut.confirmPasswordTextField.placeholder, "Confirm New Password")
    }
    
    func test_oldPasswordTextField_shouldHavePasswordAttributes() {
        let textField = sut.oldPasswordTextField!
        XCTAssertEqual(textField.textContentType, .password, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enablesReturnKeyAutomatically")
    }
    
    func test_newPasswordTextField_shouldHaveNewPasswordAttributes() {
        let textField = sut.newPasswordTextField!
        XCTAssertEqual(textField.textContentType, .newPassword, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enablesReturnKeyAutomatically")
    }
    
    func test_confirmPasswordTextField_shouldHaveNewPasswordAttributes() {
        let textField = sut.confirmPasswordTextField!
        XCTAssertEqual(textField.textContentType, .newPassword, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enablesReturnKeyAutomatically")
    }
    
    // MARK: Cancel Button
    
    private func putFocusOn(textField: UITextField) {
        putInViewHeirarychy(sut)
        textField.becomeFirstResponder()
    }
    
    func test_tappingCancel_withFocusOnOldPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.oldPasswordTextField)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_withFocusOnNewPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.newPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_withFocusOnConfirmPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.confirmPasswordTextField)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_shouldDismissModal() {
        let dismissalVerifier: DismissalVerifier = .init()
        tap(sut.cancelBarButton)
        dismissalVerifier.verify(animated: true, dismissedViewController: sut)
    }
    
    // MARK: Submit Button
    
    func test_tappingSubmit_withOldPasswordEmpty_shouldNotChangePassword() {
        setupValidPasswordEntries()
        sut.oldPasswordTextField.text = ""
        
        tap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withOldPasswordEmpty_shouldPutFocusOnOldPassword() {
        setupValidPasswordEntries()
        sut.oldPasswordTextField.text = ""
        putInViewHeirarychy(sut)
        tap(sut.submitButton)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }
    
    private func verifyAlertPresented(message: String, file: StaticString = #file, line: UInt = #line) {
        alertVerifier.verify(title: "", message: message, animated: true, actions: [.default("OK")], presentingViewController: sut, file: file, line: line)
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK", "preferred action", file: file, line: line)
    }
    
    func test_tappingSubmit_withNewPasswordEmpty_shouldNotChangePassword() {
        setupValidPasswordEntries()
        sut.newPasswordTextField.text = ""
        tap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withNewPasswordEmpty_shouldShowPasswordBlankAlert() {
        setupValidPasswordEntries()
        sut.newPasswordTextField.text = ""
        tap(sut.submitButton)
        verifyAlertPresented(message: "Please enter a new password.")
    }
    
    func test_tappingOKPasswordBlankAlert_shouldPutFocusOnNewPassword() throws {
        setupValidPasswordEntries()
        sut.newPasswordTextField.text = ""
        tap(sut.submitButton)
        putInViewHeirarychy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withNewPasswordTooShort_shouldNotChangePassword() {
        setupEntriesNewPasswordTooShort()
        tap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withNewPasswordTooShort_shouldShowTooShortAlert() {
        setupEntriesNewPasswordTooShort()
        tap(sut.submitButton)
        verifyAlertPresented(message: "The new password should at least 6 characters.")
    }
    
    func test_tappingOKInTooShortAlert_shouldClearNewAndConfirmation() throws {
        setupEntriesNewPasswordTooShort()
        tap(sut.submitButton)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirm")
    }
    
    func test_tappingOKInTooShortAlert_shouldNotClearOldPasswordField() throws {
        setupEntriesNewPasswordTooShort()
        tap(sut.submitButton)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, false)
    }
    
    func test_tappingOKInTooShortAlert_shouldPutFocusOnNewPassword() throws {
        setupEntriesNewPasswordTooShort()
        tap(sut.submitButton)
        putInViewHeirarychy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withConfirmationMismatch_shouldNotChangePassword() {
        setupMismatchedConfirmationEntry()
        tap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_tappingSubmit_withConfirmationMismatch_shouldShowMismatchAlert() {
        setupMismatchedConfirmationEntry()
        tap(sut.submitButton)
        verifyAlertPresented(message: "Ther new password and the confirmation password don't match. Please try again.")
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnOldPassword_resignsFocus() {
        setupValidPasswordEntries()
        putFocusOn(textField: sut.oldPasswordTextField)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnNewPassword_resignsFocus() {
        setupValidPasswordEntries()
        putFocusOn(textField: sut.newPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnConfirmPassword_resignsFocus() {
        setupValidPasswordEntries()
        putFocusOn(textField: sut.confirmPasswordTextField)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFields_shouldDisableCancelBarButton() {
        setupValidPasswordEntries()
        XCTAssertTrue(sut.cancelBarButton.isEnabled, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.cancelBarButton.isEnabled)
    }
    
    func test_tappingSubmit_withValidFields_shouldShowBlureView() {
        setupValidPasswordEntries()
        XCTAssertNil(sut.blurView.superview, "precondition")
        tap(sut.submitButton)
        XCTAssertNotNil(sut.blurView.superview)
    }
    
    func test_tappingSubmit_withValidFields_shouldShowActivityIndicator() {
        setupValidPasswordEntries()
        XCTAssertNil(sut.activityIndicator.superview, "precondition")
        tap(sut.submitButton)
        XCTAssertNotNil(sut.blurView.superview)
    }
    
    func test_tappingSubmit_withValidFields_shouldStartActivityAnimation() {
        setupValidPasswordEntries()
        XCTAssertFalse(sut.activityIndicator.isAnimating)
        tap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }
    
    func test_tappingSubmit_withVAlidFields_shouldClearBackgroundColorForBlur() {
        setupValidPasswordEntries()
        XCTAssertNotEqual(sut.view.backgroundColor, .clear, "precondition")
        tap(sut.submitButton)
        XCTAssertEqual(sut.view.backgroundColor, .clear)
    }
    
    func test_tappingSubmit_withValidFields_shouldRequestChangePassword() {
        sut.securityToken = "TOKEN"
        sut.oldPasswordTextField.text = "OLD456"
        sut.newPasswordTextField.text = "NEW456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
        tap(sut.submitButton)
        passwordChanger.verifyChange(securityToken: "TOKEN", oldPassword: "OLD456", newPassword: "NEW456")
    }
    
    func test_changePasswordSuccess_shouldStopActivityIndicatorAnimation() {
        setupValidPasswordEntries()
        tap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating, "precondition")
        passwordChanger.changeCallSuccess()
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func test_changePasswordSuccess_shouldHideActivityIndicator() {
        setupValidPasswordEntries()
        tap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview, "precondition")
        passwordChanger.changeCallSuccess()
        XCTAssertNil(sut.activityIndicator.superview)
    }
    
    func test_changePasswordFailure_shouldHideActivityIndicator() {
        setupValidPasswordEntries()
        tap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview, "precondition")
        passwordChanger.changeCallFailure(message: "DUMMY")
        XCTAssertNil(sut.activityIndicator.superview)
    }
    
    func test_changePasswordSuccess_shouldShowSuccessAlert() {
        setupValidPasswordEntries()
        tap(sut.submitButton)
        passwordChanger.changeCallSuccess()
        verifyAlertPresented(message: "Your password has been successfully changed.")
    }
    
    func test_tappingOKInSuccessAlert_shouldDismissModal() throws {
        setupValidPasswordEntries()
        tap(sut.submitButton)
        passwordChanger.changeCallSuccess()
        let dismissVerifier: DismissalVerifier = .init()
        
        try alertVerifier.executeAction(forButton: "OK")
        dismissVerifier.verify(animated: true, dismissedViewController: sut)
    }
    
    func test_changePasswordFailure_shouldShowFailureAlertWithGivenMessage() {
        setupValidPasswordEntries()
        tap(sut.submitButton)
        passwordChanger.changeCallFailure(message: "MESSAGE")
        verifyAlertPresented(message: "MESSAGE")
    }
    
    private func showPasswordChangeFailureAlert() {
        setupValidPasswordEntries()
        tap(sut.submitButton)
        passwordChanger.changeCallFailure(message: "DUMMY")
    }
    
    func test_tappingOKInFailureAlert_shouldClearAllFieldsToStartOver() throws {
        showPasswordChangeFailureAlert()
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, true, "old")
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirmation")
    }
    
    func test_tappingOKInFailureAlert_shouldPutFocusOnOldPassword() throws {
        showPasswordChangeFailureAlert()
        putInViewHeirarychy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingOKInFailureAlert_shouldSetBackgroundBackToWhite() throws {
        showPasswordChangeFailureAlert()
        XCTAssertNotEqual(sut.view.backgroundColor, .white, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.view.backgroundColor, .white)
    }
    
    func test_tappingOKInFailureAlert_shouldHideBlur() throws {
        showPasswordChangeFailureAlert()
        XCTAssertNotNil(sut.blurView.superview, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertNil(sut.blurView.superview)
    }
    
    func test_tappingOKInFailureAlert_shouldEnableCancelBarButton() throws {
        showPasswordChangeFailureAlert()
        XCTAssertFalse(sut.cancelBarButton.isEnabled, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.cancelBarButton.isEnabled)
    }
    
    func test_tappingOKInFailureAlert_shouldNotDismissModal() throws {
        showPasswordChangeFailureAlert()
        let dismissalVerifier: DismissalVerifier = .init()
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(dismissalVerifier.dismissedCount, .zero)
    }
    
    // MARK: delegate
    
    func test_textFieldDelegates_shouldBeConnected() {
        XCTAssertNotNil(sut.oldPasswordTextField.delegate, "oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField.delegate, "newPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField.delegate, "confirmPasswordTextField")
    }
    
    func test_hittingReturnFromOldPassword_shouldPutFocusOnNewPassword() {
        putInViewHeirarychy(sut)
        shouldReturn(in: sut.oldPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_hittingReturnFromNewPassword_shouldPutFocusOnConfirmPassword() {
        putInViewHeirarychy(sut)
        shouldReturn(in: sut.newPasswordTextField)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    func test_hittingReturnFromConfirmPassword_shouldRequestPasswordChange() {
        sut.securityToken = "TOKEN"
        sut.oldPasswordTextField.text = "OLD456"
        sut.newPasswordTextField.text = "NEW456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
        shouldReturn(in: sut.confirmPasswordTextField)
        passwordChanger.verifyChange(securityToken: "TOKEN", oldPassword: "OLD456", newPassword: "NEW456")
    }
    
    func test_hittingReturnFromOldPassword_shouldNotRequestPasswordChange() {
        setupValidPasswordEntries()
        shouldReturn(in: sut.oldPasswordTextField)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_hittingReturnFromNewPassword_shouldNotRequestPasswordChange() {
        setupValidPasswordEntries()
        shouldReturn(in: sut.newPasswordTextField)
        passwordChanger.verifyChangeNeverCalled()
    }
}

extension ChangePasswordViewControllerTests {
    private func setupValidPasswordEntries() {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
    
    private func setupEntriesNewPasswordTooShort() {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "12345"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
    
    private func setupMismatchedConfirmationEntry() {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = "abcdef"
    }
}
