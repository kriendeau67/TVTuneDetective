import SwiftUI
import MusicKit

struct GameView: View {
    let criteria: MusicCriteria
    let players: [Player]
    @ObservedObject var engine: GameEngine
    @StateObject private var music = MusicManager()
    @State private var currentSong: MusicKit.Song? = nil
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(colors: [.black, .blue.opacity(0.4)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                
                // MARK: - Top Stats Row
                HStack {
                    VStack(alignment: .leading) {
                        Text("Round \(engine.roundNumber) of \(engine.maxRounds)")
                            .font(.headline)
                            .foregroundColor(.yellow)
                        Text("Music Stage")
                            .font(.system(size: 60, weight: .black))
                    }
                    Spacer()
                    
                    // Displaying the specific search criteria in a nice pill
                    Text(criteria.keywords?.first ?? "\(criteria.genre ?? "Any") \(criteria.decade ?? "")")
                        .font(.headline)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Capsule().fill(Color.white.opacity(0.1)))
                }
                .padding(.horizontal, 80)
                .padding(.top, 40)

                Spacer()

                // MARK: - Center Content
                VStack(spacing: 40) {
                    if let song = currentSong {
                        // Song Reveal Card
                        VStack(spacing: 20) {
                            Text("NOW PLAYING")
                                .font(.caption)
                                .tracking(4)
                                .foregroundColor(.gray)
                            
                            Text(song.title)
                                .font(.system(size: 80, weight: .bold))
                                .multilineTextAlignment(.center)
                            
                            Text(song.artistName)
                                .font(.title)
                                .foregroundColor(.yellow)
                        }
                        .padding(60)
                        .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.05)))
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        // Placeholder before a song is picked
                        Image(systemName: "music.note.list")
                            .font(.system(size: 150))
                            .foregroundColor(.white.opacity(0.2))
                    }
                }
                .frame(maxHeight: .infinity)

                // MARK: - Action Buttons
                HStack(spacing: 40) {
                    // Play Random Song Button
                    Button {
                        fetchAndPlay()
                    } label: {
                        HStack {
                            Image(systemName: "dice.fill")
                            Text("Play Random Song")
                        }
                        .frame(width: 450, height: 120)
                    }
                    .buttonStyle(.card)
                    .tint(.green)

                    // Back Button
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back to Lobby")
                        }
                        .frame(width: 350, height: 120)
                    }
                    .buttonStyle(.card)
                    .tint(.red.opacity(0.8))
                }
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            engine.currentCriteria = criteria
            engine.currentGenre = criteria
        }
    }

    // MARK: - Logic
    private func fetchAndPlay() {
        Task {
            do {
                if let song = try await music.fetchSong(for: criteria) {
                    currentSong = song
                    engine.currentSong = song
                    // Note: Previews on simulator likely won't play audio,
                    // but the metadata will update!
                    try await music.playPreviewSnippet(song, seconds: 10)
                }
            } catch {
                print("❌ Error: \(error.localizedDescription)")
            }
        }
    }
}
