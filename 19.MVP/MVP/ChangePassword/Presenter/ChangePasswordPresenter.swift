import Foundation

final class ChangePasswordPresenter {
    private unowned var view: ChangePasswordViewCommands
    
    private var labels: ChangePasswordLabels
    
    private let securityToken: String
    
    private let passwordChanger: PasswordChanging
    
    init(view: ChangePasswordViewCommands, viewModel: ChangePasswordLabels, securityToken: String, passwordChanger: PasswordChanging) {
        self.view = view
        self.labels = viewModel
        self.securityToken = securityToken
        self.passwordChanger = passwordChanger
    }
    
    private func handleSuccess() {
        view.hideActivityIndicator()
        view.showAlert(message: labels.successMessage) { [weak self] in
            self?.view.dismissModal()
        }
    }
    
    private func startOver() {
        view.clearAllPasswordFields()
        view.updateInputFocus(.oldPassword)
        view.setCancelButtonEnabled(true)
        view.hideBlurView()
    }
    
    private func handleFailure(message: String) {
        view.hideActivityIndicator()
        view.showAlert(message: message) { [weak self] in
            self?.startOver()
        }
    }
    
    private func attemptToChangePassword(passwordInputs: PasswordInputs) {
        passwordChanger.change(securityToken: securityToken, oldPassword: passwordInputs.oldPassword, newPassword: passwordInputs.newPassword) { [weak self] in
            self?.handleSuccess()
        } onFailure: { [weak self] message in
            self?.handleFailure(message: message)
        }
    }
    
    private func setupWaitingAppearance() {
        view.updateInputFocus(.noKeyboard)
        view.setCancelButtonEnabled(false)
        view.showBlurView()
        view.showActivityIndicator()
    }
    
    private func resetNewPasswords() {
        view.clearNewPasswordFields()
        view.updateInputFocus(.newPassword)
    }
    
    private func validateInputs(passwordInputs: PasswordInputs) -> Bool {
        if passwordInputs.isOldPasswordEmpty {
            view.updateInputFocus(.oldPassword)
            return false
        }
        if passwordInputs.isNewPasswordEmpty {
            view.showAlert(message: labels.enterNewPasswordMessage) { [weak self] in
                self?.view.updateInputFocus(.newPassword)
            }
            return false
        }
        
        if passwordInputs.isNewPasswordTooShort {
            view.showAlert(message: labels.newPasswordTooShortMessage) { [weak self] in
                self?.resetNewPasswords()
            }
            return false
        }
        
        if passwordInputs.isConfirmPasswordMismatched {
            view.showAlert(message: labels.confirmationPasswordDoesNotMatchMessage) { [weak self] in
                self?.resetNewPasswords()
            }
            return false
        }
        return true
    }
    
    func changePassword(_ passwordInputs: PasswordInputs) {
        guard validateInputs(passwordInputs: passwordInputs) else {
            return
        }
        setupWaitingAppearance()
        attemptToChangePassword(passwordInputs: passwordInputs)
    }
    
    func cancel() {
        // endEditing -> 任何 subview first responder 會強制 resign
        view.updateInputFocus(.noKeyboard)
        view.dismissModal()
    }
}
