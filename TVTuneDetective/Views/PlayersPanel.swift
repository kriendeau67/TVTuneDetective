import SwiftUI

struct PlayersPanel: View {
    @ObservedObject var engine: GameEngine   // 👈 observe the engine directly

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.white)
                Text("Players (\(engine.players.count))")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding(.top)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(engine.players) { player in
                        HStack {
                            Text(player.name)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(player.score) pts")   // ✅ auto-updates
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal)
                    }
                }
            }
            Spacer()
            // Round number at the very bottom
                       Text("Round \(engine.roundNumber) of \(engine.maxRounds)")
                           .font(.footnote).bold()
                           .foregroundColor(.white.opacity(0.9))
                           .padding(.horizontal)
                           .padding(.bottom, 8)
        }
        .frame(maxWidth: 300, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.purple.opacity(0.8))
        )
        .shadow(radius: 8)
    }
}
