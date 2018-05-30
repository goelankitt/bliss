//
//  Quote.swift
//  App
//
//  Created by Ankit Goel on 5/30/18.
//

import FluentPostgreSQL
import Vapor
import Foundation

final class Quote: Content {

    var id: UUID?
    var text: String

    init(text: String) {
        self.text = text
    }
}

extension Quote: PostgreSQLUUIDModel {}
extension Quote: Migration {}
