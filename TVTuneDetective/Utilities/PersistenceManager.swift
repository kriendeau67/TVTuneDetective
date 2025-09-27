//
//  PersistenceManager.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
import SwiftUI

protocol Persisting {
  func saveSettings(_ s: GameSettings)
  func loadSettings() -> GameSettings
  // later: saveHighScores([...])
}
