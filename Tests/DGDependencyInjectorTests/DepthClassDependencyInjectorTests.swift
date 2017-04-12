import XCTest

@testable import DGDependencyInjector

class DepthClassDependencyInjectorTests: XCTestCase {

    private var injector: DependencyInjector?

    override func setUp() {
        super.setUp()
        let injector = DependencyInjector()
        let module = DependencyModule()
        module.register(type: PetOwner.self) { (injector, arguments) -> PetOwner? in
            if let name = arguments?["name"] as? String {
                if let petArguments = arguments?["pet"] as? [String: Any] {
                    return PetOwner(name: name, pet: injector.inject(type: IAnimal.self, arguments: petArguments))
                }
                return PetOwner(name: name)
            }
            return nil
        }
        module.register(type: IAnimal.self) { (_, arguments) -> IAnimal? in
            if let name = arguments?["name"] as? String {
                return Dog(name: name)
            }
            return nil
        }
        injector.register(module: module)
        self.injector = injector
    }

    func testPetOwnerInjection() {
        let po = self.injector?.inject(type: PetOwner.self, arguments: [
            "name": "Bala"
        ])
        XCTAssertNotNil(po)
        XCTAssert(po!.name == "Bala", "Error during the PetOwner injection")
        XCTAssertNil(po!.pet)
    }

    func testPetOwnerInjectionWithAnimal() {
        let po = self.injector?.inject(type: PetOwner.self, arguments: [
            "name": "Benoit",
            "pet": [
                "name": "Athina"
            ]
        ])
        XCTAssertNotNil(po)
        XCTAssert(po!.name == "Benoit", "Error during the PetOwner injection")
        XCTAssertNotNil(po!.pet)
        XCTAssert(type(of: po!.pet!) == Dog.self, "Error during the Animal injection")
        XCTAssert(po!.pet!.name == "Athina", "Error during the Animal injection")
    }
}