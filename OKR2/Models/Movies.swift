//
//  Movies.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 30.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import Foundation

// MARK: - Movies
struct Movie: Codable {
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let posterPath: String
    let id: Int
    let adult: Bool
    let backdropPath: String
    let originalLanguage: OriginalLanguage
    let originalTitle: String
    let title: String
    let voteAverage: Double
    let overview, releaseDate: String
    var isFavorites: Bool = false
    

    enum CodingKeys: String, CodingKey {
        case popularity
        case voteCount = "vote_count"
        case video
        case posterPath = "poster_path"
        case id, adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
    
    mutating func updateFavorite() {
        self.isFavorites = !self.isFavorites
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case ko = "ko"
    case sv = "sv"
}

// MARK: Movie convenience initializers and mutators

extension Movie {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Movie.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        popularity: Double? = nil,
        voteCount: Int? = nil,
        video: Bool? = nil,
        posterPath: String? = nil,
        id: Int? = nil,
        adult: Bool? = nil,
        backdropPath: String? = nil,
        originalLanguage: OriginalLanguage? = nil,
        originalTitle: String? = nil,
        title: String? = nil,
        voteAverage: Double? = nil,
        overview: String? = nil,
        releaseDate: String? = nil
    ) -> Movie {
        return Movie(
            popularity: popularity ?? self.popularity,
            voteCount: voteCount ?? self.voteCount,
            video: video ?? self.video,
            posterPath: posterPath ?? self.posterPath,
            id: id ?? self.id,
            adult: adult ?? self.adult,
            backdropPath: backdropPath ?? self.backdropPath,
            originalLanguage: originalLanguage ?? self.originalLanguage,
            originalTitle: originalTitle ?? self.originalTitle,
            title: title ?? self.title,
            voteAverage: voteAverage ?? self.voteAverage,
            overview: overview ?? self.overview,
            releaseDate: releaseDate ?? self.releaseDate
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


