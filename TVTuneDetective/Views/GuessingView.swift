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
    
    private func evaluateGuess(for player: Player, actual song: MusicKit.Song) {
       
        let actualArtist = song.artistName.lowercased()
        let actualTitle = song.title.lowercased()
        
        let guessedArtist = guessArtist.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let guessedTitle = guessTitle.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        var points = 0
        
        if actualArtist.contains(guessedArtist), !guessedArtist.isEmpty {
            points += 5
        }
        if actualTitle.contains(guessedTitle), !guessedTitle.isEmpty {
            points += 5
        }
        
        print("✅ Actual: \(song.title) by \(song.artistName)")
        print("📝 Guess: \(guessTitle) by \(guessArtist)")
        print("🏆 Points awarded: \(points)")
        
        engine.lastResult = GameEngine.RoundResult(player: player, song: song, points: points)
        engine.finishRound(correct: points > 0)
        
        // ✅ Update player score safely
        if let index = engine.players.firstIndex(where: { $0.id == player.id }) {
            engine.players[index].score += points
        }
        
        // ✅ Mark the round finished
        engine.finishRound(correct: points > 0)
    }
}
