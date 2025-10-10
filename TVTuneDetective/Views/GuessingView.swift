//
//  GuessingView.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/27/25.
//

import SwiftUI
import MusicKit

struct GuessingView: View {
    @ObservedObject var engine: GameEngine
    
    @State private var guessArtist: String = ""
    @State private var guessTitle: String = ""
    
    var body: some View {
        VStack(spacing: 30) {
            if let player = engine.currentBidder,
               let song = engine.currentSong {
                
                Text("🎤 \(player.name), enter your guess!")
                    .font(.largeTitle).bold()
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .padding()
                
                VStack(spacing: 20) {
                    // Artist input
                    TextField("Artist", text: $guessArtist)
                        .padding(.horizontal, 16)
                        .frame(width: 500, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                    
                    // Song title input
                    TextField("Song Title", text: $guessTitle)
                        .padding(.horizontal, 16)
                        .frame(width: 500, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.15))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.35), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
                
                Button {
                    evaluateGuess(for: player, actual: song)
                } label: {
                    Text("Submit Guess")
                        .font(.title2).bold()
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
            } else {
                Text("⚠️ No active guesser")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
    private func normalize(_ text: String) -> String {
        return text
            .lowercased()
            .replacingOccurrences(of: "&", with: "and")
            .replacingOccurrences(of: "the ", with: "")
            .replacingOccurrences(of: "[^a-z0-9 ]", with: "", options: .regularExpression) // strip punctuation
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func evaluateGuess(for player: Player, actual song: MusicKit.Song) {
        let actualArtist = normalize(song.artistName)
        let actualTitle = normalize(song.title)
        
        let guessedArtist = normalize(guessArtist)
        let guessedTitle = normalize(guessTitle)
        
        var points = 0
        var breakdown: [String] = []

        // 👈 Artist scoring
            if !guessedArtist.isEmpty {
                if actualArtist.contains(guessedArtist) || guessedArtist.contains(actualArtist) {
                    points += 10
                    breakdown.append("+10 (Artist correct)")
                } else {
                    points -= 5
                    breakdown.append("-5 (Artist wrong)")
                }
            } else {
                breakdown.append("No artist guess")
            }
        
        // 👈 Title scoring
            if !guessedTitle.isEmpty {
                if actualTitle.contains(guessedTitle) || guessedTitle.contains(actualTitle) {
                    points += 10
                    breakdown.append("+10 (Title correct)")
                } else {
                    points -= 5
                    breakdown.append("-5 (Title wrong)")
                }
            } else {
                breakdown.append("No title guess")
            }
        
        print("✅ Actual: \(song.title) by \(song.artistName)")
        print("📝 Guess: \(guessTitle) by \(guessArtist)")
        print("🏆 Points change: \(points) [\(breakdown.joined(separator: ", "))]")

        // Save result
        engine.lastResult = GameEngine.RoundResult(player: player, song: song, points: points, breakdown: breakdown)
        
        // Update player score safely
        if let index = engine.players.firstIndex(where: { $0.id == player.id }) {
            engine.players[index].score += points
        }
        
        // Advance to result phase
        engine.finishRound(correct: points > 0)
    }
}
