//
//  Round.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
//import SwiftUI
import Foundation

struct Round: Codable, Equatable {
  let index: Int
  let song: Song
  var bids: [Bid]
  var winningBid: Bid?
  var guess: Guess?
  var isCorrect: Bool?
}
