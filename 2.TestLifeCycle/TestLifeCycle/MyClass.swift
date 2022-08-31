import Foundation

class MyClass {
    private static var allInstances: Int = 0
    private let instance: Int

    init() {
        Self.allInstances += 1
        instance = Self.allInstances
        print(">> MyClass.init() #\(instance)")
    }

    deinit {
        print(">> MyClass.deinit #\(instance)")
    }

    func methodOne() {
        print(">> methodOne #\(instance)")
    }

    func methodTwo() {
        print(">> methodTwo #\(instance)")
    }
}
