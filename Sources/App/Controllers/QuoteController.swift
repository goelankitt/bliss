//
//  QuoteController.swift
//  App
//
//  Created by Ankit Goel on 5/30/18.
//

import Foundation
import Vapor

final class QuoteController {

    func create(_ request: Request) throws -> Future<Quote> {
        return try request.content.decode(Quote.self).flatMap(to: Quote.self) { quote in
            return quote.save(on: request)
        }
    }

    func fetch(_ request: Request) throws -> Future<[Quote]> {
        return Quote.query(on: request).all()
    }
}
