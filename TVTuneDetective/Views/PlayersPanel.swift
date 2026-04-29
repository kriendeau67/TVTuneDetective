import SwiftUI

struct PlayersPanel: View {
    @ObservedObject var engine: GameEngine

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            // MARK: - Header
            HStack(alignment: .center) {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.yellow)
                
                // Fixed: Added fixedSize to prevent "Play-ers" split
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
            .padding(.top, 60) // 👈 Increased top padding to match Bidding title height

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

            // MARK: - Footer
            VStack(alignment: .leading, spacing: 5) {
                Text("PROGRESS")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.4))
                
                Text("Round \(engine.roundNumber) of \(engine.maxRounds)")
                    .font(.headline)
                    .foregroundColor(.yellow)
            }
            .padding(.bottom, 60) // 👈 Increased bottom padding for symmetry
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
                    // 👈 DELETE THE .padding(.vertical, 60) FROM HERE
                )
                .padding(.leading, 40)
                .padding(.vertical, 60) // 👈 ADD IT HERE INSTEAD
                .ignoresSafeArea()
    }
}

