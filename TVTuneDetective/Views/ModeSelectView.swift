//
//  ModeSelectView.swift
//  TVTuneDetective
//
//  Created by Kenneth Riendeau on 5/4/26.
//
import SwiftUI

struct ModeSelectView: View {
    @ObservedObject var engine: GameEngine
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .blue.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 60) {
                Text("Select Your Experience")
                    .font(.system(size: 80, weight: .black))
                
                HStack(spacing: 60) {
                    // ACTION: Play the Game
                    Button {
                        engine.pickNextChooser()
                        engine.phase = .genreSelect
                    } label: {
                        VStack(spacing: 30) {
                            Image(systemName: "gamecontroller.fill")
                                .font(.system(size: 100))
                            Text("Play the Game")
                                .font(.title)
                        }
                        .frame(width: 500, height: 500)
                    }
                    .buttonStyle(.card)
                    
                    // ACTION: Open the Jukebox
                    Button {
                        engine.phase = .jukebox
                    } label: {
                        VStack(spacing: 30) {
                            Image(systemName: "music.note.list")
                                .font(.system(size: 100))
                            Text("Jukebox Mode")
                                .font(.title)
                        }
                        .frame(width: 500, height: 500)
                    }
                    .buttonStyle(.card)
                }
            }
        }
    }
}
