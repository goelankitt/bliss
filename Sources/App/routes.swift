import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let userController = UserController()
    router.post("signup", use: userController.signup)
    router.get("login", use: userController.login)
    router.delete("logout", use: userController.logout)

    let quoteController = QuoteController()
    router.post("quote", use: quoteController.create)
    router.get("quote", use: quoteController.fetch)

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
