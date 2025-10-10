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
// 👉 ADD: user-friendly display for a criteria
extension MusicCriteria {
    var displayName: String {
        // Prefer explicit Apple editorial playlist names if present
        if let kw = keywords?.first, !kw.isEmpty { return kw }
        var parts: [String] = []
        if let decade, !decade.isEmpty { parts.append(decade) }
        if let genre,  !genre.isEmpty  { parts.append(genre) }
        return parts.isEmpty ? "Any" : parts.joined(separator: " ")
    }
}
