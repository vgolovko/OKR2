//
//  MoviesListViewModel.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 04.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MoviesListViewModel {
    private let network = Networking.shared
    private let database = Database()
    
    public let movies = BehaviorRelay<[Movie]>(value: [])
    private let disposeBag = DisposeBag()
    
    init() {
        setup()
    }
    
    func setup() {
        let query: Observable<[Movie]> = database.queryAll()
        query.bind(to: movies)
        .disposed(by: disposeBag)
    }
    
    func refreshMoviesList() {
        network.resreshMovies()
            .debug()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { (list) -> [Movie] in
                return list.results
            }
        .subscribe(onNext: { [weak self] movies in
            guard let self = self else { return }
            self.database.save(movies)
        })
        .disposed(by: disposeBag)
    }
}
