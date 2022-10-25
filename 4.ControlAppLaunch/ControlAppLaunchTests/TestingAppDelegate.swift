import UIKit

// reference: https://github.com/hacknicity/TestingSceneDelegate
// @objc annotation能夠在runtime的時候透過class name取得class
@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(">> Launching with testing app delegate")

        // Remove any cached scene configurations to ensure that TestingAppDelegate.application(_:configurationForConnecting:options:) is called
        // TestingSceneDelegate will be used when running unit tests.
        // NOTE: THIS IS PRIVATE API AND MAY BREAK IN THE FUTURE!
        // 模擬器測試結果:
        // iOS 13和14會進迴圈清除cache
        // 但iOS 15的openSessions為0, 不會進去執行
        for sceneSession in application.openSessions {
            application.perform(Selector(("_removeSessionFromSessionSet:")), with: sceneSession)
        }

        return true
    }

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = TestingSceneDelegate.self
        sceneConfiguration.storyboard = nil
        return sceneConfiguration
    }
}
