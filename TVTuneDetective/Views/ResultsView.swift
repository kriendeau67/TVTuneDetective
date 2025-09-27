//
//  ResultsView.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/27/25.
//
import SwiftUI
import MusicKit

struct ResultsView: View {
    @ObservedObject var engine: GameEngine

    var body: some View {
        VStack(spacing: 30) {
            if let result = engine.lastResult {
                Text("🎶 Round Results")
                    .font(.largeTitle).bold()

                VStack(spacing: 12) {
                    Text("Song: \(result.song.title)")
                        .font(.title2).bold()
                    Text("Artist: \(result.song.artistName)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                Divider().padding()

                Text("👤 \(result.player.name)")
                    .font(.title2).bold()

                if result.points > 0 {
                    Text("✅ Correct! +\(result.points) pts")
                        .foregroundColor(.green)
                        .font(.title2).bold()
                } else {
                    Text("❌ Wrong! No points")
                        .foregroundColor(.red)
                        .font(.title2).bold()
                }

                Spacer()

                Button {
                    engine.nextRound()
                } label: {
                    Text("➡️ Next Round")
                        .font(.title2).bold()
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
            } else {
                Text("⚠️ No result available")
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
}
