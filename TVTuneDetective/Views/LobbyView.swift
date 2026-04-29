import SwiftUI

struct LobbyView: View {
    @ObservedObject var engine: GameEngine
    
    var body: some View {
        ZStack {
            // MARK: - Background Layer
            LinearGradient(colors: [.black, .purple.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            // Decorative Music Notes in background
            Image(systemName: "music.quaver.list")
                .font(.system(size: 600))
                .foregroundColor(.white.opacity(0.03))
                .offset(x: 400, y: 200)

            VStack(spacing: 60) {
                // MARK: - Hero Header
                VStack(spacing: 10) {
                    Text("🎵")
                        .font(.system(size: 100))
                    
                    Text("TV TUNE")
                        .font(.system(size: 120, weight: .black))
                        .tracking(10)
                    
                    Text("DETECTIVE")
                        .font(.system(size: 80, weight: .light))
                        .tracking(25)
                        .foregroundColor(.yellow)
                }
                .padding(.top, 100)
                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)

                // MARK: - Player Status
                if !engine.players.isEmpty {
                    VStack(spacing: 20) {
                        Text("READY TO PLAY")
                            .font(.headline)
                            .tracking(2)
                            .foregroundColor(.white.opacity(0.6))
                        
                        HStack(spacing: 30) {
                            ForEach(engine.players) { player in
                                Text(player.name)
                                    .font(.title3).bold()
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 15)
                                    .background(Capsule().fill(Color.white.opacity(0.1)))
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()

                // MARK: - Start Button
                // Inside LobbyView.swift
                Button {
                    withAnimation {
                        engine.phase = .setup // Move to the "Join the Game" screen
                    }
                } label: {
                    HStack(spacing: 25) {
                        Image(systemName: "person.badge.plus")
                        Text("Join Game") // Changed from "Start Game"
                    }
                    .frame(width: 600, height: 180)
                }
                .buttonStyle(.card)
               .padding(.bottom, 120)
            }
        }
    }
}
