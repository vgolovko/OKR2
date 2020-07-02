//
//  Database.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 30.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import Foundation
import RxRealm
import Realm
import RealmSwift
import RxSwift

final class Database: AbstractDatabase {
    private let configuration: Realm.Configuration
    private let scheduler: ImmediateSchedulerType
    // swiftlint:disable all
    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }
    // swiftlint:enable all
    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
        let name = "com.Application.Core.Database"
        self.scheduler = RunLoopThreadScheduler(threadName: name)
        print("Realm Path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    // MARK: - RX queries
    func queryAll<T: ModelConvertible>() -> Observable<[T]> where T == T.ModelType.EntityType, T.ModelType: Object {
        return Observable.deferred {
            let realm = self.realm
            let objects = realm.objects(T.ModelType.self)
            return Observable.array(from: objects).map { $0.map { model -> T in return model.asEntity()}}
        }.subscribeOn(scheduler)
    }
    func query<T: ModelConvertible, I: Identifiable>(with primaryKey: I.ID) -> Observable<T?> where T == T.ModelType.EntityType, T.ModelType: Object {
        return Observable.of(self.query(with: primaryKey))
    }
    func query<T: ModelConvertible>(where predicate: @escaping (T.ModelType) throws -> Bool) -> Observable<T?> where T == T.ModelType.EntityType, T.ModelType: Object {
            return Observable.of(try? realm.objects(T.ModelType.self).first(where: predicate)?.asEntity())
    }
    func save<T: ModelConvertible>(entity: T) -> Observable<Void> where T == T.ModelType.EntityType, T.ModelType: Object {
        return Observable.deferred {
            return self.save(entity: entity)
        }.subscribeOn(scheduler)
    }
    func save<T: ModelConvertible>(entities: [T]) -> Observable<Void> where T == T.ModelType.EntityType, T.ModelType: Object {
        return Observable.deferred {
            return self.save(entities: entities)
        }.subscribeOn(scheduler)
    }
    func delete<T: ModelConvertible>(entity: T) -> Observable<Void> where T == T.ModelType.EntityType, T.ModelType: Object {
        return Observable.deferred {
            return self.delete(entity: entity)
        }.subscribeOn(scheduler)
    }
    func delete<T: ModelConvertible>(_ entity: T) where T == T.ModelType.EntityType, T.ModelType: Object {
        let realm = self.realm
        try? realm.write {
            realm.delete(entity.asModel(with: nil))
        }
    }
    // MARK: - Non RX functions
    func truncateDatabase() {
        let realm = self.realm
        try? realm.write {
            realm.deleteAll()
        }
    }
    func queryAll<T: ModelConvertible>() -> [T] where T == T.ModelType.EntityType, T.ModelType: Object {
        let result = realm.objects(T.ModelType.self).toArray().map { model -> T in return model.asEntity() }
        return result
    }
    func query<T: ModelConvertible, O: Identifiable>(with primaryKey: O.ID) -> T? where T == T.ModelType.EntityType, T.ModelType: Object {
        return realm.object(ofType: T.ModelType.self, forPrimaryKey: primaryKey.rawValue)?.asEntity()
    }
    func query<T: ModelConvertible>(where predicate: (T.ModelType) throws -> Bool) rethrows -> T? where T == T.ModelType.EntityType, T.ModelType: Object {
        return try? realm.objects(T.ModelType.self).first(where: predicate)?.asEntity()
    }
    func save<T: ModelConvertible>(_ entity: T) where T == T.ModelType.EntityType, T.ModelType: Object {
        let realm = self.realm
        try? realm.write {
            realm.add(entity.asModel(with: nil), update: .modified)
        }
    }
    func save<T: ModelConvertible>(_ entities: [T]) where T == T.ModelType.EntityType, T.ModelType: Object {
        let realm = self.realm
        try? realm.write {
            entities.forEach { (entity) in
                realm.add(entity.asModel(with: nil), update: .modified)
            }
        }
    }
    
    func changeSet<T: ModelConvertible>() -> Observable<(RealmChangeset?, [T])> where T == T.ModelType.EntityType, T.ModelType: Object {
        return Observable.changeset(from: realm.objects(T.ModelType.self)).map { (collection, changes) -> (RealmChangeset?, [T]) in
            return (changes, collection.toArray().map { $0.asEntity() })
        }
    }
    
    func changeSet<T: ModelConvertible>(predicate: (T.ModelType) -> Bool) -> Observable<(RealmChangeset?, [T])> where T == T.ModelType.EntityType, T.ModelType: Object {
        let obs = Observable.collection(from: realm.objects(T.ModelType.self)).filter { (result) -> Bool in
            return result.
        }
        let models = realm.objects(T.ModelType.self).filter(predicate)
        return Observable.changeset(from: models)
    }
    
//    func obserWithProperty() -> Observable<[RMMovie]> {
//        let realm = self.realm
//        Observable.from(object: realm.objects(RMMovie.self), emitInitialValue: false , properties: ["isFavorites"])
//    }
}
