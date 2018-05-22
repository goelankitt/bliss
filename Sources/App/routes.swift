import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let userController = UserController()
    router.get("users", use: userController.index)
    router.post("signup", use: userController.signup)
    router.delete("user", use: userController.delete)
    router.get("login", use: userController.login)

    let tokenAuthenticationMiddleware = User.tokenAuthMiddleware()
    let authedRoutes = router.grouped(tokenAuthenticationMiddleware)
    authedRoutes.get("this/protected/route") { request -> Future<User.PublicUser> in
        let user = try request.requireAuthenticated(User.self)
        return try user.authTokens.query(on: request).first().map(to: User.PublicUser.self) { userTokenType in
            guard let tokenType = userTokenType?.token else { throw Abort.init(HTTPResponseStatus.notFound) }
            return User.PublicUser(username: user.username, token: tokenType)
        }
    }
}
