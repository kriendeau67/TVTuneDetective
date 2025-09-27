//
//  MatchScorer.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
//import SwiftUI
import Foundation

protocol TitleMatching {
  func isCorrect(guess: String, for song: Song) -> Bool
}
