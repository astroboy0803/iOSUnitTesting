import UIKit

class ViewController: UIViewController {
    @IBOutlet private(set) var usernameField: UITextField!
    @IBOutlet private(set) var passwordField: UITextField!
    
    deinit {
        print("ViewController.deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField !== usernameField || !string.contains(" ")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === usernameField {
            passwordField.becomeFirstResponder()
        } else if let username = usernameField.text, let password = passwordField.text {
            passwordField.resignFirstResponder()
            performLogin(username: username, password: password)
        }
        return false
    }
    
    private func performLogin(username: String, password: String) {
        print("Username: \(username)")
        print("Password: \(password)")
    }
}
