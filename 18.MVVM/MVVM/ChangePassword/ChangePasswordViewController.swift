import UIKit

protocol PasswordChanging {
    func change(securityToken: String, oldPassword: String, newPassword: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void)
}

final class ChangePasswordViewController: UIViewController {
    
    var viewModel: ChangePasswordViewModel! {
        didSet {
            // 當 ViewController 的 View 被載入記憶體 = true
            // otherwise is false
            guard isViewLoaded else {
                return
            }
            
            if oldValue.isCancelButtonEnabled != viewModel.isCancelButtonEnabled {
                cancelBarButton.isEnabled = viewModel.isCancelButtonEnabled
            }
            
            if oldValue.inputFocus != viewModel.inputFocus {
                updateInputFocus()
            }
            
            if oldValue.isBlurViewShowing != viewModel.isBlurViewShowing {
                updateBlurView()
            }
            
            if oldValue.isActivityIndicatorShowing != viewModel.isActivityIndicatorShowing {
                updateActivityIndicator()
            }
        }
    }
    
    @IBOutlet private(set) var navigationBar: UINavigationBar!
    @IBOutlet private(set) var cancelBarButton: UIBarButtonItem!
    @IBOutlet private(set) var oldPasswordTextField: UITextField!
    @IBOutlet private(set) var newPasswordTextField: UITextField!
    @IBOutlet private(set) var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) var submitButton: UIButton!
    
    lazy var passwordChanger: PasswordChanging = PasswordChanger()
    var securityToken = ""
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let activityIndicator: UIActivityIndicatorView = .init(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor(red: 55/255.0, green: 147/255.0, blue: 251/255.0, alpha: 1).cgColor
        submitButton.layer.cornerRadius = 8
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        setLabels()
    }
    
    private func setLabels() {
        navigationBar.topItem?.title = viewModel.title
        oldPasswordTextField.placeholder = viewModel.oldPasswordPlaceholder
        newPasswordTextField.placeholder = viewModel.newPasswordPlaceholder
        confirmPasswordTextField.placeholder = viewModel.confirmPasswordPlaceholder
        submitButton.setTitle(viewModel.submitButtonLabel, for: .normal)
    }
    
    @IBAction private func cancel() {
        // endEditing -> 任何 subview first responder 會強制 resign
        viewModel.inputFocus = .noKeyboard
//        oldPasswordTextField.resignFirstResponder()
//        newPasswordTextField.resignFirstResponder()
//        confirmPasswordTextField.resignFirstResponder()
        dismiss(animated: true)
    }
    
    private func startOver() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        oldPasswordTextField.becomeFirstResponder()
        viewModel.isCancelButtonEnabled = true
        viewModel.isBlurViewShowing = false
    }
    
    private func attemptToChangePassword() {
        passwordChanger.change(securityToken: securityToken, oldPassword: viewModel.oldPassword, newPassword: viewModel.newPassword) { [weak self] in
            self?.handleSuccess()
        } onFailure: { [weak self] message in
            self?.handleFailure(message: message)
        }
    }
    
    private func handleSuccess() {
        viewModel.isActivityIndicatorShowing = false
        showAlert(message: viewModel.successMessage) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    
    private func handleFailure(message: String) {
        viewModel.isActivityIndicatorShowing = false
        showAlert(message: message) { [weak self] _ in
            self?.startOver()
        }
    }
    
    private func updateInputFocus() {
        switch viewModel.inputFocus {
        case .noKeyboard:
            view.endEditing(true)
        case .oldPassword:
            oldPasswordTextField.becomeFirstResponder()
        case .newPassword:
            newPasswordTextField.becomeFirstResponder()
        case .confirmPassword:
            confirmPasswordTextField.becomeFirstResponder()
        }
    }
    
    private func updateBlurView() {
        if viewModel.isBlurViewShowing {
            view.backgroundColor = .clear
            view.addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
                blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            ])
        } else {
            blurView.removeFromSuperview()
            view.backgroundColor = .white
        }
    }
    
    private func updateActivityIndicator() {
        if viewModel.isActivityIndicatorShowing {
            view.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    private func updateViewModelToTextFields() {
        viewModel.oldPassword = oldPasswordTextField.text ?? ""
        viewModel.newPassword = newPasswordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
    }
    
    private func setupWaitingAppearance() {
        viewModel.inputFocus = .noKeyboard
        viewModel.isCancelButtonEnabled = false
        viewModel.isBlurViewShowing = true
        viewModel.isActivityIndicatorShowing = true
    }
    
    private func showAlert(message: String, okAction: @escaping (UIAlertAction) -> Void) {
        let alertController: UIAlertController = .init(title: "", message: message, preferredStyle: .alert)
        let okButton: UIAlertAction = .init(title: viewModel.okButtonLabel, style: .default, handler: okAction)
        alertController.addAction(okButton)
        alertController.preferredAction = okButton
        present(alertController, animated: true)
    }
    
    private func resetNewPasswords() {
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        newPasswordTextField.becomeFirstResponder()
    }
    
    private func validateInputs() -> Bool {
        if viewModel.isOldPasswordEmpty {
            oldPasswordTextField.becomeFirstResponder()
            return false
        }
        if viewModel.isNewPasswordEmpty {
            showAlert(message: viewModel.enterNewPasswordMessage) { [weak self] _ in
                self?.newPasswordTextField.becomeFirstResponder()
            }
            return false
        }
        
        if viewModel.isNewPasswordTooShort {
            showAlert(message: viewModel.newPasswordTooShortMessage) { [weak self] _ in
                self?.resetNewPasswords()
            }
            return false
        }
        
        if viewModel.isConfirmPasswordMismatched {
            showAlert(message: viewModel.confirmationPasswordDoesNotMatchMessage) { [weak self] _ in
                self?.resetNewPasswords()
            }
            return false
        }
        return true
    }
    
    @IBAction private func changePassword() {
        updateViewModelToTextFields()
        
        guard validateInputs() else {
            return
        }
        
        setupWaitingAppearance()
        
        attemptToChangePassword()
    }
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField {
            viewModel.inputFocus = .newPassword
        } else if textField === newPasswordTextField {
            viewModel.inputFocus = .confirmPassword
        } else if textField === confirmPasswordTextField {
            changePassword()
        }
        return true
    }
}
