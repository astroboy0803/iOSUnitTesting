import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private(set) var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func buttonTap() {
        print(">> Button was tapped")
    }
}

