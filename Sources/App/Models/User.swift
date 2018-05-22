//
//  User.swift
//  App
//
//  Created by Ankit Goel on 5/8/18.
//

import FluentPostgreSQL
import Vapor
import Authentication
import Foundation

final class User: Content {

    var id: UUID?
    var username: String
    var email: String
    var password: String

    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }

    struct PublicUser: Content {
        var username: String
        var token: String
    }
}

extension User: PostgreSQLUUIDModel {}
extension User: Migration {}
extension User: Parameter {}
extension User: PasswordAuthenticatable {}
extension User: SessionAuthenticatable {}
extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \User.username
    static let passwordKey: PasswordKey = \User.password
}
extension User: TokenAuthenticatable { typealias TokenType = Token }
