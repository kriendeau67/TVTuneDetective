import SwiftUI

struct ContentView: View {
    @ObservedObject var engine: GameEngine

    var body: some View {
        ZStack {
            // Main layout (players + phase content)
            HStack(spacing: 40) {
                PlayersPanel(engine: engine)

                Spacer()

                NavigationStack {
                    switch engine.phase {
                    case .lobby:
                        LobbyView(engine: engine)
                    case .genreSelect:
                        GenreMenuView(engine: engine)
                    case .bidding:
                        BiddingView(engine: engine)
                    case .countdown:
                        CountdownView(engine: engine)
                    case .guessing:
                        GuessingView(engine: engine)
                    case .result:
                        ResultsView(engine: engine)
                    case .scoreboard:
                        ScoreboardView(engine: engine)
                    }
                }
            }
            .padding()

            // 👇 Overlay HUD — pinned absolutely at the top
    
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
