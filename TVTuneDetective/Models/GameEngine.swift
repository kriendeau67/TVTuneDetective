//
//  GameEngine.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/27/25.
//

import Foundation
import MusicKit

enum GamePhase {
    case lobby
   // case game
    case genreSelect
    case bidding
    case countdown
    case guessing
    case result
    case scoreboard
}

@MainActor
final class GameEngine: ObservableObject {
    @Published var phase: GamePhase = .lobby
    @Published var currentGenre: MusicCriteria? = nil
    @Published var currentSong: MusicKit.Song? = nil
    @Published var currentBid: Int? = nil
    @Published var currentBidder: Player? = nil
    @Published var roundNumber: Int = 1
    @Published var currentCriteria: MusicCriteria? = nil
    @Published var players: [Player] = []
    @Published var lastResult: RoundResult? = nil
    let maxRounds = 5
    
    struct RoundResult {
        let player: Player
        let song: MusicKit.Song
        let points: Int
    }
    // Reset everything at start
    func startGame(with players: [Player]) {
        self.players = players
        self.phase = .genreSelect
        self.roundNumber = 1
        self.currentGenre = nil
        self.currentSong = nil
        self.currentBid = nil
        self.currentBidder = nil
    }
    
    // After genre is selected
    func genreChosen(_ criteria: MusicCriteria) {
        self.currentCriteria = criteria          // used by New Song, etc.
        self.currentGenre = criteria             // legacy readers keep working
        self.phase = .bidding
       // self.phase = .game
    }
    
    // After bidding ends
    func winningBid(player: Player, seconds: Int, song: MusicKit.Song) {
        self.currentBidder = player
        self.currentBid = seconds
        self.currentSong = song
        self.phase = .countdown
    }
    
    // After snippet plays
    func moveToGuessing() {
        self.phase = .guessing
    }
    
    // After guess is judged
    func finishRound(correct: Bool) {
        phase = .result   // 👈 just move to results, don’t increment here
    }
    
    // Move to next round
    func nextRound() {
        if roundNumber >= maxRounds {
            phase = .scoreboard   // ⬅️ stop at scoreboard when done
        } else {
            roundNumber += 1      // ⬅️ only increment here
            currentSong = nil
            currentBid = nil
            currentBidder = nil
            phase = .genreSelect
        }
    }
    
    private func updateScore(for player: Player, points: Int) {
        if let idx = players.firstIndex(where: { $0.id == player.id }) {
            players[idx].score += points
        }
    }
    func startNextRound() {
        currentSong = nil
        currentBidder = nil
        currentBid = nil
        lastResult = nil
        phase = .bidding   // 👈 or back to genreSelect if you want them to pick again
    }
}
