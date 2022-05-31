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
