//
//  Token.swift
//  App
//
//  Created by Ankit Goel on 5/21/18.
//

import Foundation
import FluentPostgreSQL
import Vapor
import Authentication

final class Token: PostgreSQLModel {
    var id: Int?
    var token: String
    var userId: User.ID

    init(token: String, userId: User.ID) {
        self.token = token
        self.userId = userId
    }

    static func createToken(forUser user: User) throws -> Token {
        let tokenString = Helpers.randomToken(withLength: 60)
        let newToken = try Token(token: tokenString, userId: user.requireID())
        return newToken
    }
}

extension Token {
    var user: Parent<Token, User> {
        return parent(\.userId)
    }
}

extension Token: BearerAuthenticatable {
    static var tokenKey: WritableKeyPath<Token, String> { return \Token.token }
}

extension Token: Authentication.Token {
    static var userIDKey: WritableKeyPath<Token, User.ID> { return \Token.userId } // 1
    typealias UserType = User // 2
    typealias UserIDType = User.ID //3
}

extension Token: Content { }
extension Token: Migration { }
