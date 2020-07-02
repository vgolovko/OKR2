//
//  Convertible.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 30.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import Foundation

protocol EntityConvertible {
    associatedtype EntityType
    func asEntity() -> EntityType
}

protocol ModelConvertible {
    associatedtype ModelType: EntityConvertible

    var identifier: String { get }
    func asModel(with existingModel: ModelType?) -> ModelType
}
