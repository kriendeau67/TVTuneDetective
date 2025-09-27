//
//  GameState.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
//import SwiftUI
import Foundation

enum Phase: Equatable {
  case lobby
  case bidding(currentLeader: Bid?)
  case playback(remaining: Int)
  case guessing(activePlayer: Player.ID, remaining: Int)
  case scoring(correct: Bool)
  case finished
}

struct GameSettings: Codable, Equatable {
  var minBidSeconds: Int  // e.g., 1
  var maxBidSeconds: Int  // e.g., 10
  var snippetMaxSeconds: Int // cap for playback
  var categories: [String] // optional future
}
