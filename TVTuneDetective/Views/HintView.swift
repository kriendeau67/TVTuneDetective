import SwiftUI
import AVFoundation
import MusicKit

struct HintView: View {
    @ObservedObject var engine: GameEngine
    @State private var hintCount = 0
    @State private var player: AVPlayer? = nil
    @State private var isLoadingSong = false

    var body: some View {
            ZStack {
                // MARK: - Background Removed
                // We deleted the LinearGradient here so the global background shows through.
                Color.clear.ignoresSafeArea()

                VStack(spacing: 50) {
                    // Header & Category Info
                    VStack(spacing: 15) {
                        Text("💡 Hint Phase")
                            .font(.system(size: 70, weight: .black))
                            .foregroundColor(.white)
                        
                        if let genre = (engine.currentCriteria ?? engine.currentGenre) {
                            Text("Category: \(genre.displayName)")
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 60) // Matches your PlayerPanel top padding

                    Spacer()

                    // MARK: - Center Status Area
                    VStack(spacing: 30) {
                        if isLoadingSong {
                            VStack(spacing: 20) {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .scaleEffect(2.0)
                                Text("Fetching a random tune...")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        } else if engine.currentSong != nil {
                            VStack(spacing: 10) {
                                Image(systemName: "music.note.badge.plus")
                                    .font(.system(size: 80))
                                    .foregroundColor(.green)
                                Text("Song Loaded & Ready")
                                    .font(.headline)
                            }
                        } else {
                            Text("Preparing the deck...")
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    .frame(height: 300)

                    Spacer()

                    // MARK: - Bottom Controls
                    HStack(spacing: 120) { // 👈 Increased spacing to 120 to fix overlap
                        // Play Hint Button
                        Button {
                            playHint()
                        } label: {
                            VStack {
                                Text("Play 1s Hint")
                                    .font(.title2).bold()
                                Text("\(3 - hintCount) remaining")
                                    .font(.caption)
                            }
                            .frame(width: 350, height: 140)
                        }
                        .buttonStyle(.card)
                        .tint(.green)
                        .disabled(hintCount >= 3 || engine.currentSong == nil || isLoadingSong)

                        // Continue Button
                        Button {
                            engine.phase = .bidding
                        } label: {
                            Text("Start Bidding ➡️")
                                .font(.title2).bold()
                                .frame(width: 350, height: 140)
                        }
                        .buttonStyle(.card)
                        .tint(.orange)
                        .disabled(engine.currentSong == nil || isLoadingSong)
                    }
                    .padding(.bottom, 80)
                }
            }
            .task {
                await ensureSongLoaded()
            }
        }

    // MARK: - Logic Functions

    private func ensureSongLoaded() async {
        guard engine.currentSong == nil,
              let criteria = engine.currentCriteria ?? engine.currentGenre else { return }

        isLoadingSong = true
        do {
            if let song = try await MusicManager().fetchSong(for: criteria) {
                await MainActor.run {
                    engine.currentSong = song
                    print("✅ Loaded song for hint: \(song.title)")
                }
            }
        } catch {
            print("❌ Failed to fetch song: \(error)")
        }
        isLoadingSong = false
    }

    private func playHint() {
        guard hintCount < 3, let song = engine.currentSong else { return }
        
        // Safety check for the Simulator while you're away
        guard let previewURL = song.previewAssets?.first?.url else {
            print("⚠️ No preview URL (Typical for Simulator)")
            hintCount += 1 // Increment anyway so you can test the UI state
            return
        }

        hintCount += 1
        player = AVPlayer(url: previewURL)
        player?.play()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.player?.pause()
            self.player = nil
        }
    }
}
