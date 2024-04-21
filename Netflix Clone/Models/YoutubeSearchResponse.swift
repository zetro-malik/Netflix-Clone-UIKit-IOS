//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Nayatel Creatives on 21/04/2024.
//

import Foundation



struct VideoElement: Codable {
    let etag: String
    let id: IdVideoElement
    let kind: String
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}

struct PageInfo: Codable {
    let resultsPerPage: Int
    let totalResults: Int
}

struct YoutubeSearchResponse: Codable {
    let etag: String
    let items: [VideoElement]
    let kind: String
    let nextPageToken: String
    let pageInfo: PageInfo
    let regionCode: String
}
