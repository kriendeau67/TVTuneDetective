// MusicCriteria.swift
import Foundation

struct MusicCriteria: Codable, Equatable, Hashable {
    var genre: String?
    var decade: String?
    var limit: Int
    var keywords: [String]?
    var allowedArtistKeywords: [String]?   // 👈 NEW

    init(genre: String? = nil,
         decade: String? = nil,
         limit: Int = 20,
         keywords: [String]? = nil,
         allowedArtistKeywords: [String]? = nil) {
        self.genre = genre
        self.decade = decade
        self.limit = limit
        self.keywords = keywords
        self.allowedArtistKeywords = allowedArtistKeywords
    }
}
