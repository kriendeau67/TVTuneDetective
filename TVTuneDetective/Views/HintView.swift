import SwiftUI
import AVFoundation
import MusicKit

struct HintView: View {
    @ObservedObject var engine: GameEngine
    @State private var hintCount = 0
    @State private var player: AVPlayer? = nil
    @State private var isLoadingSong = false

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 30) {
                Spacer().frame(height: 60)

                // Header
                Text("💡 Hint Phase")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)

                // Show genre clue
                if let genre = (engine.currentCriteria ?? engine.currentGenre) {
                    Text("Clue: \(genre.displayName)")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }

                // Status
                if engine.currentSong != nil {
                    Text("Song ready to play 🎵")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                } else if isLoadingSong {
                    ProgressView("Loading song…")
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text("Preparing song…")
                        .foregroundColor(.white.opacity(0.7))
                }

                // ✅ Play Hint button
                Button {
                    playHint()
                } label: {
                    Text("▶️ Play Hint (\(3 - hintCount) left)")
                        .font(.title2).bold()
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(hintCount >= 3 ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(hintCount >= 3 || engine.currentSong == nil)

                // ✅ Continue to bidding
                Button {
                    engine.phase = .bidding
                } label: {
                    Text("➡️ Go to Bidding")
                        .font(.title2).bold()
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        // ✅ Preload one song immediately when view appears
        .task {
            await ensureSongLoaded()
        }
    }

    // MARK: - Helpers

    private func ensureSongLoaded() async {
        guard engine.currentSong == nil,
              let criteria = engine.currentCriteria ?? engine.currentGenre else { return }

        isLoadingSong = true
        do {
            if let song = try await MusicManager().fetchSong(for: criteria) {
                await MainActor.run {
                    engine.currentSong = song
                    print("✅ Loaded song for hint: \(song.title) by \(song.artistName)")
                }
            } else {
                print("⚠️ No song returned for criteria: \(criteria.displayName)")
            }
        } catch {
            print("❌ Failed to fetch song:", error)
        }
        isLoadingSong = false
    }

    private func playHint() {
        print("🎬 playHint() called — hintCount: \(hintCount)")

        guard hintCount < 3 else {
            print("⛔️ Hint limit reached")
            return
        }

        // ✅ Always use preloaded song from engine
        guard let song = engine.currentSong else {
            print("⚠️ No currentSong set in engine.")
            return
        }

        // ✅ Fix unwrap for previewAssets optional
        guard let previewURL = song.previewAssets?.first?.url else {
            print("⚠️ No preview URL available for song \(song.title)")
            return
        }

        hintCount += 1
        print("🎧 Playing 1-sec preview from: \(previewURL)")

        player = AVPlayer(url: previewURL)
        player?.play()

        // ✅ Stop after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.player?.pause()
            print("🛑 Stopped after 1 second")
        }
    }
}
