//
//  Bid.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
//import SwiftUI
import Foundation

struct Bid: Codable, Equatable {
  let playerID: Player.ID
  let seconds: Int
  let timestamp: Date
}
