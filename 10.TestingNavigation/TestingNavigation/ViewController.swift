import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private(set) var codePushButton: UIButton!
    @IBOutlet private(set) var codeModalButton: UIButton!
    @IBOutlet private(set) var seguePushButton: UIButton!
    @IBOutlet private(set) var segueModalButton: UIButton!
    
    deinit {
        print(">> ViewController.deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pushNext":
            guard let nextVC = segue.destination as? SegueNextViewController else {
                return
            }
            nextVC.labelText = "Pushed from segue"
        case "modalNext":
            guard let nextVC = segue.destination as? SegueNextViewController else {
                return
            }
            nextVC.labelText = "Modal from segue"
        default:
            return
        }
    }
    
    @IBAction private func pushNextViewController() {
        let codeNextVC = CodeNextViewController(labelText: "Pushed from code")
        self.navigationController?.pushViewController(codeNextVC, animated: true)
    }
    
    @IBAction private func presentModalNextViewController() {
        let codeNextVC = CodeNextViewController(labelText: "Modal from code")
        self.present(codeNextVC, animated: true)
    }
}

