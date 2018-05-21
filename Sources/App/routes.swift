import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let userController = UserController()
    router.get("users", use: userController.index)
    router.post("signup", use: userController.signup)
    router.delete("user", use: userController.delete)
    router.get("login", use: userController.login)
}
