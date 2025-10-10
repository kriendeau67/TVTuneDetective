//
//  PlayerEntryView.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 10/10/25.
//
import SwiftUI

struct PlayerEntryView: View {
    @ObservedObject var engine: GameEngine
    @State private var name: String = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("🎮 Add Player")
                .font(.largeTitle).bold()

            TextField("Enter name", text: $name)
                .padding(.horizontal, 20)
                .frame(width: 400, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .foregroundColor(.white)
                .focused($focused)
                .onAppear { focused = true }

            Button("Add Player") {
                guard !name.isEmpty else { return }
                if engine.players.count < 6 {
                    engine.players.append(Player(name: name))
                    name = ""
                }
            }
            .buttonStyle(.borderedProminent)

            if engine.players.count >= 6 {
                Text("⚠️ Max 6 players reached")
                    .foregroundColor(.yellow)
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                ForEach(engine.players) { player in
                    Text("• \(player.name)")
                        .font(.title3)
                }
            }

            Spacer()

            Button("Start Game") {
                engine.startGame(with: engine.players)
            }
            .font(.title2.bold())
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(engine.players.isEmpty)
        }
        .padding(60)
    }
}
