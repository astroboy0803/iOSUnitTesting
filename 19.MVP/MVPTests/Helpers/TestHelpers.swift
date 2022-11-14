import UIKit
import XCTest

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

func numberOfRows(in tableView: UITableView, section: Int = .zero) -> Int? {
    tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section)
}

func cellForRow(in tableView: UITableView, row: Int, section: Int = .zero) -> UITableViewCell? {
    tableView.dataSource?.tableView(tableView, cellForRowAt: .init(row: row, section: section))
}

func didSelectRow(in tableView: UITableView, row: Int, section: Int = .zero) {
    tableView.delegate?.tableView?(tableView, didSelectRowAt: .init(row: row, section: section))
}

func verifyMethodCalledOnce(methodName: String, callCount: Int, describeArguments: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Bool {
    guard callCount > .zero else {
        XCTFail("Wanted but not invoked: \(methodName)", file: file, line: line)
        return false
    }
    guard callCount == 1 else {
        XCTFail("Wanted 1 time but was called \(callCount) times. \(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }
    return true
}

func verifyMethodNeverCalled(methodName: String, callCount: Int, describeArguments: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    let times = callCount == 1 ? "time" : "times"
    if callCount > .zero {
        XCTFail("Never wanted but was called \(callCount) \(times). \(methodName) with \(describeArguments())", file: file, line: line)
    }
}

extension UIBarButtonItem.SystemItem: CustomStringConvertible {
    public var description: String {
        switch self {
        case .done:
            return "done"
        case .cancel:
            return "cancel"
        case .edit:
            return "edit"
        case .save:
            return "save"
        case .add:
            return "add"
        case .flexibleSpace:
            return "flexibleSpace"
        case .fixedSpace:
            return "fixedSpace"
        case .compose:
            return "compose"
        case .reply:
            return "reply"
        case .action:
            return "action"
        case .organize:
            return "organize"
        case .bookmarks:
            return "bookmarks"
        case .search:
            return "search"
        case .refresh:
            return "refresh"
        case .stop:
            return "stop"
        case .camera:
            return "camera"
        case .trash:
            return "trash"
        case .play:
            return "play"
        case .pause:
            return "pause"
        case .rewind:
            return "rewind"
        case .fastForward:
            return "fastForward"
        case .undo:
            return "undo"
        case .redo:
            return "redo"
        case .pageCurl:
            return "pageCurl"
        case .close:
            return "close"
        }
    }
}
