//
//  Tag.swift
//  Core
//
//  Created by Dima Shvets on 2/21/19.
//  Copyright © 2019 Windmill. All rights reserved.
//

import Foundation

public struct Tag<Parent, Value: Codable & Hashable>: RawRepresentable, Codable, Hashable, CustomStringConvertible {
    public let rawValue: Value
    public init(rawValue: Value) {
        self.rawValue = rawValue
    }
    public init(_ value: Value) {
        self.init(rawValue: value)
    }
    public init(from decoder: Decoder) throws {
        self.rawValue = try Value(from: decoder)
    }
    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
    public var description: String {
        return "\(rawValue)"
    }
}

extension Tag: ExpressibleByIntegerLiteral where Value == Int {
    public typealias IntegerLiteralType = Value
    public init(integerLiteral value: Value) {
        self.init(rawValue: value)
    }
}

public protocol Identifiable {
    associatedtype Identifier: Codable & Hashable = String
    //     swiftlint:disable:next type_name
    typealias ID = Tag<Self, Identifier>
    var id: ID { get }
}
