import SwiftUI

struct BiddingView: View {
    @ObservedObject var engine: GameEngine
    @State private var demoBids: [(Player, Int)] = []

    // 5 columns makes the buttons nice and big for TV
    let columns = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()),
        GridItem(.flexible()), GridItem(.flexible())
    ]

    var body: some View {
            ZStack {
                // MARK: - Background Layer
                // Changed to Color.clear so the ContentView background shows through
                Color.clear.ignoresSafeArea()

                VStack(spacing: 20) {
                    // MARK: - Header & Clue
                    VStack(spacing: 10) {
                        Text("🕑 Bidding Phase")
                            .font(.system(size: 70, weight: .black)) // Matched size to Genre/Hint
                        
                        if let genre = (engine.currentCriteria ?? engine.currentGenre) {
                            Text("Category: \(genre.displayName)")
                                .font(.title2)
                                .foregroundColor(.yellow)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top, 60) // 👈 Anchor point to match sidebar top

                    ScrollView {
                        VStack(spacing: 40) {
                            // MARK: - Player Bidding Rows
                            ForEach(engine.players) { player in
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("👤 \(player.name)'s Bid")
                                        .font(.headline)
                                        .padding(.leading, 20)

                                    LazyVGrid(columns: columns, spacing: 20) {
                                        ForEach(1...10, id: \.self) { seconds in
                                            Button {
                                                demoBids.append((player, seconds))
                                                engine.lowestBid = seconds
                                            } label: {
                                                Text("\(seconds)s")
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 80)
                                            }
                                            .buttonStyle(.card)
                                            .disabled(!isButtonEnabled(seconds))
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal, 80)
                        .padding(.top, 20)
                    }

                    // MARK: - Action Button
                    if let winner = demoBids.last {
                        Button {
                            handleWinningBid(winner: winner)
                        } label: {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("I'll Name That Tune in \(winner.1)s, \(winner.0.name)!")
                            }
                            .font(.title3).bold()
                            .padding(.horizontal, 50)
                            .frame(height: 120)
                        }
                        .buttonStyle(.card)
                        .tint(.orange)
                        .padding(.bottom, 60)
                    }
                }
            }
        }

    private func isButtonEnabled(_ seconds: Int) -> Bool {
        guard let lowest = engine.lowestBid else { return true }
        return seconds < lowest
    }

    private func handleWinningBid(winner: (Player, Int)) {
        Task {
            if let song = engine.currentSong {
                engine.winningBid(player: winner.0, seconds: winner.1, song: song)
            } else if let criteria = engine.currentCriteria ?? engine.currentGenre {
                if let song = try? await MusicManager().fetchSong(for: criteria) {
                    engine.currentSong = song
                    engine.winningBid(player: winner.0, seconds: winner.1, song: song)
                }
            }
        }
    }
}
