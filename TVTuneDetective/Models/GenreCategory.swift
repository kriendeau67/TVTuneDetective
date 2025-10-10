//
//  GenreCategory.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/27/25.
//
import Foundation
import SwiftUI

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
let genreCategories: [GenreCategory] = [
    GenreCategory(
        name: "70s",
        subcategories: [
            GenreSubcategory(
                name: "Rock",
                criteria: MusicCriteria(keywords: ["’70s Rock Essentials"])
            ),
            GenreSubcategory(
                name: "Pop Hits",
                criteria: MusicCriteria(keywords: ["’70s Pop Essentials"])
            )
        ]
    ),
    GenreCategory(
        name: "80s",
        subcategories: [
            GenreSubcategory(
                name: "Rock",
                criteria: MusicCriteria(keywords: ["’80s Rock Essentials"])
            ),
            GenreSubcategory(
                name: "Pop Hits",
                criteria: MusicCriteria(keywords: ["’80s Pop Essentials"])
            )
        ]
    ),
    GenreCategory(
        name: "60s",
        subcategories: [
            GenreSubcategory(
                name: "Rock",
                criteria: MusicCriteria(keywords: ["'60s Rock Essentials"])
            ),
            GenreSubcategory(
                name: "Pop Hits",
                criteria: MusicCriteria(keywords: ["’60s Pop Essentials"])
            )
        ]
    ),
    GenreCategory(
        name: "50s",
        subcategories: [
            GenreSubcategory(
                name: "Rock",
                criteria: MusicCriteria(keywords: ["’50s Rock Essentials"])
            ),
            GenreSubcategory(
                name: "Pop Hits",
                criteria: MusicCriteria(keywords: ["’50s Pop Essentials"])
            )
        ]
    ),
    GenreCategory(
        name: "Hair Metal Essentials",
        subcategories: [
            GenreSubcategory(
                name: "Rock",
                criteria: MusicCriteria(keywords: ["’Hair Metal Essentials"])
            ),
        ]
    ),
    GenreCategory(
        name: "Disco",
        subcategories: [
            GenreSubcategory(
                name: "Disco",
                criteria: MusicCriteria(keywords: ["’Disco Essentials"])
            ),
        ]
    ),
    GenreCategory(
        name: "Yacht Rock",
        subcategories: [
            GenreSubcategory(
                name: "Yacht Rock",
                criteria: MusicCriteria(keywords: ["’Yacht Rock Essentials"])
            ),
        ]
    ),
    GenreCategory(
        name: "Today's `Pop",
        subcategories: [
            GenreSubcategory(
                name: "POP",
                criteria: MusicCriteria(keywords: ["Pop Essentials"])
            ),
        ]
    ),
    GenreCategory(
        name: "2000s",
        subcategories: [
            GenreSubcategory(
                name: "Rock",
                criteria: MusicCriteria(keywords: ["2000s Rock Essentials"])
            ),
            GenreSubcategory(
                name: "Pop Hits",
                criteria: MusicCriteria(keywords: ["2000s Pop Essentials"])
            )
        ]
    ),
    GenreCategory(
        name: "Country",
        subcategories: [
            GenreSubcategory(
                name: "Today’s Country",
                criteria: MusicCriteria(keywords: ["Today’s Country"])
            ),
            GenreSubcategory(
                name: "Classics",
                criteria: MusicCriteria(keywords: ["’80s Country Essentials"])
            )
        ]
    ),
    GenreCategory(
        name: "Hip Hop",
        subcategories: [
            GenreSubcategory(
                name: "Old School",
                criteria: MusicCriteria(keywords: ["Golden Age Hip-Hop Essentials"])
            ),
            GenreSubcategory(
                name: "Modern",
                criteria: MusicCriteria(keywords: ["Hip-Hop Hits"])
            )
        ]
    ),
    GenreCategory(
        name: "Classic Rock",
        subcategories: [
            GenreSubcategory(
                name: "Greatest Hits",
                criteria: MusicCriteria(keywords: ["Classic Rock Essentials"])
            )
        ]
    ),
    GenreCategory(
        name: "Today’s Hits",
        subcategories: [
            GenreSubcategory(
                name: "Global Top 40",
                criteria: MusicCriteria(keywords: ["Today’s Hits"])
            )
        ]
    ),
    GenreCategory(
        name: "Top 100",
        subcategories: [
            GenreSubcategory(
                name: "Billboard Hot 100",
                criteria: MusicCriteria(keywords: ["Billboard Hot 100"])
            )
        ]
    )
]
