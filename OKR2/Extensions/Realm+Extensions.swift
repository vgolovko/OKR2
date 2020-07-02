//
//  Realm+Extensions.swift
//  Core
//
//  Created by Dima Shvets on 3/25/19.
//  Copyright © 2019 Windmill. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> Void) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension Realm {
    func objects<T: Object>(ofType type: T.Type, where predicate: NSPredicate?, sorted sortDescriptors: [SortDescriptor]) -> Results<T> {
        var result = objects(T.self)
        if let predicate = predicate {
            result = result.filter(predicate)
        }
        if sortDescriptors.isNotEmpty {
            result = result.sorted(by: sortDescriptors)
        }
        return result
    }
}
