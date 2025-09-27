//
//  Player.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//

import Foundation

/// Represents a player connected to the game.
struct Player: Identifiable, Codable, Equatable {
    typealias ID = UUID
    
    let id: ID
    var name: String
    var score: Int
    
    init(id: ID = UUID(), name: String, score: Int = 0) {
        self.id = id
        self.name = name
        self.score = score
    }
}
