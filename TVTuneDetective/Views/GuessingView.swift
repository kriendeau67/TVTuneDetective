import SwiftUI
import MusicKit

struct GuessingView: View {
    @ObservedObject var engine: GameEngine
    
    @State private var guessArtist: String = ""
    @State private var guessTitle: String = ""
    
    // Focus management for the Apple TV remote
    @FocusState private var focusedField: Field?
    enum Field { case artist, title, submit }
    
    var body: some View {
            ZStack {
                // MARK: - Background Layer
                // Cleared to let the ContentView background shine through
                Color.clear.ignoresSafeArea()

                VStack(spacing: 40) {
                    if let player = engine.currentBidder,
                       let song = engine.currentSong {
                        
                        // MARK: - Header
                        VStack(spacing: 15) {
                            Text("🎤 \(player.name), your turn!")
                                .font(.system(size: 70, weight: .black))
                                .foregroundColor(.yellow)
                            
                            Text("Enter your guess below")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(.top, 60) // 👈 Matches sidebar top padding

                        Spacer()

                        // MARK: - Input Area
                        VStack(spacing: 40) {
                            // Artist TextField
                            VStack(alignment: .leading, spacing: 15) {
                                Text("ARTIST")
                                    .font(.system(size: 20, weight: .bold)).tracking(4)
                                    .foregroundColor(.yellow.opacity(0.8))
                                
                                TextField("Who sang it?", text: $guessArtist)
                                    .padding(.horizontal, 30)
                                    .frame(width: 900, height: 110)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(20)
                                    .focused($focusedField, equals: .artist)
                            }

                            // Title TextField
                            VStack(alignment: .leading, spacing: 15) {
                                Text("SONG TITLE")
                                    .font(.system(size: 20, weight: .bold)).tracking(4)
                                    .foregroundColor(.yellow.opacity(0.8))
                                
                                TextField("What's the name of the tune?", text: $guessTitle)
                                    .padding(.horizontal, 30)
                                    .frame(width: 900, height: 110)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(20)
                                    .focused($focusedField, equals: .title)
                            }
                        }

                        Spacer()

                        // MARK: - Action Button
                        Button {
                            evaluateGuess(for: player, actual: song)
                        } label: {
                            HStack(spacing: 25) {
                                Image(systemName: "checkmark.seal.fill")
                                Text("Submit Final Guess")
                                    .font(.title2).bold()
                            }
                            .frame(width: 600, height: 140)
                        }
                        .buttonStyle(.card)
                        .tint(.orange)
                        .focused($focusedField, equals: .submit)
                        .padding(.bottom, 80)
                        
                    } else {
                        Text("⚠️ No active guesser found")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                focusedField = .artist
            }
        }

    // MARK: - Logic Functions (No changes to your normalization/scoring)

    private func normalize(_ text: String) -> String {
        return text
            .lowercased()
            .replacingOccurrences(of: "&", with: "and")
            .replacingOccurrences(of: "the ", with: "")
            .replacingOccurrences(of: "[^a-z0-9 ]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func evaluateGuess(for player: Player, actual song: MusicKit.Song) {
        let actualArtist = normalize(song.artistName)
        let actualTitle = normalize(song.title)
        
        let guessedArtist = normalize(guessArtist)
        let guessedTitle = normalize(guessTitle)
        
        var points = 0
        var breakdown: [String] = []

        // Artist scoring
        if !guessedArtist.isEmpty {
            if actualArtist.contains(guessedArtist) || guessedArtist.contains(actualArtist) {
                points += 10
                breakdown.append("+10 (Artist correct)")
            } else {
                points -= 5
                breakdown.append("-5 (Artist wrong)")
            }
        }
        
        // Title scoring
        if !guessedTitle.isEmpty {
            if actualTitle.contains(guessedTitle) || guessedTitle.contains(actualTitle) {
                points += 10
                breakdown.append("+10 (Title correct)")
            } else {
                points -= 5
                breakdown.append("-5 (Title wrong)")
            }
        }
        
        engine.lastResult = GameEngine.RoundResult(player: player, song: song, points: points, breakdown: breakdown)
        
        if let index = engine.players.firstIndex(where: { $0.id == player.id }) {
            engine.players[index].score += points
        }
        
        engine.finishRound(correct: points > 0)
    }
}
