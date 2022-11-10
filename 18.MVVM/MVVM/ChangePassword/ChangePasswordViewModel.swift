import Foundation

struct ChangePasswordViewModel {
    
    enum InputFocus {
        case noKeyboard
        case oldPassword
        case newPassword
        case confirmPassword
    }
    
    var inputFocus: InputFocus = .noKeyboard
    var isCancelButtonEnabled: Bool = true
    var isBlurViewShowing: Bool = false
    var isActivityIndicatorShowing = false
    
    var oldPassword: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    
    var isOldPasswordEmpty: Bool {
        oldPassword.isEmpty
    }
    
    var isNewPasswordEmpty: Bool {
        newPassword.isEmpty
    }
    
    var isNewPasswordTooShort: Bool {
        newPassword.count < 6
    }
    
    var isConfirmPasswordMismatched: Bool {
        confirmPassword != newPassword
    }
    
    let okButtonLabel: String
    let enterNewPasswordMessage: String
    let newPasswordTooShortMessage: String
    let confirmationPasswordDoesNotMatchMessage: String
    let successMessage: String
    let title: String = "Change Password"
    let oldPasswordPlaceholder: String = "Current Password"
    let newPasswordPlaceholder: String = "New Password"
    let confirmPasswordPlaceholder: String = "Confirm New Password"
    let submitButtonLabel: String = "Submit"
}
