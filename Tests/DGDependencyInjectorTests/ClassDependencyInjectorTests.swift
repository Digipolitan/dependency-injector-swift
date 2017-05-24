import XCTest

@testable import DGDependencyInjector

class ClassDependencyInjectorTests: XCTestCase {

    override func setUp() {
        super.setUp()

        let injector = Injector.default
        let module = Module()
        module.bind(PetOwner.self).with { (injector, _) -> PetOwner? in
            let owner = PetOwner(name: "Hello")
            owner.pet = try injector.inject(IAnimal.self)
            return owner
        }
        module.bind(IAnimal.self).to(type: Dog.self).singleton()
        injector.register(module: module)

        let otherInjector = Injector.instance(scope: "custom")
        let other = Module()
        other.bind(IAnimal.self).to(object: Cat(name: "Billy"))
        otherInjector.register(module: other)
    }

    func testDogInjection() {
        let dog = try? Injector.default.inject(IAnimal.self, arguments: [
            IAnimalKeys.name: "Athina"
            ])
        XCTAssertNotNil(dog)
        XCTAssert(type(of: dog!) == Dog.self, "Error during the Animal injection")
    }

    func testCatInjection() {
        let cat = try? Injector.instance(scope: "custom").inject(IAnimal.self)
        XCTAssertNotNil(cat)
        XCTAssert(cat!.name == "Billy", "Error during the Animal injection")
    }

    func testSingletonInjection() {
        let animal = try? Injector.default.inject(IAnimal.self)
        let animal2 = try? Injector.default.inject(IAnimal.self)
        XCTAssertNotNil(animal)
        XCTAssertTrue(animal! === animal2!)
    }
}
