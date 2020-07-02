//
//  MoviesList.swift
//  OKR2
//
//  Created by Vitaliy Golovko on 30.06.2020.
//  Copyright © 2020 VGolovko. All rights reserved.
//

import Foundation

struct MoviesList: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: MoviesList convenience initializers and mutators

extension MoviesList {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MoviesList.self, from: data)
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
        page: Int? = nil,
        totalResults: Int? = nil,
        totalPages: Int? = nil,
        results: [Movie]? = nil
    ) -> MoviesList {
        return MoviesList(
            page: page ?? self.page,
            totalResults: totalResults ?? self.totalResults,
            totalPages: totalPages ?? self.totalPages,
            results: results ?? self.results
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
