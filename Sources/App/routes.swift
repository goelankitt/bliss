import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let userController = UserController()
    router.get("users", use: userController.index)
    router.post("users", use: userController.create)
    router.delete("users", use: userController.delete)
}
