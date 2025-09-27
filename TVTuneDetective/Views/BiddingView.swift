import SwiftUI

struct BiddingView: View {
    @ObservedObject var engine: GameEngine
    @State private var demoBids: [(Player, Int)] = []

    var body: some View {
        ZStack(alignment: .top) {
            // Main content
            VStack(spacing: 30) {
                Spacer().frame(height: 60) // leave space so header doesn’t overlap

                Text("🕑 Bidding Phase")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)

                if let genre = engine.currentGenre {
                    Text("Clue: \(genre.keywords?.first ?? genre.genre ?? "Unknown")")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }

                // Bid buttons
                VStack(spacing: 20) {
                    ForEach(engine.players) { player in
                        HStack(spacing: 16) {
                            Text(player.name)
                                .font(.title3).bold()
                                .frame(width: 100, alignment: .leading)
                                .foregroundColor(.white)

                            ForEach([3, 5, 7, 10], id: \.self) { seconds in
                                Button {
                                    demoBids.append((player, seconds))
                                } label: {
                                    Text("\(seconds)s")
                                        .font(.headline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }

                // Collected bids
                if !demoBids.isEmpty {
                    VStack(spacing: 8) {
                        Text("Bids so far:")
                            .font(.headline).foregroundColor(.white)
                        ForEach(demoBids, id: \.0.id) { bid in
                            Text("\(bid.0.name) → \(bid.1) seconds")
                                .foregroundColor(.white)
                        }
                    }
                }

               // Spacer()

                // Pick a winner manually for now
                if let winner = demoBids.last {
                    Button {
                        Task {
                            if let song = try? await MusicManager().fetchSong(for: engine.currentGenre!) {
                                engine.winningBid(player: winner.0, seconds: winner.1, song: song)
                            }
                        }
                    } label: {
                        Text("Finish Bidding → \(winner.0.name) wins")
                            .font(.title2).bold()
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()

            // ✅ Fixed header pinned to top

        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.purple, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}
