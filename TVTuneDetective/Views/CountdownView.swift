import SwiftUI
import MusicKit

struct CountdownView: View {
    @ObservedObject var engine: GameEngine
    @StateObject private var music = MusicManager()

    @State private var timeRemaining: Int = 0
    @State private var isPlaying = false

    // Keep references so we can stop/restart cleanly
    @State private var timerRef: Timer? = nil
    @State private var playbackTask: Task<Void, Never>? = nil

    var body: some View {
        VStack(spacing: 30) {
            if let player = engine.currentBidder,
               let song = engine.currentSong,
               let bid = engine.currentBid {

                Text("🎯 \(player.name)’s Bid")
                    .font(.largeTitle).bold()
                    .foregroundColor(.yellow)

                // Bid time label + countdown
                VStack(spacing: 8) {
                    Text("Bid Time")
                        .font(.title2).foregroundColor(.white.opacity(0.85))
                    Text("\(timeRemaining == 0 ? bid : timeRemaining)")
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }

                Spacer().frame(height: 10)

                // Controls
                HStack(spacing: 24) {
                    Button {
                        playSnippet(song: song, seconds: bid)
                    } label: {
                        Text(isPlaying ? "⏳ \(timeRemaining)s left" : "▶️ Play Snippet")
                            .font(.title2).bold()
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .disabled(isPlaying) // prevent overlap; becomes enabled when timer ends

                    Button {
                        stopAll()
                        engine.moveToGuessing()
                    } label: {
                        Text("➡️ Submit Guess")
                            .font(.title2).bold()
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    
                    Button {
                        stopAll()
                        Task {
                            guard let criteria = engine.currentCriteria else {
                                print("⚠️ No criteria set in engine")
                                return
                            }
                            do {
                                if let newSong = try await music.fetchSong(for: criteria) {
                                    engine.currentSong = newSong
                                    print("🎲 New song → \(newSong.title) by \(newSong.artistName)")
                                    // (Optional) auto-play right away:
                                    // try await music.playSongSnippet(newSong, seconds: Double(engine.currentBid ?? 10))
                                } else {
                                    print("❌ No replacement song found for criteria: \(criteria)")
                                }
                            } catch {
                                print("❌ Failed to fetch replacement:", error.localizedDescription)
                            }
                        }
                    } label: {
                        Text("🎲 New Song")
                            .font(.title2).bold()
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .background(isPlaying ? Color.gray : Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .disabled(isPlaying)   // stays locked while the snippet is playing
                }

                Spacer()
            } else {
                Text("⚠️ Missing song or bid info")
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
        .onDisappear {
            // Safety: stop if we navigate away
            stopAll()
        }
    }

    private func playSnippet(song: MusicKit.Song, seconds: Int) {
        // Clean restart
        stopAll()

        timeRemaining = seconds
        isPlaying = true

        // Start countdown timer
        timerRef = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                isPlaying = false
            }
        }

        // Start audio snippet for exactly `seconds`
        playbackTask = Task {
            do {
               // try await music.playSongSnippet(song, seconds: Double(seconds))
                try await music.playPreviewSnippet(song, seconds: Double(seconds))
            } catch {
                print("❌ Failed to play snippet:", error.localizedDescription)
                isPlaying = false
                timerRef?.invalidate()
                timerRef = nil
            }
        }
    }

    private func stopAll() {
        // Stop timer
        timerRef?.invalidate()
        timerRef = nil

        // Stop any in-flight playback task
        playbackTask?.cancel()
        playbackTask = nil
        music.stopPreview()                        // 👈 NEW: stop AVPlayer
            ApplicationMusicPlayer.shared.stop()       // safe to keep; no-op if not used

        // Stop the player immediately
        ApplicationMusicPlayer.shared.stop()

        isPlaying = false
    }
}
