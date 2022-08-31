import UIKit

class CodeBasedViewController: UIViewController {
    private let data: String

    init(data: String) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        print(">> loadview")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(">> create views here")
    }
}
