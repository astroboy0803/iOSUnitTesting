import UIKit

class ViewController: UIViewController {
    @IBOutlet private(set) var button: UIButton!
    
    var handleResults: ([SearchResult]) -> Void = { print($0) }
    
    private(set) var results: [SearchResult] = [] {
        didSet {
            handleResults(results)
        }
    }

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
            guard let self else {
                return
            }
            var decoded: Search?
            var errorMessage: String?
            if let error {
                errorMessage = error.localizedDescription
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                errorMessage = "Response: \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))"
            } else if let data {
                do {
                    decoded = try JSONDecoder().decode(Search.self, from: data)
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                if let decoded {
                    self.results = decoded.results
                }
                if let errorMessage {
                    self.showError(errorMessage)
                }
                self.dataTask = nil
                self.button.isEnabled = true
            }
        })
        button.isEnabled = false
        dataTask?.resume()
    }
    
    private func showError(_ message: String) {
        let title = "Network Problem"
        print("\(title): \(message)")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        present(alert, animated: true)
    }
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

struct SearchResult: Decodable, Equatable {
    let artistName: String
    let trackName: String
    let averageUserRating: Float
    let genres: [String]
}

struct Search: Decodable {
    let results: [SearchResult]
}
