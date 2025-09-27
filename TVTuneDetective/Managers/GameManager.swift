//
//  GameManager.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//
import SwiftUI

protocol GameManaging: AnyObject {
  // Phase control
  func startLobby()
  func startRound()
  func acceptBid(playerID: Player.ID)
  func startPlayback(for seconds: Int) // from winning bid
  func stopPlayback()
  func revealAnswer()
  func endRound()
  func resetGame()

  // From clients
  func playerJoined(connectionID: ConnectionID, name: String)
  func playerLeft(connectionID: ConnectionID)
  func receiveBid(from playerID: Player.ID, seconds: Int)
  func receiveGuess(from playerID: Player.ID, text: String)

  // Settings
  func updateSettings(_ new: GameSettings)
}
