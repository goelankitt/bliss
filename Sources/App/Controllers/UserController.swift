import Vapor
import Authentication

final class UserController {

    func signup(_ request: Request) throws -> Future<User.PublicUser> {
        return try request.content.decode(User.self).flatMap(to: User.PublicUser.self) { user in
            let passwordHashed = try request.make(BCryptDigest.self).hash(user.password)
            let newUser = User(username: user.username, email: user.email, password: passwordHashed)
            return newUser.save(on: request).flatMap(to: User.PublicUser.self) { createdUser in
                let accessToken = try Token.createToken(forUser: createdUser)
                return accessToken.save(on: request).map(to: User.PublicUser.self) { createdToken in
                    let publicUser = User.PublicUser(username: createdUser.username, token: createdToken.token)
                    return publicUser
                }
            }
        }
    }

    /// Returns a list of all Users.
    func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    /// Deletes a parameterized User.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
        }.transform(to: .ok)
    }

    func login(_ request: Request) throws -> Future<User> {
        return try request.content.decode(User.self).flatMap(to: User.self) { user in
            let passwordVerifier = try request.make(BCryptDigest.self)
            return User.authenticate(username: user.username, password: user.password, using: passwordVerifier, on: request).unwrap(or: Abort.init(HTTPResponseStatus.unauthorized))
        }
    }
}
