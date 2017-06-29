@testable import DGDependencyInjector

open class Cat: NSObject, IAnimal {

    public var name: String

    init(name: String) {
        self.name = name
    }

    public func scream() -> String {
        return "Meow"
    }
}
