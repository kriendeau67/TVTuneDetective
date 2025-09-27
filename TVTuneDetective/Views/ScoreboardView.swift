//
//  ScoreboardView.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/26/25.
//

import SwiftUI

struct ScoreboardView: View {
    @ObservedObject var engine: GameEngine
    
    var body: some View {
        VStack(spacing: 40) {
            Text("🏆 Final Scoreboard 🏆")
                .font(.largeTitle).bold()
                .foregroundColor(.yellow)
            
            ForEach(engine.players.sorted(by: { $0.score > $1.score })) { player in
                HStack {
                    Text(player.name)
                        .font(.title2).bold()
                        .frame(width: 200, alignment: .leading)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(player.score) pts")
                        .font(.title2).bold()
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                .frame(maxWidth: 500)
            }
            
            Button {
                engine.phase = .lobby
                engine.roundNumber = 1
                engine.players.indices.forEach { engine.players[$0].score = 0 } // reset
            } label: {
                Text("🔄 New Game")
                    .font(.title2).bold()
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding()
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
