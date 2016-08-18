//
//  JSONParsing.swift
//  Devour
//
//  Created by johnrhickey on 8/17/16.
//  Copyright © 2016 Jay Hickey. All rights reserved.
//

import Foundation

// Generic JSON Parsing
// This keeps a separation of concerns with relation to JSON validation and parsing

// Adapted from http://www.jessesquires.com/swift-failable-initializers-revisited/

protocol JSONParserType {
    associatedtype T
    func parseJSON(json: JSON) -> T
}

struct JSON {
    let data: NSData
    init(data: NSData) {
        self.data = data
    }
}

struct JSONValidator<T> {
    typealias ValidationClosure = (JSON) -> Bool
    let validator: ValidationClosure
    init(validator: ValidationClosure) {
        self.validator = validator
    }
    func isValid(json: JSON) -> Bool {
        return validator(json)
    }
}


func parse<T, P: JSONParserType where P.T == T>(json: JSON, validator: JSONValidator<T>, parser: P) -> T? {
    if !validator.isValid(json) {
        return nil
    }
    return parser.parseJSON(json)
}