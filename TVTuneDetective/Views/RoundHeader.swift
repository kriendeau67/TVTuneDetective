//
//  RoundHeader.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 9/27/25.
//

import SwiftUI

import SwiftUI

struct RoundHeader: View {
    @ObservedObject var engine: GameEngine
    
    var body: some View {
        if engine.phase == .bidding ||
           engine.phase == .countdown ||
           engine.phase == .guessing ||
           engine.phase == .result ||
           engine.phase == .scoreboard {
            
            HStack {
                Spacer()
                Text("Round \(engine.roundNumber) of \(engine.maxRounds)")
                    .font(.title2).bold()
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.yellow)
                    .cornerRadius(12)
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}

struct RoundHUD: View {
    @ObservedObject var engine: GameEngine

    var body: some View {
        Text("Round \(engine.roundNumber) of \(engine.maxRounds)")
            .font(.title2).bold()
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .shadow(radius: 6)
            .allowsHitTesting(false)   // don’t interfere with focus
    }
}
