//
//  FavoritesViewModel.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 04.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRealm

final class FavoritesViewModel {
    private let network = Networking.shared
    private let database = Database()
    
    public let movies = BehaviorRelay<[Movie]>(value: [])
    public let changeset = BehaviorRelay<(RealmChangeset?, [Movie])>(value: (nil, []))
    private let disposeBag = DisposeBag()
    
    init() {
        setup()
    }
    
    func setup() {
        let query: Observable<[Movie]> = database.queryAll()
        query.flatMapLatest{ movies -> Observable<[Movie]> in
            return .just(movies.filter { $0.isFavorites })
        }
        .debug()
            .bind(to: movies)
            .disposed(by: disposeBag)
        
        let changes: Observable<(RealmChangeset?, [Movie])> = database.changeSet()
        changes.bind(to: changeset)
        .disposed(by: disposeBag)
    }
}
