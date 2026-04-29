import SwiftUI
import MusicKit

struct ResultsView: View {
    @ObservedObject var engine: GameEngine

        
        // Links focus for the native Apple TV focus engine
        @FocusState private var isNextRoundFocused: Bool

    var body: some View {
            ZStack {
                // MARK: - Background Layer
                // Cleared so the ContentView's deep blue/black shows through
                Color.clear.ignoresSafeArea()

                if let result = engine.lastResult {
                    VStack(spacing: 0) {
                        
                        // MARK: - Header
                        HStack {
                            Image(systemName: "music.note.list")
                            Text("Round Results")
                        }
                        .font(.system(size: 70, weight: .black)) // Matched size to other phases
                        .foregroundColor(.white)
                        .padding(.top, 60) // 👈 Anchor point to match sidebar

                        // MARK: - The Result Card
                        // We keep the card, but make it "Glass" instead of solid black
                        VStack(spacing: 30) {
                            
                            VStack(spacing: 15) {
                                Text(result.song.title)
                                    .font(.system(size: 80, weight: .black))
                                    .foregroundColor(.yellow)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.8)
                                
                                Text(result.song.artistName)
                                    .font(.system(size: 50, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.75)
                            }
                            .padding(.horizontal, 80)
                            
                            Divider()
                                .background(Color.white.opacity(0.3))
                                .padding(.horizontal, 120)

                            // Player Points summary
                            VStack(spacing: 15) {
                                Text(result.player.name)
                                    .font(.system(size: 40, weight: .medium))
                                
                                HStack(spacing: 20) {
                                    if result.points > 0 {
                                        Text("✅ +\(result.points) pts").foregroundColor(.green)
                                    } else if result.points < 0 {
                                        Text("❌ \(result.points) pts").foregroundColor(.red)
                                    } else {
                                        Text("⚪ 0 pts").foregroundColor(.gray)
                                    }
                                }
                                .font(.system(size: 70, weight: .black, design: .rounded))
                            }
                        }
                        .padding(60)
                        // MARK: - Glass Effect (Matching your sidebar style)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white.opacity(0.05))
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            }
                        )
                        .padding(.horizontal, 100)
                        .padding(.top, 50)

                        Spacer()

                        // MARK: - Action Button
                        Button {
                            engine.nextRound()
                        } label: {
                            HStack {
                                Text("Next Round")
                                Image(systemName: "chevron.right.circle.fill")
                            }
                            .font(.title2).bold()
                            .frame(width: 450, height: 120)
                        }
                        .buttonStyle(.card)
                        .focused($isNextRoundFocused)
                        .padding(.bottom, 80)
                    }
                } else {
                    Text("⚠️ No result available")
                        .foregroundColor(.red)
                }
            }
            .onAppear {
                isNextRoundFocused = true
            }
        }
    }

