// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let trendingTvModel = try? JSONDecoder().decode(TrendingTvModel.self, from: jsonData)

import Foundation

// MARK: - TrendingTvModel
struct TrendingTvModel: Codable {
    let page: Int
    let results: [Tv]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Tv: Codable {
    let backdropPath: String
    let id: Int
    let originalName, overview, posterPath: String
    let mediaType: MediaTypeTv
    let adult: Bool
    let name, originalLanguage: String
    let genreIDS: [Int]
    let popularity: Double
    let firstAirDate: String
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult, name
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
    }
}

enum MediaTypeTv: String, Codable {
    case tv = "tv"
}
