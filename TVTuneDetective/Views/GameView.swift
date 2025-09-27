import SwiftUI
import MusicKit

struct GameView: View {
    let criteria: MusicCriteria      // chosen genre/decade/playlist
    let players: [Player]            // keep the player panel consistent
    @ObservedObject var engine: GameEngine
    @StateObject private var music = MusicManager()
    @State private var currentSong: MusicKit.Song? = nil   // store the most recent song
    
    // For dismissing back to Lobby
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack(spacing: 40) {
            Spacer()

            // Right: main game area
            VStack(spacing: 30) {
                Text("Round \(engine.roundNumber) of \(engine.maxRounds)")
                                    .font(.title2).bold()
                                    .foregroundColor(.yellow)	
                Text("Game Stage")
                    .font(.largeTitle).bold()

                VStack(spacing: 8) {
                    if let keywords = criteria.keywords, !keywords.isEmpty {
                        Text("Playlist: \(keywords.joined(separator: ", "))")
                    } else {
                        Text("Genre: \(criteria.genre ?? "Any")")
                        Text("Decade: \(criteria.decade ?? "Any")")
                    }
                }
                .font(.title3)
                Button {
                    Task {
                        do {
                            if let song = try await music.fetchSong(for: criteria) {
                                currentSong = song
                                engine.currentSong = song
                                try await music.playPreviewSnippet(song, seconds: 10)
                            } else {
                                print("❌ No songs found for criteria: \(criteria)")
                            }
                        } catch {
                            print("❌ Failed to fetch/play:", error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Play Random Song in Genre")
                        .font(.title2).bold()
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }

                // 👇 Song metadata display
                if let song = currentSong {
                    VStack(spacing: 6) {
                        Text("Now Playing:")
                            .font(.headline)
                        Text("🎵 \(song.title)")
                            .font(.title3).bold()
                        Text("👤 \(song.artistName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Criteria Used: \(criteria.keywords?.first ?? "\(criteria.genre ?? "Any") \(criteria.decade ?? "")")")
                            .font(.footnote)
                            .foregroundColor(.yellow)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                }

                Spacer()
                
                Button {
                    dismiss()   // Pops back in the navigation stack
                } label: {
                    Text("⬅️ Back to Lobby")
                        .font(.title3).bold()
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
            }
            .frame(maxWidth: .infinity)
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
        .onAppear {
                    engine.currentCriteria = criteria
                    engine.currentGenre = criteria
                  }
    }
       
}
