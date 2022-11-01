import Foundation
import UIKit

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}

func putInWindow(_ vc: UIViewController) {
    let window: UIWindow = .init()
    window.rootViewController = vc
    window.isHidden = false
}

func putInViewHeirarychy(_ vc: UIViewController) {
    let window: UIWindow = .init()
    window.addSubview(vc.view)
}

extension UITextContentType: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension UITextAutocorrectionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:
            return "default"
        case .no:
            return "no"
        case .yes:
            return "yes"
        }
    }
}

extension UIReturnKeyType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:
          return "default"
        case .go:
          return "go"
        case .google:
          return "google"
        case .join:
          return "join"
        case .next:
          return "next"
        case .route:
          return "route"
        case .search:
          return "search"
        case .send:
          return "send"
        case .yahoo:
          return "yahoo"
        case .done:
          return "done"
        case .emergencyCall:
          return "emergencyCall"
        case .continue:
          return "continue"
        }
    }
}

func shouldChangeCharacters(in textField: UITextField, range: NSRange = .init(), replacement: String) -> Bool? {
    textField.delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: replacement)
}

@discardableResult
func shouldReturn(in textField: UITextField) -> Bool? {
    textField.delegate?.textFieldShouldReturn?(textField)
}
