import UIKit

class ViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "changePassword", let changePasswordVC = segue.destination as? ChangePasswordViewController else {
            return
        }
        changePasswordVC.securityToken = "TOKEN"
        changePasswordVC.labels = .init(okButtonLabel: "OK", enterNewPasswordMessage: "Please enter a new password.", newPasswordTooShortMessage: "The new password should at least 6 characters.", confirmationPasswordDoesNotMatchMessage: "Ther new password and the confirmation password don't match. Please try again.", successMessage: "Your password has been successfully changed.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
