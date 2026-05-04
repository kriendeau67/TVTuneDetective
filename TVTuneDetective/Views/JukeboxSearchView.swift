//
//  JukeboxSearchView.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 5/4/26.
//



import SwiftUI
import MusicKit

struct JukeboxSearchView: View {
    @ObservedObject var engine: GameEngine
    @State private var searchText = ""
    @State private var results: [MusicKit.Song] = []
    @State private var isSearching = false
    @State private var musicIsPlaying = false
    
    var body: some View {
        ZStack {
            // Background to match your app vibe
            LinearGradient(colors: [.black, .purple.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header & Search Input
                HStack(spacing: 20) {
                    // 1. BACK BUTTON (Left)
                    Button {
                        engine.phase = .modeSelect
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 10)
                    
                    // 2. SEARCH BOX (Middle)
                    TextField("Search for any song, artist, or album...", text: $searchText)
                        .font(.title2)
                        .padding(30)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .onSubmit {
                            runSearch()
                        }
                    
                    // 3. STOP BUTTON (Right)
                    // This will always stay on the screen so you can kill the music anytime.
                    Button {
                        engine.musicManager.stopMusic()
                    } label: {
                        HStack {
                            Image(systemName: "stop.fill")
                            Text("STOP")
                        }
                        .font(.headline).bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .frame(height: 100) // Matches search box height
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(20)
                    }
                    .buttonStyle(.card) // This makes it highlight when you swipe to it
                }
               
                .padding(.horizontal, 80)
                .padding(.top, 40)
              //  .animation(.default, value: musicIsPlaying) // Makes it slide in smoothly

                if isSearching {
                    ProgressView("Searching Apple Music...")
                        .scaleEffect(2)
                        .padding()
                } else if results.isEmpty && !searchText.isEmpty {
                    Text("No songs found. Try a different search.")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                // Results Grid/List
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(results) { song in
                            Button {
                                #if targetEnvironment(simulator)
                                // Play the 30-second snippet so you can at least hear the track in the simulator
                                Task {
                                    try? await engine.musicManager.playPreviewSnippet(song, seconds: 30)
                                }
                                #else
                                // Play the full song on the real Apple TV
                                engine.musicManager.playFullSong(song)
                                #endif
                            } label: {
                                HStack(spacing: 30) {
                                    // Album Art
                                    if let artwork = song.artwork {
                                        ArtworkImage(artwork, width: 100, height: 100)
                                            .cornerRadius(10)
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 100, height: 100)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(song.title)
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.white)
                                        Text(song.artistName)
                                            .font(.title3)
                                            .foregroundColor(.yellow)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "play.fill")
                                        .font(.title)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.card) // Essential for tvOS focus/highlight
                        }
                    }
                    .padding(.horizontal, 80)
                    .padding(.bottom, 60)
                }
            }
        }
    }

    private func runSearch() {
        guard !searchText.isEmpty else { return }
        isSearching = true
        
        Task {
            do {
                // This calls the fixed searchCatalog function in your MusicManager
                let foundSongs = try await engine.musicManager.searchCatalog(for: searchText)
                await MainActor.run {
                    self.results = foundSongs
                    self.isSearching = false
                }
            } catch {
                print("Search failed: \(error)")
                await MainActor.run {
                    self.isSearching = false
                }
            }
        }
    }
}
