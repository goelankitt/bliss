//
//  User.swift
//  App
//
//  Created by Ankit Goel on 5/8/18.
//

import FluentPostgreSQL
import Vapor

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
}

extension User: PostgreSQLUUIDModel {}
extension User: Migration {}
