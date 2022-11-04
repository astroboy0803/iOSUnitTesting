import UIKit

class ViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "changePassword", let changePasswordVC = segue.destination as? ChangePasswordViewController else {
            return
        }
        changePasswordVC.securityToken = "TOKEN"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
