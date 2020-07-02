//
//  Networking.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 30.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

public final class Networking {
    
    public enum Requests {
        static let popular = "http://api.themoviedb.org/3/movie/popular?api_key=5fe919729fecda49e2ad0f5e8becd2d2"
    }
    
    public static let shared = Networking()
    private init() {}
    
    func resreshMovies() -> Observable<MoviesList> {
        guard let url = URL(string: Requests.popular) else { fatalError("Path uncorrect: \(Requests.popular)") }
        return request(.get, url).responseData().flatMap { (_, data) -> Observable<MoviesList> in
            guard let list = try? MoviesList.init(data: data) else {
                    return .empty()
            }
            return Observable.just(list)
        }
    }
}
