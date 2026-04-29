import SwiftUI

struct ScoreboardView: View {
    @ObservedObject var engine: GameEngine
    
    var body: some View {
        ZStack {
            // MARK: - Background Layer
            // Cleared to let the global ContentView background show through
            Color.clear.ignoresSafeArea()

            VStack(spacing: 40) {
                // Header matched to other phases
                Text("🏆 Final Scoreboard 🏆")
                    .font(.system(size: 70, weight: .black))
                    .foregroundColor(.yellow)
                    .padding(.top, 60) // 👈 Matches sidebar top padding
                
                Spacer()

                VStack(spacing: 20) {
                    ForEach(engine.players.sorted(by: { $0.score > $1.score })) { player in
                        HStack {
                            Text(player.name)
                                .font(.title2).bold()
                                .frame(width: 300, alignment: .leading)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(player.score) pts")
                                .font(.title2).bold()
                                .foregroundColor(.green)
                        }
                        .padding(30)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .frame(maxWidth: 800) // Widen for better TV legibility
                    }
                }
                
                Spacer()
                
                // MARK: - Action Button
                // Swapped to .buttonStyle(.card) for native TV focus/glow effect
                Button {
                    engine.phase = .lobby
                    engine.roundNumber = 1
                    engine.players.indices.forEach { engine.players[$0].score = 0 }
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("New Game")
                    }
                    .font(.title2).bold()
                    .frame(width: 450, height: 120)
                }
                .buttonStyle(.card)
                .tint(.blue)
                .padding(.bottom, 80)
            }
        }
    }
}
