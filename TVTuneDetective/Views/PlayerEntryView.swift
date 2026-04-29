import SwiftUI

struct PlayerEntryView: View {
    @ObservedObject var engine: GameEngine
    @State private var name: String = ""
    @FocusState private var focusedField: Field?
    
    enum Field { case entry, add, start }

    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(colors: [.black, .purple.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("🎮 Join the Game")
                    .font(.system(size: 80, weight: .black))
                    .padding(.top, 60)

                // MARK: - Input Section
                HStack(spacing: 20) {
                    TextField("Enter Player Name", text: $name)
                        .padding(.horizontal, 30)
                        .frame(width: 600, height: 100)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .focused($focusedField, equals: .entry)
                    
                    Button("Add") {
                        addPlayer()
                    }
                    .buttonStyle(.card)
                    .frame(width: 200, height: 100)
                    .focused($focusedField, equals: .add)
                }

                // MARK: - Player List (Chips)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(engine.players) { player in
                            Text(player.name)
                                .font(.headline)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 20)
                                .background(Capsule().fill(Color.yellow.opacity(0.8)))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 100)
                }
                .frame(height: 120)

                if engine.players.count >= 6 {
                    Text("⚠️ Maximum of 6 players reached")
                        .foregroundColor(.orange)
                        .font(.headline)
                }

                Spacer()

                // MARK: - Navigation Button
                // This is the CRITICAL change to show the Lobby
                // Inside PlayerEntryView.swift
                Button {
                    // This now calls the function we updated in Step 1
                    engine.finishSetup()
                } label: {
                    Text("Start the Show! ➡️")
                        .font(.title2).bold()
                        .frame(width: 500, height: 120)
                }
                .buttonStyle(.card)
                .tint(.green)
            }
        }
        .onAppear {
            focusedField = .entry
        }
    }

    private func addPlayer() {
        guard !name.isEmpty, engine.players.count < 6 else { return }
        engine.players.append(Player(name: name))
        name = ""
        focusedField = .entry // Keep focus on the text field for the next person
    }
}
