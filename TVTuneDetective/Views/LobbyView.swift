import SwiftUI

struct LobbyView: View {
    @ObservedObject var engine: GameEngine
    private let qrManager = QRManager()
    private let joinURL = URL(string: "http://192.168.1.10:8080/join")! // placeholder

    var body: some View {
        VStack(spacing: 40) {
            Text("🎵 TV Tune Detective 🎵")
                .font(.system(size: 40, weight: .bold, design: .rounded))

            if let qrImage = qrManager.makeCGImage(from: joinURL) {
                Image(decorative: qrImage, scale: 1, orientation: .up)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 8)
            }

            Text("Scan to Join!")
                .font(.title2)
                .bold()
                .foregroundColor(.yellow)

            Button(action: {
                // For now, use demo players. Later this comes from phones.
                let demoPlayers = [
                    Player(name: "Sue"),
                    Player(name: "Ken"),
                    Player(name: "Makeda"),
                    Player(name: "Casper")
                ]
                engine.startGame(with: demoPlayers)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
