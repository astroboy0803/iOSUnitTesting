import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private(set) var button: UIButton!
    
    var session: URLSessionProtocol = URLSession.shared
    
    private var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func buttonTapped() {
        // 註解, 重複發送, 網址 = 測試failure
        searchForBook(terms: "out from boneville")
    }
    
    private func searchForBook(terms: String) {
        guard
            let encodedTerms = terms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://itunes.apple.com/search?media=ebook&term=\(encodedTerms)")
        else {
            return
        }
        let request: URLRequest = .init(url: url)
        dataTask = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            let decoded = String(decoding: data ?? .init(), as: UTF8.self)
            print("response: \(String(describing: response))")
            print("data: \(decoded)")
            print("error: \(String(describing: error))")
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.dataTask = nil
                self.button.isEnabled = true
            }
        })
        button.isEnabled = false
        dataTask?.resume()
    }
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    
}
