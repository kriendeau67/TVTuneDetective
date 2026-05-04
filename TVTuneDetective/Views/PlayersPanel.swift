import SwiftUI

struct PlayersPanel: View {
    @ObservedObject var engine: GameEngine
    @StateObject private var music = MusicManager() // Needed for resetPlayedSongs
    @State private var startOverProgress: Double = 0
    @State private var isHoldingStartOver = false
        
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            // MARK: - Header
            HStack(alignment: .center) {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.yellow)
                
                Text("Players")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: true, vertical: false)
                
                Spacer()
                
                Text("\(engine.players.count)")
                    .font(.caption).bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(5)
            }
            .padding(.top, 60)
            // Inside the VStack of PlayersPanel, right under the Header HStack
            if engine.musicManager.isPlaying {
                VStack(spacing: 10) {
                    Divider().background(Color.white.opacity(0.3))
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("NOW PLAYING")
                                .font(.caption2).bold()
                                .foregroundColor(.yellow)
                            Text(engine.currentSong?.title ?? "Jukebox Track")
                                .font(.system(size: 20, weight: .medium))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        // THE STOP BUTTON
                        Button {
                            engine.musicManager.stopMusic()
                        } label: {
                            Image(systemName: "stop.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(15)
                                .background(Color.red.opacity(0.8))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain) // Keeps it from looking like a giant card
                    }
                    .padding(.vertical, 10)
                    
                    Divider().background(Color.white.opacity(0.3))
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            // MARK: - Player List
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(engine.players) { player in
                        HStack {
                            Circle()
                                .fill(engine.currentChooser?.id == player.id ? Color.yellow : Color.clear)
                                .frame(width: 8, height: 8)
                            
                            Text(player.name)
                                .font(.system(size: 28, weight: engine.currentChooser?.id == player.id ? .bold : .medium))
                                .foregroundColor(engine.currentChooser?.id == player.id ? .yellow : .white)
                            
                            Spacer()
                            
                            Text("\(player.score)")
                                .font(.system(size: 24, weight: .black, design: .monospaced))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(engine.currentChooser?.id == player.id ? Color.white.opacity(0.1) : Color.clear)
                        .cornerRadius(10)
                    }
                }
            }

            Spacer()

            // MARK: - Administrative Controls (Conditional Visibility)
            if engine.phase == .result || engine.phase == .scoreboard {
                VStack(spacing: 15) {
                    // --- START OVER ---
                    Button {
                        engine.startGame(with: engine.players)
                        engine.players.indices.forEach { engine.players[$0].score = 0 }
                        music.resetPlayedSongs()
                        engine.phase = .lobby
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Start Over")
                        }
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .buttonStyle(.card)

                    // --- QUIT GAME ---
                    Button {
                        engine.phase = .setup
                        engine.players = []
                    } label: {
                        HStack {
                            Image(systemName: "xmark.circle")
                            Text("Quit Game")
                        }
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .buttonStyle(.card)
                }
                .padding(.bottom, 20)
                .transition(.move(edge: .bottom).combined(with: .opacity)) // Smooth slide-in
            } else {
                // Optional: Add a spacer to keep the Progress footer at the bottom
                // when the buttons are hidden
                Spacer().frame(height: 10)
            }
        

            // MARK: - Footer
            VStack(alignment: .leading, spacing: 5) {
                Text("PROGRESS")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.4))
                
                Text("Round \(engine.roundNumber) of \(engine.maxRounds)")
                    .font(.headline)
                    .foregroundColor(.yellow)
            }
            .padding(.bottom, 60)
        }
        .padding(.horizontal, 30)
        .frame(width: 350)
        .frame(maxHeight: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.black.opacity(0.4))
                
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            }
        )
        .padding(.leading, 40)
        .padding(.vertical, 60)
        .ignoresSafeArea()
    }
}
