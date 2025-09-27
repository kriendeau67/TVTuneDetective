//
//  Guess.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
//import SwiftUI
import Foundation

struct Guess: Codable, Equatable {
  let playerID: Player.ID
  let text: String
  let timestamp: Date
}
