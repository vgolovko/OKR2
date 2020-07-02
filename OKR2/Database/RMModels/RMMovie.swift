//
//  RMMovie.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 30.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers
public class RMMovie: Object {
    dynamic var id: Int = 0
    dynamic var popularity: Double = 0
    dynamic var voteCount: Int = 0
    dynamic var video: Bool = false
    dynamic var posterPath: String = ""
    dynamic var adult: Bool = false
    dynamic var backdropPath: String = ""
    dynamic var originalLanguage: OriginalLanguage = .en
    dynamic var originalTitle: String = ""
    dynamic var title: String = ""
    dynamic var voteAverage: Double = 0
    dynamic var overview: String = ""
    dynamic var releaseDate: String = ""
    dynamic var isFavorite: Bool = false
    
    override public class func primaryKey() -> String? { return #keyPath(id) }
}

extension RMMovie: EntityConvertible {
    func asEntity() -> Movie {
        return Movie(popularity: popularity,
                     voteCount: voteCount,
                     video: video,
                     posterPath: posterPath,
                     id: id,
                     adult: adult,
                     backdropPath: backdropPath,
                     originalLanguage: originalLanguage,
                     originalTitle: originalTitle,
                     title: title,
                     voteAverage: voteAverage,
                     overview: overview,
                     releaseDate: releaseDate,
                     isFavorites: isFavorite)
    }
}

extension Movie: ModelConvertible {
    
    var identifier: String { return String(id) }
    func asModel(with existingModel: RMMovie?) -> RMMovie {
        return .build { object in
            object.id = id
            object.popularity = popularity
            object.voteCount = voteCount
            object.video = video
            object.posterPath = posterPath
            object.adult = adult
            object.backdropPath = backdropPath
            object.originalLanguage = originalLanguage
            object.originalTitle = originalTitle
            object.title = title
            object.voteAverage = voteAverage
            object.overview = overview
            object.releaseDate = releaseDate
            object.isFavorite = isFavorites
        }
    }
}
