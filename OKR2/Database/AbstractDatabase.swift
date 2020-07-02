//
//  AbstractDatabase.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 30.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol AbstractDatabase {
    func queryAll<T: ModelConvertible>() -> [T] where T == T.ModelType.EntityType, T.ModelType: Object
    func query<T: ModelConvertible, O: Identifiable>(with primaryKey: O.ID) -> T? where T == T.ModelType.EntityType, T.ModelType: Object
    func query<T: ModelConvertible>(where predicate: (T.ModelType) throws -> Bool) rethrows -> T? where T == T.ModelType.EntityType, T.ModelType: Object
    func delete<T: ModelConvertible>(_ entity: T) where T == T.ModelType.EntityType, T.ModelType: Object
    func save<T: ModelConvertible>(_ entity: T) where T == T.ModelType.EntityType, T.ModelType: Object
    func save<T: ModelConvertible>(_ entities: [T]) where T == T.ModelType.EntityType, T.ModelType: Object

    func queryAll<T: ModelConvertible>() -> Observable<[T]> where T == T.ModelType.EntityType, T.ModelType: Object
    func query<T: ModelConvertible, I: Identifiable>(with primaryKey: I.ID) -> Observable<T?> where T == T.ModelType.EntityType, T.ModelType: Object
    func query<T: ModelConvertible>(where predicate: @escaping (T.ModelType) throws -> Bool) -> Observable<T?> where T == T.ModelType.EntityType, T.ModelType: Object
    func save<T: ModelConvertible>(entity: T) -> Observable<Void> where T == T.ModelType.EntityType, T.ModelType: Object
    func save<T: ModelConvertible>(entities: [T]) -> Observable<Void> where T == T.ModelType.EntityType, T.ModelType: Object
    func delete<T: ModelConvertible>(entity: T) -> Observable<Void> where T == T.ModelType.EntityType, T.ModelType: Object

    func truncateDatabase()
}
