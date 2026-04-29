import Foundation
import SwiftUI

// No changes needed to the structures themselves
struct GenreCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let subcategories: [GenreSubcategory]
}

struct GenreSubcategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let criteria: MusicCriteria
}

// FIXED: Using the exact "Essentials" naming strings Apple Music requires
let genreCategories: [GenreCategory] = [
    GenreCategory(
        name: "50s",
        subcategories: [
            GenreSubcategory(name: "All Hits", criteria: MusicCriteria(keywords: ["’50s Hits Essentials"]))
        ]
    ),
    GenreCategory(
        name: "60s",
        subcategories: [
            GenreSubcategory(name: "All Hits", criteria: MusicCriteria(keywords: ["’60s Hits Essentials"]))
        ]
    ),
    GenreCategory(
        name: "70s",
        subcategories: [
            GenreSubcategory(name: "All Hits", criteria: MusicCriteria(keywords: ["’70s Hits Essentials"]))
        ]
    ),
    GenreCategory(
        name: "80s",
        subcategories: [
            GenreSubcategory(name: "Rock", criteria: MusicCriteria(keywords: ["’80s Rock Essentials"])),
            GenreSubcategory(name: "Pop", criteria: MusicCriteria(keywords: ["’80s Pop Essentials"]))
        ]
    ),
    GenreCategory(
        name: "90s",
        subcategories: [
            GenreSubcategory(name: "All Hits", criteria: MusicCriteria(keywords: ["’90s Hits Essentials"]))
        ]
    ),
    GenreCategory(
        name: "2000s",
        subcategories: [
            GenreSubcategory(name: "All Hits", criteria: MusicCriteria(keywords: ["2000s Hits Essentials"]))
        ]
    ),
    // --- NEW STUFF FOR THE YOUNGER CROWD ---
    GenreCategory(
            name: "Modern Pop",
            subcategories: [
                // These strings are the exact names of the "living" Apple playlists
                GenreSubcategory(name: "Today’s Hits", criteria: MusicCriteria(keywords: ["Today’s Hits"])),
                GenreSubcategory(name: "A-List Pop", criteria: MusicCriteria(keywords: ["A-List Pop"])),
                GenreSubcategory(name: "New Music Daily", criteria: MusicCriteria(keywords: ["New Music Daily"]))
            ]
        ),
        GenreCategory(
            name: "Modern Country",
            subcategories: [
                // This will ensure the younger crowd gets actual 2026 Country hits
                GenreSubcategory(name: "Country Charts", criteria: MusicCriteria(keywords: ["Today’s Country"]))
            ]
        ),
        GenreCategory(
            name: "Family Fun",
            subcategories: [
                GenreSubcategory(name: "Disney Hits", criteria: MusicCriteria(keywords: ["Disney Essentials Music"])),
                GenreSubcategory(name: "Movie Hits", criteria: MusicCriteria(keywords: ["Greatest Movie Hits Essentials"]))
            ]
        ),
    // --- YOUR CUSTOM CATEGORIES ---
    GenreCategory(
        name: "Rock Classics",
        subcategories: [
            GenreSubcategory(name: "Classic Rock", criteria: MusicCriteria(keywords: ["Classic Rock Essentials"])),
            GenreSubcategory(name: "Hair Metal", criteria: MusicCriteria(keywords: ["Hair Metal Essentials"]))
        ]
    ),
    GenreCategory(
        name: "Sue and Ken",
        subcategories: [
            GenreSubcategory(name: "Jericho Trip", criteria: MusicCriteria(playlistID: "pl.u-4JomaB9uZm1XWz"))
        ]
    )

]
