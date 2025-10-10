import SwiftUI

struct BiddingView: View {
    @ObservedObject var engine: GameEngine
    @State private var demoBids: [(Player, Int)] = []

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 30) {
                Spacer().frame(height: 60)

                // Phase header
                Text("🕑 Bidding Phase")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)

                // Clue
                if let genre = (engine.currentCriteria ?? engine.currentGenre) {
                    Text("Clue: \(genre.displayName)")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }

                // ✅ Each player row: name + 10 buttons
                VStack(spacing: 16) {
                    ForEach(engine.players) { player in
                        HStack(spacing: 6) {
                            Text(player.name)
                                .font(.headline).bold()
                                .frame(width: 90, alignment: .leading)
                                .foregroundColor(.white)

                            ForEach(1...10, id: \.self) { seconds in
                                Button {
                                    demoBids.append((player, seconds))
                                    engine.lowestBid = seconds   // 👈 record the latest lowest bid
                                } label: {
                                    Text("\(seconds)s")
                                        .font(.caption).bold()
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .background(isButtonEnabled(seconds) ? Color.green : Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                                .disabled(!isButtonEnabled(seconds))
                            }
                        }
                    }
                }
                .padding(.top, 20)

                // Collected bids (TV audience log)
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

                // ✅ Name That Tune button
                if let winner = demoBids.last {
                    Button {
                        Task {if let song = engine.currentSong {
                            engine.winningBid(
                                player: winner.0,
                                seconds: winner.1,
                                song: song
                            )
                        } else if let criteria = engine.currentCriteria ?? engine.currentGenre {
                            // Fallback (only if something went wrong)
                            if let song = try? await MusicManager().fetchSong(for: criteria) {
                                engine.currentSong = song
                                engine.winningBid(
                                    player: winner.0,
                                    seconds: winner.1,
                                    song: song
                                )
                            }
                        }
                        }
                    } label: {
                        Text("🎵Name That Tune → \(winner.0.name)")
                            .font(.title2).bold()
                            .padding(.horizontal, 40)
                            .padding(.vertical, 20)
                            .background(engine.playMode == .tvOnly ? Color.orange : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(engine.playMode != .tvOnly)
                    .padding(.top, 20)
                }
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
    }
    private func isButtonEnabled(_ seconds: Int) -> Bool {
        // No previous bids → all buttons enabled
        guard let lowest = engine.lowestBid else { return true }

        // Allow only lower bids
        return seconds < lowest
    }
}
