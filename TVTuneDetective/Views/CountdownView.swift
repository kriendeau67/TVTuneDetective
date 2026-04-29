import SwiftUI
import MusicKit

struct CountdownView: View {
    @ObservedObject var engine: GameEngine
    @StateObject private var music = MusicManager()

    @State private var timeRemaining: Int = 0
    @State private var isPlaying = false
    @State private var isLoadingSong = false // 👈 Added this for the spinner
    @State private var timerRef: Timer? = nil
    @State private var playbackTask: Task<Void, Never>? = nil
    @State private var revealedSong: MusicKit.Song? = nil
    @State private var showRevealedSong = false
    @FocusState private var isGotItFocused: Bool
    
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            VStack(spacing: 40) {
                if let player = engine.currentBidder,
                   let song = engine.currentSong,
                   let bid = engine.currentBid {

                    Text("🎯 \(player.name)’s Bid: \(bid) Seconds")
                        .font(.system(size: 70, weight: .black))
                        .foregroundColor(.yellow)
                        .padding(.top, 60)

                    ZStack {
                        if showRevealedSong, let rSong = revealedSong {
                            VStack(spacing: 20) {
                                Text("🎵 THE SONG WAS")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text(rSong.title)
                                    .font(.system(size: 80, weight: .black))
                                    .foregroundColor(.yellow)
                                    .multilineTextAlignment(.center)
                                
                                Text(rSong.artistName)
                                    .font(.system(size: 50, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Button("Got It") {
                                    showRevealedSong = false
                                }
                                .buttonStyle(.card)
                                .focused($isGotItFocused)
                                .padding(.top, 40)
                            }
                            .padding(60)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(30)
                            .transition(.scale.combined(with: .opacity))
                        } else if isLoadingSong {
                            // 👈 Added a spinner so you know the "New Song" is fetching
                            VStack(spacing: 20) {
                                ProgressView()
                                    .scaleEffect(2.0)
                                Text("Fetching new tune...")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        } else {
                            VStack(spacing: 10) {
                                Text("\(timeRemaining == 0 ? bid : timeRemaining)")
                                    .font(.system(size: 250, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                    .shadow(color: .green.opacity(0.5), radius: 20)
                                
                                Text("SECONDS REMAINING")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    HStack(spacing: 60) {
                        Button {
                            playSnippet(song: song, seconds: bid)
                        } label: {
                            Label(isPlaying ? "\(timeRemaining)s..." : "Play Snippet", systemImage: "play.fill")
                                .padding(.horizontal, 30)
                                .frame(height: 120)
                        }
                        .buttonStyle(.card)
                        .tint(.green)
                        .disabled(isPlaying || showRevealedSong || isLoadingSong)

                        Button {
                            stopAll()
                            engine.moveToGuessing()
                        } label: {
                            Text("➡️ Submit Guess")
                                .padding(.horizontal, 30)
                                .frame(height: 120)
                        }
                        .buttonStyle(.card)
                        .tint(.orange)
                        .disabled(showRevealedSong || isLoadingSong)

                        Button {
                            revealAndReplaceSong()
                        } label: {
                            Text("🎲 New Song")
                                .padding(.horizontal, 30)
                                .frame(height: 120)
                        }
                        .buttonStyle(.card)
                        .tint(.purple)
                        .disabled(isPlaying || showRevealedSong || isLoadingSong)
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .onDisappear { stopAll() }
    }

    // MARK: - Logic Functions
    
    private func revealAndReplaceSong() {
        stopAll()
        revealedSong = engine.currentSong
        
        // 1. Wipe old song immediately
        engine.currentSong = nil
        
        withAnimation(.spring()) {
            showRevealedSong = true
        }
        
        isGotItFocused = true
        
        // 2. Trigger the fetch for the NEW song
        Task {
            await ensureSongLoaded()
        }
    }

    // 👈 THIS WAS THE MISSING PIECE
    private func ensureSongLoaded() async {
        guard engine.currentSong == nil,
              let criteria = engine.currentCriteria ?? engine.currentGenre else { return }

        isLoadingSong = true
        do {
            if let song = try await music.fetchSong(for: criteria) {
                await MainActor.run {
                    engine.currentSong = song
                    print("✅ New song loaded: \(song.title)")
                }
            }
        } catch {
            print("❌ Failed to fetch new song: \(error)")
        }
        isLoadingSong = false
    }

    private func playSnippet(song: MusicKit.Song, seconds: Int) {
        stopAll()
        timeRemaining = seconds
        isPlaying = true

        timerRef = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                isPlaying = false
            }
        }

        playbackTask = Task {
            do {
                try await music.playPreviewSnippet(song, seconds: Double(seconds))
            } catch {
                isPlaying = false
                timerRef?.invalidate()
            }
        }
    }

    private func stopAll() {
        timerRef?.invalidate()
        timerRef = nil
        playbackTask?.cancel()
        playbackTask = nil
        music.stopPreview()
        ApplicationMusicPlayer.shared.stop()
        isPlaying = false
    }
}
