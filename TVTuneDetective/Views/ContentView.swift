import SwiftUI

struct ContentView: View {
    @ObservedObject var engine: GameEngine

    var body: some View {
        ZStack {
            // MARK: - Global Background
            // We use a very dark base so the "Glass" effect on your cards pops
            Color.black.ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // MARK: - Main Layout
            HStack(alignment: .top, spacing: 0) {
                
                // Hide the sidebar during the Lobby (Intro) to keep it cinematic
                if engine.phase != .lobby && engine.phase != .setup {
                    PlayersPanel(engine: engine)
                        .transition(.move(edge: .leading))
                }

                // The Main Game Window
                NavigationStack {
                    ZStack {
                        // Clear background so the global background shows through
                        Color.clear
                        
                        switch engine.phase {
                        case .setup:
                            PlayerEntryView(engine: engine)
                        case .modeSelect:
                            ModeSelectView(engine: engine) // 👈 The new fork in the road
                        case .jukebox:
                            JukeboxSearchView(engine: engine) // 👈 We'll build this next
                        case .lobby:
                            LobbyView(engine: engine)
                        case .genreSelect:
                            GenreMenuView(engine: engine)
                        case .hint:
                            HintView(engine: engine)
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
                .padding(.top, 60)
                .ignoresSafeArea()
                .animation(.easeInOut, value: engine.phase)
            }
        }
    }
}
