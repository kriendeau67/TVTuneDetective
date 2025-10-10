//
//  LobbyView.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/28/25.
//

import SwiftUI

struct LobbyView: View {
    @ObservedObject var engine: GameEngine

    var body: some View {
        VStack(spacing: 40) {
            // Game title
            Text("🎵 TV Tune Detective 🎵")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(.white)


            Spacer()
            // Start button
            Button(action: {
                engine.startGame(with: engine.players)
            
            }) {
                Text("Start Game")
                    .font(.title2).bold()
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

